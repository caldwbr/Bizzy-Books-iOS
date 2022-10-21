//
//  DocumentsViewController.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 1/21/20.
//  Copyright © 2020 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import SimplePDF
import WebKit

class DocumentsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,
                                UIWebViewDelegate {
    
    
    // MARK: - Model
    
    fileprivate var items = [EstimateItem]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var documentViewActivitySpinner: UIActivityIndicatorView!
    
    var documentPickerData: [String] = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return documentPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedDocument = documentPickerData[row]
        return selectedDocument
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDocument = documentPickerData[row]
        switch row {
        case 0: //Estimate
            generateEstimate()
        case 1: //Contract
            generateContract()
        case 2: //Invoice/Receipt
            generateInvoice()
        case 3: //Warranty
            generateWarranty()
        default:
            generateEstimate()
        }
    }
    
    func generateEstimate() {
        
    }
    
    func generateContract() {
        
    }
    
    func generateInvoice() {
        
    }
    
    func generateWarranty() {
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        documentViewActivitySpinner.startAnimating()
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        documentViewActivitySpinner.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("To ERR is human")
        documentViewActivitySpinner.stopAnimating()
    }

    let documentInteractionController = UIDocumentInteractionController()
    
    var reportViewYearPickerData: [String] = [String]()
    var selectedDocument = "Estimate"
    
    @IBAction func projectTextFieldAction(_ sender: Any) {
    }
    
    @IBOutlet weak var documentPickerView: UIPickerView!
    
    @IBAction func shareDocumentPressed(_ sender: UIBarButtonItem) {
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentInteractionController.delegate = self as? UIDocumentInteractionControllerDelegate
        documentPickerData = ["Estimate", "Contract", "Invoice", "Warranty"]
        documentPickerView.dataSource = self
        documentPickerView.delegate = self
        documentPickerView.selectRow(0, inComponent: 0, animated: false)
        //webView.delegate = self // UIWebView had this, WKWebView (newer one) doesn't
        documentViewActivitySpinner.hidesWhenStopped = true
        selectedDocument = documentPickerData[documentPickerView.selectedRow(inComponent: 0)]
        registerTableViewCellNibs()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func registerTableViewCellNibs() {
        tableView.register(UINib(nibName: "EstimateItemViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    fileprivate func estimateItem(atIndexPath indexPath: IndexPath) -> EstimateItem {
        return items[indexPath.row]
    }
    
    fileprivate func index(ofEstimateItemAtIndexPath indexPath: IndexPath) -> Int {
        return indexPath.row
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("reloading table view, cell count: \(items.count)")
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EstimateItemViewCell
        let item = estimateItem(atIndexPath: indexPath)
        cell.configure(item: item)
        print("dequeueReusableCell item: \(item)")
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = Bundle.main.loadNibNamed("AddEstimateItemCell", owner: nil, options: nil)?.first as? AddEstimateItemCell else { return nil }
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44.0
    }
    
}


extension DocumentsViewController: EstimateItemViewCellDelegate {
    
    func didRemoveEstimateItem(_ item: EstimateItem, atCell cell: EstimateItemViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        // TODO: add a dialog and then on the confirmation do this:
        tableView.beginUpdates()
        items.remove(at: index(ofEstimateItemAtIndexPath: indexPath))
        tableView.deleteRows(at: [indexPath], with: .automatic)
        print("didRemoveEstimateItem item: \(item)")
        tableView.endUpdates()
    }
    
}

extension DocumentsViewController: AddEstimateItemCellDelegate {
    
    func didAddEstimateItem() {
        // TODO: add the popup screen
        /*
        var item = EstimateItem()
        item.quantity = Int(arc4random() % 10)
        item.totalPrice = Int(arc4random() % 500)
        
        print("didAddEstimateItem")
        tableView.beginUpdates()
        let newIndexPath = IndexPath(row: items.count, section: 0)
        items.append(item)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.endUpdates()
        */
    }
    
}
