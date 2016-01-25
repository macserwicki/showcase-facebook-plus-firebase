//
//  PostCell.swift
//  goviapps-firebase-app-test
//
//  Created by Maciej Serwicki on 1/22/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        showcaseImg.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }


    func configureCell(post: Post) {
        self.post = post
        
        self.descriptionText.text = post.postDescription
        self.likesLbl.text = String(post.likes)
        
    }

}
