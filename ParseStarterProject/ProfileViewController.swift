//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Niral Shah on 2/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import FBSDKShareKit
import Parse
import FBSDKLoginKit
import ParseFacebookUtilsV4
import FBSDKCoreKit
import HealthKit

class ProfileViewController: UIViewController, FBSDKGameRequestDialogDelegate {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var friendCount: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var biologicalSexLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    var currentUser = PFUser.currentUser()!;
    var dict = NSDictionary();
    let healthManager:HealthManager = HealthManager();
    let kUnknownString   = "Unknown"
    var healthStore :HKHealthStore = HKHealthStore();
 
    
    // Method to Add Friends/ Invite Them on FB:
    @IBAction func addFriends(sender: AnyObject) {
        let fbID = 978384415587929;
        print("here adding friends!");
         var gameRequestContent = FBSDKGameRequestContent();
        // Look at FBSDKGameRequestContent for futher optional properties
        gameRequestContent.message = "Play and Get Fit on ProFit";
        gameRequestContent.title = "Add Friends on ProFit!";
        
        // Assuming self implements <FBSDKGameRequestDialogDelegate>
        var dialog = FBSDKGameRequestDialog();
        dialog.delegate = self;
        dialog.content = gameRequestContent;
        if(dialog.canShow()){
            dialog.show();
        }
        
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //updateHealthInfo()
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
                    var friend = self.dict.objectForKey("friends")?.objectForKey("summary")?.objectForKey("total_count")
                    //print(friend!)
                   let friendCount = friend as? NSNumber
                    let friendCountString = "\(friendCount!)";
                    self.friendCount.text = friendCountString;
                    
                    // uInfo.setObject(self.dict.objectForKey("name") as! String, forKey: "name")
                    // uInfo.setObject(self.dict.objectForKey("name")?.objectForKey("data") as! String, forKey: "name");
                    //uInfo.setObject(self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String, forKey: "picture");
                    let pictureURL=self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String;
                    ImageLoader.sharedLoader.imageForUrl(pictureURL, completionHandler:{(image: UIImage?, url: String) in
                        self.profilePicture.image = image!
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
      updateHealthInfo()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("here!");
        print(results);
        return;
    }
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: NSError!) {
        print("failed");
        return;
    }
    func gameRequestDialogDidCancel(gameRequestDialog: FBSDKGameRequestDialog!) {
        print("hello");
        return;
    }

    var bmi:Double?
    var height, weight:HKQuantitySample?
    var calories: Double?
    var currentCalories: Double?
    func updateHealthInfo() {
        
        updateProfileInfo();
        updateWeight();
        updateHeight();
        updateCalories();
        
    }
    
    func updateProfileInfo()
    {
        let profile = healthManager.readProfile()
        
        ageLabel.text = profile.age == nil ? kUnknownString : String(profile.age!)
        biologicalSexLabel.text = biologicalSexLiteral(profile.biologicalsex?.biologicalSex)
     //   bloodTypeLabel.text = bloodTypeLiteral(profile?.bloodtype?.bloodType)
    }
    
    
    func updateHeight()
    {
        // 1. Construct an HKSampleType for Height
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        
        // 2. Call the method to read the most recent Height sample
        self.healthManager.readMostRecentSample(sampleType!, completion: { (mostRecentHeight, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading height from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            var heightLocalizedString = self.kUnknownString;
            self.height = mostRecentHeight as? HKQuantitySample;
            // 3. Format the height to display it on the screen
            if let meters = self.height?.quantity.doubleValueForUnit(HKUnit.meterUnit()) {
                let heightFormatter = NSLengthFormatter()
                heightFormatter.forPersonHeightUse = true;
                heightLocalizedString = heightFormatter.stringFromMeters(meters);
            }
            
            
            // 4. Update UI. HealthKit use an internal queue. We make sure that we interact with the UI in the main thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.heightLabel.text = heightLocalizedString
                //self.updateBMI()
            });
        })
        
        
    }
    
    func updateCalories()
    { // This method obtains calories burned over past day from midnight of current day to current time
        self.calories = 0;
        // 1. Construct an HKSampleType for Height
       let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        
        self.healthManager.readPastDayEnergy(sampleType!, completion: { (mostRecentCalories, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading calories from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            else{
            var calLocalizedString = self.kUnknownString;
            self.calories = mostRecentCalories
                if self.calories > 0{
                    self.currentCalories = mostRecentCalories * 0.000239006; // converts joules to kilocalories
                    
                    print("Current Calories:\(self.currentCalories)");
                    let calFomatter = NSEnergyFormatter();
                    calFomatter.forFoodEnergyUse = true;
                    calLocalizedString = calFomatter.stringFromJoules(self.calories!)
                }
            
            
            // 4. Update UI. HealthKit use an internal queue. We make sure that we interact with the UI in the main thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
               
                self.caloriesLabel.text = calLocalizedString;
                //self.updateBMI()
            });
        }
        })
        
    }
    
    
    func updateWeight()
    {
        // 1. Construct an HKSampleType for weight
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        
        // 2. Call the method to read the most recent weight sample
        self.healthManager.readMostRecentSample(sampleType!, completion: { (mostRecentWeight, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading weight from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            var weightLocalizedString = self.kUnknownString;
            // 3. Format the weight to display it on the screen
            self.weight = mostRecentWeight as? HKQuantitySample;
            if let kilograms = self.weight?.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo)) {
                let weightFormatter = NSMassFormatter()
                weightFormatter.forPersonMassUse = true;
                weightLocalizedString = weightFormatter.stringFromKilograms(kilograms)
            }
            
            // 4. Update UI in the main thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.weightLabel.text = weightLocalizedString
              //  self.updateBMI()
                
            });
        });
    }
    
 
    

    // MARK: - utility methods
    func biologicalSexLiteral(biologicalSex:HKBiologicalSex?)->String
    {
        var biologicalSexText = kUnknownString;
        
        if  biologicalSex != nil {
            
            switch( biologicalSex! )
            {
            case .Female:
                biologicalSexText = "Female"
            case .Male:
                biologicalSexText = "Male"
            default:
                break;
            }
            
        }
        return biologicalSexText;
    }
    
}
