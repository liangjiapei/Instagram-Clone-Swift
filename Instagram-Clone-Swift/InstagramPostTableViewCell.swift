//
//  InstagramPostTableViewCell.swift
//  Instagram-Clone-Swift
//
//  Created by Jiapei Liang on 3/20/17.
//  Copyright © 2017 Jiapei Liang. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class InstagramPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: PFImageView!
    
    @IBOutlet weak var likesAmountLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var post: PFObject! {
        didSet {
            self.postImageView.file = post["media"] as? PFFile
            self.postImageView.loadInBackground()
            
            let likesAmount = post["likesCount"] as? Int ?? 0
            
            if likesAmount == 0 {
                likesAmountLabel.text = "0 like"
            } else {
                likesAmountLabel.text = "\(likesAmount) likes"
            }
            
            if let caption = post["caption"] as? String {
                captionLabel.text = "\(caption)"
            }
            
            if let user = post["author"] as? PFUser {
                usernameLabel.text = user.username
            }
            
            if let time = post["createdAt"] as? String {
                timeLabel.text = time
            }
            
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
