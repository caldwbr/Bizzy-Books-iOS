//
//  ContactsLogicManager.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 7/3/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import Contacts

class ContactsLogicManager: NSObject {
    
    static let shared = ContactsLogicManager() //Singleton or "shared value"

    //let contacts = [CNContact]()
    let contactStore = CNContactStore()
    let keys = [CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactGivenNameKey, CNContactFamilyNameKey]
    
    func fetchContactsMatching(name: String, completion: @escaping (_ contacts: [CNContact]?) -> Void) {
        contactStore.requestAccess(for: .contacts) { (granted, error) in
            if granted {
                //let request = CNContactFetchRequest(keysToFetch: self.keys as [CNKeyDescriptor])
                let predicate = CNContact.predicateForContacts(matchingName: name)
                if let fetchedContacts = try? self.contactStore.unifiedContacts(matching: predicate, keysToFetch: self.keys as [CNKeyDescriptor]) {
                    DispatchQueue.main.async {
                        completion(fetchedContacts)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
