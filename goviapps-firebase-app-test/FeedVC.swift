//
//  FeedVC.swift
//  goviapps-firebase-app-test
//
//  Created by Maciej Serwicki on 1/22/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var postField: MaterialDesignTextField!
    
    @IBOutlet weak var imageSelectorImg: MaterialDesignImageView!
    
    
    var imagePicker: UIImagePickerController!
    
    var posts = [Post]()
    var imageSelected = false
    static let imageCache = NSCache()
    
    override func viewWillAppear(animated: Bool) {
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            
            //clearing all data. will reassign next
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                   print(snap)

                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                        
                    }
                    
                    
                }
            }
            self.tableView.reloadData()
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        tableView.estimatedRowHeight = 361
        
        // Do any additional setup after loading the view.
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        //let post = posts[indexPath.row]
        //print(post.imageUrl)
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            //Canceling request. We need to stop old request from downloading to prevent bugs.
            cell.request?.cancel()
            
            let post = posts[indexPath.row]

            //empty image var
            var img: UIImage?
            
            if let url = post.imageUrl {
                if let cacheImg = FeedVC.imageCache.objectForKey(url) as? UIImage {
                    img = cacheImg
                }
            }
            
            cell.configureCell(post, img: img)
            
            return cell
        } else {
            return PostCell()
        }
        
        
    }
    
    
    


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        if post.imageUrl == nil {
            return 150
        } else {
            return 361
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        //pop VC?
        imageSelectorImg.image = image
        imageSelected = true
        
    }

    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    

    @IBAction func makePost(sender: AnyObject) {

        if imageSelectorImg.image != nil && postField.text != "" && imageSelected == true {
            
            if let uploadImage = imageSelectorImg.image where imageSelected == true {
            let imageData = UIImageJPEGRepresentation(uploadImage, 0.2)!
            let keyData = API_IMAGESHACK_KEY.dataUsingEncoding(NSUTF8StringEncoding)!
            let urlString = "https://post.imageshack.us/upload_api.php"
            let url = NSURL(string: urlString)!
           
                
            let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                    
                    //
                    // I don't get this part of the course.
                    // Converting strings to a data format b/c documentation requires it in a non-string format. 
                    //https://code.google.com/archive/p/imageshackapi/wikis/ImageshackAPI.wiki
                    //
                    
                    multipartFormData.appendBodyPart(data: imageData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    
                    }) { encodingResult in
                       
                        switch encodingResult {
                            
                        case .Success(let upload, _, _): upload.responseJSON(completionHandler: { result in
                        
                            if result.result.error == nil {
                                
                                if let info = result.result.value as? Dictionary<String, AnyObject> {
                                    //do stuff with "info"
                                    if let links = info["links"] as? Dictionary<String,AnyObject> {
                                        if let imgLink = links["image_link"] as? String {
                                            //!! URL
                                            self.postToFirebase(imgLink)
                                            
                                            //clear 
                                            
                                            self.postField.text = ""
                                            
                                        }
                                    }
                                }
                                
                                }
                            
                            })
                        case .Failure(let error):
                            print(error)
                            
                        }
                
                
                }
                
                
                
            }
        } else {
            print("Img or Text Missing")
            //present alert 
            //self.postToFirebase(nil)
        }
    }
    
    func postToFirebase(imgUrl: String?) {
        //description, imageUrl, likes
        
        var post: Dictionary<String, AnyObject> = [
        "description": postField.text!,
        "likes": 0
        ]
        if imgUrl != nil {
            post["imageUrl"] = imgUrl!
        }
        
        //create unique ID & Upload
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        postField.text = ""
        imageSelectorImg.image = UIImage(named: "camera")
        tableView.reloadData()
        
    }
    
}



