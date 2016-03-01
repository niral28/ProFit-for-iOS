//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Niral Shah on 2/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var currentUser = PFUser.currentUser()!;
    var dict = NSDictionary();
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var friendCount: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadData(currentUser);
        //userNameLabel.text = self.dict.objectForKey("name");
        // Do any additional setup after loading the view.
    }
    func loadData(uInfo:PFUser){
        
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, friends, picture.type(normal), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! NSDictionary
                    print(self.dict);
                    self.userNameLabel.text = self.dict.objectForKey("name") as? String;
                    let friend = self.dict.objectForKey("friends")?.objectForKey("summary")?.objectForKey("total_count")
                    //print(friend!)
                    let friendCount = friend as? NSNumber
                    let friendCountString = "\(friendCount!)";
                    self.friendCount.text = friendCountString;
                    
                    // uInfo.setObject(self.dict.objectForKey("name") as! String, forKey: "name")
                    // uInfo.setObject(self.dict.objectForKey("name")?.objectForKey("data") as! String, forKey: "name");
                    //uInfo.setObject(self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String, forKey: "picture");
                    let pictureURL=self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String;
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        print(pictureURL);
                        self.profilePicture.image =  UIImage(data: NSData(contentsOfURL: NSURL(string:pictureURL)!)!)
                        
                    })
                    
                }
            })
        }
        
        /* let request:FBSDKGraphRequest = FBSDKGraphRequest.requestForMe()
        request.startWithCompletionHandler { (connection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
        if error == nil{
        if let dict = result as? Dictionary<String, AnyObject>{
        let name:String = dict["name"] as AnyObject? as String
        let facebookID:String = dict["id"] as AnyObject? as String
        let email:String = dict["email"] as AnyObject? as String
        
        let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
        
        var URLRequest = NSURL(string: pictureURL)
        var URLRequestNeeded = NSURLRequest(URL: URLRequest!)
        
        
        NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!, error: NSError!) -> Void in
        if error == nil {
        var picture = PFFile(data: data)
        PFUser.currentUser().setObject(picture, forKey: "profilePicture")
        PFUser.currentUser().saveInBackground()
        }
        else {
        println("Error: \(error.localizedDescription)")
        }
        })
        PFUser.currentUser().setValue(name, forKey: "username")
        PFUser.currentUser().setValue(email, forKey: "email")
        PFUser.currentUser().saveInBackground()
        }
        }
        } */
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        loadData(currentUser);
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
