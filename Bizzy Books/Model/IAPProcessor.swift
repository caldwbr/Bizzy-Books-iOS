//
//  IAPProcessor.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/6/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import StoreKit
import Freddy
import Firebase

class IAPProcessor: NSObject {
    static let shared = IAPProcessor()
    
    public var sharedSecret = "c4d9ead54d16438ab780ce6b00d89a8f"
    public var productIdentifier : String = "1002pro" { // Did I find the right "productIdentifier"?? Is it "1321694172" or "1321692215" or "1002pro"? Apparently, "1002pro" is the id that they wanted to see.
        didSet {
            searchForProduct()
        }
    }
    
    // We store the callback for the delegate calls
    var completionBlock: ((Bool, String?, Error?) -> Void)?
    
    let paymentQueue = SKPaymentQueue.default()
    var product : SKProduct?
    
    var runningRequest : SKProductsRequest?
    
    public var availableForPurchase : Bool {
        return !(product == nil)
    }
    
    public func startListening() {
        paymentQueue.add(self)
        searchForProduct()
    }
    
    //Have I placed these two in the right location?!? Taken from www.bignerdranch.com/blog/monetizing-your-apps-with-apples-in-app-purchases/
    public func purchase(completion: @escaping (Bool, String?, Error?) -> Void) {
        if let product = product {
            if SKPaymentQueue.canMakePayments() {
                completionBlock = completion
                let payment = SKPayment(product: product)
                paymentQueue.add(payment);
            } else {
                completion(false, "User cannot make payments", nil)
                //Do I need to present a self.alert here to notify user to enable in-app purchases in their settings??
            }
        } else {
            completion(false, "Product not found.", nil)
        }
    }
    
    public func restorePurchases(completion: @escaping (Bool, String?, Error?) -> Void) {
        self.completionBlock = completion
        paymentQueue.restoreCompletedTransactions() //I think this is where you want to enable the camera.
    }
}

//Search for the pro subscription on iTunesConnect
extension IAPProcessor : SKProductsRequestDelegate, SKRequestDelegate {
    func searchForProduct() {
        let productIdentifiers = Set([productIdentifier])
        let productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self;
        productsRequest.start()
        runningRequest = productsRequest
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        NSLog("Request fail \(error)")
        runningRequest = nil
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let productsFromResponse = response.products
        NSLog("Search for Products received response, \(productsFromResponse.count) objects")
        
        if let product = productsFromResponse.first {
            self.product = product
        }
        runningRequest = nil
    }
}

//Find out whether the user bought the pro subscription or not
extension IAPProcessor : SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var currentlySubscribedRef: DatabaseReference!
        currentlySubscribedRef = Database.database().reference().child("users").child(userUID).child("currentlySubscribed")
        NSLog("Received \(transactions.count) updated transactions")
        var shouldProcessReceipt = false
        for trans in transactions where trans.payment.productIdentifier == self.productIdentifier {
            switch trans.transactionState {
            case .purchased, .restored:
                shouldProcessReceipt = true
                currentlySubscribedRef.setValue(true)
                paymentQueue.finishTransaction(trans)
            case .failed:
                NSLog("Transaction failed!")
                currentlySubscribedRef.setValue(false)
                if let block = completionBlock {
                    block(false, "The purchase failed.", trans.error)
                }
                paymentQueue.finishTransaction(trans)
            default:
                NSLog("Not sure what to do with that")
            }
        }
        if (shouldProcessReceipt) {
            processReceipt()
        }
    }
}

//For subscriptions which is what I'm doing
extension IAPProcessor {
    func processReceipt() {
        if let receiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: receiptURL.path) {
            
            expirationDateFromProd(completion: { (date, sandbox, error) in
                if let error = error {
                    self.completionBlock?(false, "The purchase failed.", error)
                } else if let date = date, Date().compare(date) == .orderedAscending {
                    self.completionBlock?(true, self.productIdentifier, nil)
                }
            })
        } else {
            let request = SKReceiptRefreshRequest(receiptProperties: nil)
            request.delegate = self
            request.start()
        }
    }
}

//Detect whether it's a sandbox (trial) or real purchase
enum RequestURL: String {
    case production = "https://buy.itunes.apple.com/verifyReceipt"
    case sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
}

extension IAPProcessor {
    func expirationDateFromProd(completion: @escaping (Date?, Bool, Error?) -> Void) {
        if let requestURL = URL(string: RequestURL.production.rawValue) {
            expirationDate(requestURL) { (expiration, status, error) in
                if status == 21007 {
                    self.expirationDateFromSandbox(completion: completion)
                } else {
                    completion(expiration, false, error)
                }
            }
        }
    }
    
    func expirationDateFromSandbox(completion: @escaping (Date?, Bool, Error?) -> Void) {
        if let requestURL = URL(string: RequestURL.sandbox.rawValue) {
            expirationDate(requestURL) { (expiration, status, error) in
                completion(expiration, true, error)
            }
        }
    }
    
    func expirationDate(_ requestURL: URL, completion: @escaping (Date?, Int?, Error?) -> Void) {
        guard let receiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: receiptURL.path) else {
            NSLog("No receipt available to submit")
            completion(nil, nil, nil)
            return;
        }
        
        do {
            let request = try receiptValidationRequest(for: requestURL)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                var code : Int = -1
                var date : Date?
                
                if let error = error {
                    if let httpR = response as? HTTPURLResponse {
                        code = httpR.statusCode
                    }
                } else if let data = data {
                    (code, date) = self.extractValues(from: data)
                } else {
                    NSLog("No response!")
                }
                completion(date, code, error)
                }.resume()
        } catch let error {
            completion(nil, -1, error)
        }
    }
    
    func receiptValidationRequest(for requestURL: URL) throws -> URLRequest {
        let receiptURL = Bundle.main.appStoreReceiptURL!
        let receiptData : Data = try Data(contentsOf:receiptURL)
        let payload = ["receipt-data": receiptData.base64EncodedString().toJSON(),
                       "password" : sharedSecret.toJSON()]
        let serializedPayload = try JSON.dictionary(payload).serialize()
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.httpBody = serializedPayload
        
        return request
    }
    
    func extractValues(from data: Data) -> (Int, Date?) {
        var date : Date?
        var statusCode : Int = -1
        
        do {
            let jsonData = try JSON(data: data)
            statusCode = try jsonData.getInt(at: "status")
            
            let receiptInfo = try jsonData.getArray(at: "latest_receipt_info")
            if let lastReceipt = receiptInfo.last {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                date = formatter.date(from: try lastReceipt.getString(at: "expires_date"))
            }
        } catch {
        }
        
        return (statusCode, date)
    }
}
