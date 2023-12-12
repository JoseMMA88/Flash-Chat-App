//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Jose Manuel Malagón Alba on 01/11/2023.
//  Copyright © 2023 Jose Manuel Malagón Alba. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    //MARK: - Variables
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        title = K.appName
        navigationItem.hidesBackButton = true
        
        loadMessages()
    }
    
    //MARK: - Actions
    
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let messageText = messageTextfield.text,
              let messageSender = Auth.auth().currentUser?.email else { return }
        
        storeMessage(Message(sender: messageSender, body: messageText))
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

//MARK: - TableViewDateSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        cell.configure(message: messages[indexPath.row])
            
        return cell
    
    }
    
}

//MARK: - TableViewDelegate

extension ChatViewController: UITableViewDelegate {
    
}


//MARK: - DB Methods

extension ChatViewController {
    
    private func storeMessage(_ message: Message){
        db.collection(K.FStore.collectionName).addDocument(data: [
            K.FStore.senderField: message.sender,
            K.FStore.bodyField: message.body,
            K.FStore.dateField: Date().timeIntervalSince1970
        ]) { error in
            if let error = error {
                print(error)
            } else {
                print("Message stored!")
                DispatchQueue.main.async {
                    self.messageTextfield.text = ""
                }
            }
        }
    }
    
    private func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.messages = []
                    if let documents = querySnapshot?.documents {
                        for message in documents {
                            if let messageSender = message.data()[K.FStore.senderField] as? String,
                               let messageBody = message.data()[K.FStore.bodyField] as? String {
                                self.messages.append(Message(sender: messageSender, body: messageBody))
                                
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
    }
    
}
