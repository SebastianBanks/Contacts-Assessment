//
//  ContactController.swift
//  Contacts Assessment
//
//  Created by Sebastian Banks on 4/15/22.
//

import Foundation
import CloudKit

class ContactController {
    
    static let shared = ContactController()
    var contacts: [Contact] = []
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    func saveContact(name: String, email: String?, phoneNumber: String, completion: @escaping (Bool) -> Void) {
        
        let newContact = Contact(contactName: name, phoneNumber: phoneNumber, email: email)
        let contactRecord = CKRecord(contact: newContact)
        
        privateDB.save(contactRecord) { record, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let record = record,
                  let savedContact = Contact(ckRecord: record)
            else { completion(false) ; return }
            
            print("Saved Contact Successfully")
            self.contacts.append(savedContact)
            completion(true)

        }
    }
    
    func fetchContacts(completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactStrings.recordTypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { records, error in
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false) ; return }
            print("Fetched all contacts")
            let fetchedContacts = records.compactMap { Contact(ckRecord: $0)}
            self.contacts = fetchedContacts
            completion(true)
        }
    }
    
    func update(_ contact: Contact, completion: @escaping (Bool) -> Void) {
        
        let recordToUpdate = CKRecord(contact: contact)
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let record = records?.first else { completion(false) ; return }
            print("Update \(record.recordID.recordName) successfully in ICloud")
            completion(true)
        }
        privateDB.add(operation)
    }
    
    func delete(_ contact: Contact, completion: @escaping (Bool) -> Void) {
        
        let operation = CKModifyRecordsOperation( recordIDsToDelete: [contact.recordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (recordIDs, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                completion(false)
                return
            }
            
            guard let recordIDs = recordIDs else { completion(false) ; return }
            print("\(recordIDs) were removed successfully in ICloud")
            completion(true)
        }
        
        privateDB.add(operation)
    }
        
    
}
