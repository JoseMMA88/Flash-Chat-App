//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Jose Manuel Malagón Alba on 01/11/2023.
//  Copyright © 2023 Jose Manuel Malagón Alba. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    //MARK: - ViewController Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideErrorLabel()
    }
    
    //MARK: - Functions
    
    private func hideErrorLabel() {
        errorLabel.text = ""
        errorLabel.isHidden = true
    }
    
    private func showErrorLabel(withText text: String) {
        errorLabel.text = text
        errorLabel.isHidden = false
    }
    
    //MARK: - Actions
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard let email = emailTextfield.text,
              let password = passwordTextfield.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showErrorLabel(withText: error.localizedDescription)
            } else {
                //Navigate to ChatViewController
                self.performSegue(withIdentifier: K.registerSegue, sender: self)
            }
        }
    }
    
}
