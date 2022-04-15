//
//  Contact.swift
//  Contacts Assessment
//
//  Created by Sebastian Banks on 4/15/22.
//

import Foundation
import CloudKit

struct ContactStrings {
    static let recordTypeKey = "Contact"
    fileprivate static let contactNameKey = "contactName"
    fileprivate static let phoneNumberKey = "phoneNumber"
    fileprivate static let emailKey = "email"
}

class Contact {
    
    var contactName: String
    var phoneNumber: String
    var email: String?
    
    var recordID: CKRecord.ID
    
    init(contactName: String, phoneNumber: String, email: String? = "", recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.contactName = contactName
        self.phoneNumber = phoneNumber
        self.email = email
        self.recordID = recordID
    }
}

extension Contact {
    convenience init?(ckRecord: CKRecord) {
        guard let contactName = ckRecord[ContactStrings.contactNameKey] as? String,
              let phoneNumber = ckRecord[ContactStrings.phoneNumberKey] as? String,
              let email = ckRecord[ContactStrings.emailKey] as? String
        else { return nil}
        
        self.init(contactName: contactName, phoneNumber: phoneNumber, email: email, recordID: ckRecord.recordID)
    }
}

extension Contact: Equatable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: ContactStrings.recordTypeKey, recordID: contact.recordID)
        self.setValuesForKeys([
            ContactStrings.contactNameKey : contact.contactName,
            ContactStrings.phoneNumberKey : contact.phoneNumber,
            ContactStrings.emailKey : contact.email
        ])
    }
}
