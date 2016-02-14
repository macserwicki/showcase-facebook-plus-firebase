//
//  PostCell.swift
//  goviapps-firebase-app-test
//
//  Created by Maciej Serwicki on 1/22/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    
    
    //var post: Post!
    var request: Request?
    var likeRef: Firebase!
    
    
    private var _post: Post?
    
    var post: Post? {
        return _post
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.userInteractionEnabled = true
        
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
        //Clearing old image
        self.showcaseImg.image = nil
        self._post = post
        self.likesLbl.text = String(post.likes)

        if let descTxt = post.postDescription where post.postDescription != "" {
            self.descriptionText.text = descTxt
        } else {
            self.descriptionText.hidden = true
        }
        
        
        self.likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKeyID)
        
        if post.imageUrl != nil {
            
            if img != nil {

                showcaseImg.image = img
                
                
            } else {
                
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: {request, response, data, err
                    in
                    if err == nil {
                        
                        if let image = UIImage(data: data!) {
                            let img = image
                            self.showcaseImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: self.post!.imageUrl!)
                        }
                        
                    }
                    
                })
                
                
                
            }
           
            
        } else {
            print("Image not found. Hide it")
            //print(post.imageUrl.debugDescription)
            //self.showcaseImg.hidden = true
        }
        
        
       // let likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKeyID)
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
        
            
            if let doesNotExist = snapshot.value as? NSNull {
                //empty heart if doesn't exist
                //no data in firebase gives "NSNull"
                self.likeImg.image = UIImage(named: "heart-empty")
            } else {
                self.likeImg.image = UIImage(named: "heart-full")
            }
        
        })
        
        
    }

    func likeTapped(sender: UITapGestureRecognizer) {
        //add likes or remove like, and add or remove post to array of likes
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            
            if let doesNotExist = snapshot.value as? NSNull {
                //empty heart if doesn't exist
                //no data in firebase gives "NSNull"
                
                
                //add it to array
                self.likeImg.image = UIImage(named: "heart-full")
                self.post!.adjustLikes(true)
                self.likeRef.setValue(true)
                
            } else {
                
                //remove the key
                self.likeImg.image = UIImage(named: "heart-empty")
                self.post!.adjustLikes(false)
                self.likeRef.removeValue()
            }
            
        })
        
        
    }
        
    
    
    
    
}
