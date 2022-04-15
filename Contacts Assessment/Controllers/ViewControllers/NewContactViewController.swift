//
//  NewContactViewController.swift
//  Contacts Assessment
//
//  Created by Sebastian Banks on 4/15/22.
//

import UIKit

class NewContactViewController: UIViewController {
    
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    var contact: Contact?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func confirmButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty,
              let email = emailTextField.text
        else {
            print("something went wrong")
            return
        }
        
        if let contact = contact {
            contact.contactName = name
            contact.phoneNumber = phoneNumber
            contact.email = email
            print(contact.contactName)
            ContactController.shared.update(contact) { success in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            print("new contact")
            ContactController.shared.saveContact(name: name, email: email, phoneNumber: phoneNumber) { success in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func updateView() {
        if let contact = contact {
            confirmButton.setTitle("Update", for: .normal)
            confirmButton.layer.cornerRadius = confirmButton.frame.height / 2
            nameTextField.text = contact.contactName
            phoneNumberTextField.text = contact.phoneNumber
            emailTextField.text = contact.email
        } else {
            confirmButton.setTitle("Add", for: .normal)
            confirmButton.layer.cornerRadius = confirmButton.frame.height / 2
        }
    }
    

}
