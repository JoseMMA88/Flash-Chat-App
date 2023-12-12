//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Jose Manuel Malagón Alba on 28/11/23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class MessageCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var messageBubbleView: UIView!
    @IBOutlet weak var messageBodyLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBubbleView.layer.cornerRadius = messageBubbleView.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(message: Message) {
        guard let messageSender = Auth.auth().currentUser?.email else { return }
        
        if message.sender != messageSender {
            rightImageView.isHidden = true
            leftImageView.isHidden = false
            messageBubbleView.backgroundColor = UIColor(named: K.BrandColors.purple)
            messageBodyLabel.textColor = UIColor(named: K.BrandColors.lightPurple)
        } else {
            rightImageView.isHidden = false
            leftImageView.isHidden = true
            messageBubbleView.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            messageBodyLabel.textColor = UIColor(named: K.BrandColors.purple)
        }
        
        messageBodyLabel.text = message.body
    }
    
}
