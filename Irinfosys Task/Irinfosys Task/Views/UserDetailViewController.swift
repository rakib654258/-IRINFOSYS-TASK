//
//  UserDetailViewController.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//

import UIKit

final class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
            fullNameLabel.text = user.fullName
            emailLabel.text = user.email
            if let imageUrl = URL(string: user.avatar ?? "") {
                avatarImageView.loadImage(from: imageUrl)
            }
        }
    }
}
