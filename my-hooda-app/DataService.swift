//
//  DataService.swift
//  my-hooda-app
//
//  Created by Christella on 2/23/16.
//  Copyright © 2016 Christella. All rights reserved.
//

import Foundation
import UIKit

//This is a singleton-- there is once instance of it in memory and its globally accessible to everyone
//will live in memory for the lifetime of the application.

class DataService {
    static let instance = DataService() //only ever create one instance of it. It's "The instance"
    
    let KEY_POSTS = "posts"
    private var _loadedPosts = [Post]()
    
    var loadedPosts: [Post] {
        return _loadedPosts
    }
    
    func savePosts() { // 4: Calls savePost --> 5: loadPost
        let postData = NSKeyedArchiver.archivedDataWithRootObject(_loadedPosts) //taking array turning it into data that can be stored in the disk
        NSUserDefaults.standardUserDefaults().setObject(postData, forKey: KEY_POSTS)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func loadPosts() {//5: loadPost --> 6: Goes to ViewController
        
        //grabbing the data and converting it back into an object 
        
       if let postData = NSUserDefaults.standardUserDefaults().objectForKey(KEY_POSTS) as? NSData  {
        
        if let postsArray = NSKeyedUnarchiver.unarchiveObjectWithData(postData) as? [Post] {
            _loadedPosts = postsArray
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "postsLoaded", object: nil))
    }
    
    func saveImageAndCreatePath(image: UIImage) -> String {
        let imgData = UIImagePNGRepresentation(image)//image is turned to PNG and turned to NSData.
        let imgPath = "image\(NSDate.timeIntervalSinceReferenceDate()).png"//each image now has a unique name.
        let fullPath = documentsPathForFileName(imgPath)//where we want to save the image
        imgData?.writeToFile(fullPath, atomically: true)
        
        return imgPath
    }
    
    func imageForPath(path: String) -> UIImage? {
        let fullPath = documentsPathForFileName(path)
        let image = UIImage(named: fullPath)
        
        return image
    }
    
    func addPost(post: Post) { //3: Goes to addPost --> 4: Calls savePost
        _loadedPosts.append(post)
        savePosts()
        loadPosts()
    }
    
    func documentsPathForFileName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)//gives an array back
        
        let fullPath = paths[0] as NSString
        return fullPath.stringByAppendingPathComponent(name)
    }
    
}