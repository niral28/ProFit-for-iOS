/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import FBSDKLoginKit
import ParseFacebookUtilsV4
import FBSDKCoreKit
class ViewController: UIViewController {
   var dict: NSDictionary!
    
    @IBAction func didTapFBLogin(sender: AnyObject) {
        
        var permissions = [ "public_profile", "email", "user_friends" ]
        var currentUser = PFUser.currentUser()!.username;
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions,  block: {  (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
              
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                  //  self.loadData(user);
                    self.performSegueWithIdentifier("ProfileViewController", sender: nil)
                    
                } else {
                    print("User logged in through Facebook!")
                   self.performSegueWithIdentifier("ProfileViewController", sender: nil)
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        
        let user = PFUser()
        var currentUser = PFUser.currentUser()!.username;
        if (currentUser != nil){
            //loadData(user);
            print("here");
            self.performSegueWithIdentifier("ProfileViewController", sender: nil);
            
            //self.presentViewController(ProfileViewController, animated: true, completion: nil)
             //self.performSegueWithIdentifier("ProfileViewController", sender: nil)
        }
        //user.username = "Niral"
        //user.password = "my pass"
        //user.email = "niral.shah@rutgers.edu"
        
        // other fields can be set if you want to save more information
       // user["phone"] = "650-555-0000"
        
        /*user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
            }
        }*/
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
        // Dispose of any resources that can be recreated.
    }
}
