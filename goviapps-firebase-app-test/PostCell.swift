//
//  PostCell.swift
//  goviapps-firebase-app-test
//
//  Created by Maciej Serwicki on 1/22/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    var post: Post!
    var request: Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func drawRect(rect: CGRect) {
        if profileImg != nil {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        showcaseImg.clipsToBounds = true
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }


    func configureCell(post: Post, img: UIImage?) {
        self.post = post
        self.descriptionText.text = post.postDescription
        self.likesLbl.text = String(post.likes)
        
        if post.imageUrl != nil {
            //get image from cache or download it
            
            if img != nil {
                // try getting image from cache
                self.showcaseImg.image = img
            } else {
                // make a request via alamofire
                
//
//                Alamofire.request(.GET, post.imageUrl!).response(completionHandler: {request, response, data, error in
//                print(error)
//                    if error == nil {
//                        if let img = UIImage(data: data!, scale:  1) {
//                            
//                            self.showcaseImg.image = img
//                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl!)
//                            
//                            
//                        }
//                    }
//                    
//                })
//                
//                
                
                
                
                
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: {request, response, data, err
                    in
                    if err == nil {
                        
                        if let image = UIImage(data: data!) {
                            let img = image
                            self.showcaseImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                        }
                        
                    }
                    
                })
                
                
                
            }
           
            
        } else {
            self.showcaseImg.hidden = true
        }
        
    }

}
