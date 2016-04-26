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
import Charts


public class ProfileViewController: UIViewController, FBSDKGameRequestDialogDelegate {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var friendCount: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var biologicalSexLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var dailyCalorieTracking: KDCircularProgress!
    
    @IBOutlet weak var weeklyCalorieTracking: KDCircularProgress!
    @IBOutlet weak var stepperValue: UIStepper!
    @IBOutlet weak var weeklyStepperValue: UIStepper!
    @IBOutlet weak var fitCoinValue: UILabel!
    @IBOutlet weak var dailyCalorieGoalValue: UILabel!
    @IBOutlet weak var weeklyCalorieGoalValue: UILabel!
    @IBOutlet weak var weeklyCalorie: UILabel!
    @IBOutlet weak var linechartView: LineChartView!
    var currentUser = PFUser.currentUser()!;
    var dict = NSDictionary();
    var loaded = false;
    let healthManager:HealthManager = HealthManager();
    let kUnknownString   = "Unknown"
    var healthStore :HKHealthStore = HKHealthStore();
    var calorieGoal = 0.0;
    var weeklyGoal = 0.0;
    var currentStepperValue = 1.0;
    var currentWeeklyStepperValue = 1.0;
    var fitCoinBankValue = 0.0
    var gender = 1; //male is gender 1 , female is gender 0
    var weightVal = 165.0;
    var age = 20;
    var heartRate = 140;
    let gameScore = PFObject(className:"FitCoinScore")
    
    
    @IBAction func updateWeeklyCalorieGoal(sender: AnyObject) { // updates Weekly Calorie Goal, when user adjusts it.
       
        
        if currentWeeklyStepperValue < weeklyStepperValue.value {
            //print("plus");
            //print("Stepper Value:");
            //print(stepperValue.value);
            //print(currentStepperValue);
            currentWeeklyStepperValue = weeklyStepperValue.value;
            ++weeklyGoal
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.weeklyCalorieGoalValue.text = "\(self.weeklyGoal)"
                self.updateWeeklyCircularProgressBar();
            });
            
        }
        else {
         
            currentWeeklyStepperValue = weeklyStepperValue.value;
            
            --weeklyGoal
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.weeklyCalorieGoalValue.text = "\(self.weeklyGoal)"
                self.updateWeeklyCircularProgressBar();
            });
        }
        
    }
    @IBAction func updateDailyCalorieGoal(sender: AnyObject) { // updates Daily Calorie goal when user adjusts it
        
        if currentStepperValue < stepperValue.value {
            print("plus");
            print("Stepper Value:");
            print(stepperValue.value);
            print(currentStepperValue);
            currentStepperValue = stepperValue.value;
            ++calorieGoal
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dailyCalorieGoalValue.text = "\(self.calorieGoal)"
                 self.updateCircularProgressBar();
            });
            
        }
        else {
            print("minus");
            print("Stepper Value:");
            print(stepperValue.value);
            print(currentStepperValue);
            currentStepperValue = stepperValue.value;
            
            --calorieGoal
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dailyCalorieGoalValue.text = "\(self.calorieGoal)"
                 self.updateCircularProgressBar();
            });
        }
     
 
    }
 
    
    // Method to Add Friends/ Invite Them on FB:
    @IBAction func addFriends(sender: AnyObject) { // add Friends or send app invites to them using the FB Api
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
    
    
    override public func viewDidLoad() { // main method
        super.viewDidLoad()
        dailyCalorieTracking.angle = 0;
        calorieGoal = 1000;
        weeklyGoal = 2000;
        //updateFitCoins();
        drawGraph();
      //  var secondTab = self.tabBarController?.viewControllers![2] as! GameViewController
        //secondTab.fitCoins = self.fitCoinBankValue
        //getWeeklyData()
        //plotPoints();
        //self.loaded = true;
      
       //drawWeeklyGraph();
        
        //stepperValue.value = 2000;
        //updateCircularProgressBar();
        //updateHealthInfo()
        //loadData(currentUser);
        //userNameLabel.text = self.dict.objectForKey("name");
        // Do any additional setup after loading the view.
    }
    
    func updateCircularProgressBar(){ // draw's custom circular progress bar
        print("in circular progress bar");
        
        var angle = Int(self.currentCalories!/self.calorieGoal*360);
        print("angle value:");
        print(angle);
        self.dailyCalorieTracking.animateFromAngle(0, toAngle: angle, duration: 0.5, completion: nil)
        
    }
    func updateWeeklyCircularProgressBar(){ // draw's custom circular bar for weekly progress bar
        print("in  weekly circular progress bar");
        
        var angle = Int(self.weeklyCurrentCalories!/self.weeklyGoal*360);
        print("angle value:");
        print(angle);
        print(" current weekly calories:")
        print("\(self.weeklyCurrentCalories)");
        self.weeklyCalorieTracking.animateFromAngle(0, toAngle: angle, duration: 0.5, completion: nil)
        
    }
    
    func loadData(uInfo:PFUser){ // load key health data
        
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, friends, picture.type(normal), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! NSDictionary
                    print(self.dict);
                    
                    self.userNameLabel.text = self.dict.objectForKey("name") as? String;
                    var friend = self.dict.objectForKey("friends")?.objectForKey("summary")?.objectForKey("total_count")
                    print(friend!)
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
                         //self.getWeeklyData();
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
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        loadData(currentUser);
      updateHealthInfo()
        
        
    }
    

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       // var secondTab = self.tabBarController?.viewControllers![1] as! GameViewController
        //secondTab.fitCoins = self.fitCoinBankValue
    }
    
    public func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("here!");
        print(results);
        return;
    }
    public func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: NSError!) {
        print("failed");
        return;
    }
    public func gameRequestDialogDidCancel(gameRequestDialog: FBSDKGameRequestDialog!) {
        print("hello");
        return;
    }

    var bmi:Double?
    var height, weight:HKQuantitySample?
    var calories: Double?
    var weeklyCalories:Double?
    var currentCalories: Double?
    var weeklyCurrentCalories : Double?
   
    func updateHealthInfo() {
        
        updateProfileInfo();
        updateWeight();
        updateHeight();
        updateCalories();
        updateWeeklyCalories();
        
    }
    
    func updateProfileInfo()
    {
        let profile = healthManager.readProfile()
        
        ageLabel.text = profile.age == nil ? kUnknownString : String(profile.age!)
        self.age = profile.age!;
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
    
    func updateCalories() // updates calorie when user opens app.
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
                    let calFomatter = NSEnergyFormatter();
                    calFomatter.forFoodEnergyUse = true;
                    calLocalizedString = calFomatter.stringFromJoules(self.calories!)
                    
                    self.currentUser.setValue(self.currentCalories, forKey: "Calories")
                    self.currentUser.setValue(self.weeklyGoal, forKey: "weeklyGoal")
                    self.currentUser.setValue(self.calorieGoal, forKey: "dailyGoal")
                    self.currentUser.saveInBackground()
                }
            
            
            // 4. Update UI. HealthKit use an internal queue. We make sure that we interact with the UI in the main thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
               
                self.caloriesLabel.text = calLocalizedString;
                //self.updateBMI()
                self.updateCircularProgressBar();
                if(self.loaded == false){
                    self.updateFitCoins();
                }
                self.loaded = true;
            });
                
            }
        })
        
    }
    
    func updateFitCoins() { // calculate and update FitCoin Values
        if self.gender == 1 {
           /* self.fitCoinBankValue += (((Double(self.age) * 0.2017) - (Double(self.weightVal)*0.09036)) + (Double(self.heartRate)*0.6309) - 55.0969)/4.184 * 10;
             print("FitCoin Value: \(fitCoinBankValue)"); */
            
            
            let query = PFQuery(className: "FitCoinScore")
            query.whereKey("playerName", equalTo: currentUser.username!)
            query.fromLocalDatastore()
            query.getFirstObjectInBackgroundWithBlock({ (object,error) -> Void in
                if error == nil {
                    if let oldCoinValue = object{
                        print("Retrieving");
                        print(oldCoinValue["score"]);
                        self.fitCoinBankValue += Double(self.currentCalories!) - Double(self.age-1)*1.975 + Double(self.weightVal-1)*1.06;
                        self.fitCoinBankValue += oldCoinValue["score"] as! Double;
                        print("FitCoin Value: \(self.fitCoinBankValue)");
                        
                        self.gameScore["score"] = self.fitCoinBankValue;
                        self.gameScore["playerName"] = self.currentUser.username;
                        self.gameScore["timeStamp"] = NSDate();
                        self.gameScore.pinInBackground();
                        
                        let fitCoinInt  = Int(self.fitCoinBankValue);
                        //var secondTab = self.tabBarController?.viewControllers![2] as! GameViewController
                       // secondTab.fitCoins = self.fitCoinBankValue
                        print("FitCoin Value: \(fitCoinInt)");
                        self.fitCoinValue.text = "\(fitCoinInt)";
                        print("gender male");
                    }
                } else{
                    print("Un-initialized");
                    self.fitCoinBankValue += Double(self.currentCalories!) - Double(self.age-1)*1.975 + Double(self.weightVal-1)*1.06;
                    print("FitCoin Value: \(self.fitCoinBankValue)");
                    self.gameScore["score"] = self.fitCoinBankValue;
                    self.gameScore["playerName"] = self.currentUser.username;
                    self.gameScore["timeStamp"] = NSDate();
                    self.gameScore.pinInBackground()
                    let fitCoinInt  = Int(self.fitCoinBankValue);
                    //var secondTab = self.tabBarController?.viewControllers![2] as! GameViewController
                   // secondTab.fitCoins = self.fitCoinBankValue
                    print("FitCoin Value: \(fitCoinInt)");
                    self.fitCoinValue.text = "\(fitCoinInt)";
                    print("gender male");
                }
            })
            //self.fitCoinBankValue += oldCoinValue;
    
         
            
        } else {
            print("gender female");
            /*self.fitCoinBankValue += (((Double(self.age)*0.074) - (Double(self.weightVal)*0.05741)) + (Double(self.heartRate)*0.4472) - 20.4022)/4.184 * 10;*/
            self.fitCoinBankValue += (Double(self.currentCalories!) - Double(self.age-1)*1.975 + Double(self.weightVal-1)*1.06)/1.27;
            print("FitCoin Value: \(fitCoinBankValue)");
           // var secondTab = self.tabBarController?.viewControllers![2] as! GameViewController
            //secondTab.fitCoins = self.fitCoinBankValue
            print("Female FitCoinValue:\(self.fitCoinBankValue)");
            
            let fitCoinInt  = Int(self.fitCoinBankValue);
            
            self.fitCoinValue.text = "\(fitCoinInt)";
        }
    }
    
    func updateWeeklyCalories()
    { // This method obtains calories burned over past day from midnight of current day to current time
        self.weeklyCalories = 0;
        // 1. Construct an HKSampleType for Height
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        
        self.healthManager.readPastWeekEnergy(sampleType!, completion: { (mostRecentCalories, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading calories from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            else{
                var calLocalizedString = self.kUnknownString;
                self.weeklyCalories = mostRecentCalories
                
                if self.weeklyCalories > 0 {
                    self.weeklyCurrentCalories = mostRecentCalories * 0.000239006; // converts joules to kilocalories
                    print("weekly current calories");
                    print(self.weeklyCurrentCalories);
                    let calFomatter = NSEnergyFormatter();
                    calFomatter.forFoodEnergyUse = true;
                    calLocalizedString = calFomatter.stringFromJoules(self.weeklyCurrentCalories!)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.weeklyCalorie.text = calLocalizedString;
                        //self.updateBMI()
                        self.updateWeeklyCircularProgressBar()
                    });
                } else{
                    self.weeklyCurrentCalories = 1110;
                    let calFomatter = NSEnergyFormatter();
                    calFomatter.forFoodEnergyUse = true;
                    calLocalizedString = calFomatter.stringFromJoules(self.weeklyCurrentCalories!)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.weeklyCalorie.text = "1110 cal"
                        //self.updateBMI()
                        self.updateWeeklyCircularProgressBar()
                    });
                }
                
                
                // 4. Update UI. HealthKit use an internal queue. We make sure that we interact with the UI in the main thread
             
            }
        })
        
    }
    
    func drawGraph(){ // draw the graph
        self.getWeeklyData();
        self.plotPoints();
    }
    
    func drawWeeklyGraph()
    { // This method obtains calories burned over past day from midnight of current day to current time
        //self.weeklyCalories = 0;
        // 1. Construct an HKSampleType for Height
        var dataArray = [Double]();
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)

        self.healthManager.readPastAllEnergy(sampleType!, completion: { (mostRecentCalories, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading calories from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            else{
                var calLocalizedString = self.kUnknownString;
                var chartVals:[ChartDataEntry] = []
                var i = 0;
                var dataPoints = [String]();
                
                if mostRecentCalories.count > 1 {
                    guard let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) else {
                        fatalError("*** This should never fail. ***")
                    }
                    var endDate = NSDate();
                    var startDate = calendar.dateByAddingUnit(.Day, value: -6, toDate: endDate, options: .WrapComponents);
                for sample in mostRecentCalories {
                   print(sample);
                    var calSample = sample * 0.000239006*1000; // converts joules to kilocalories
                    print(calSample);
                    let dataEntry = ChartDataEntry(value: calSample, xIndex: i)
                    chartVals.append(dataEntry)
                    print(i)
                    var month = "\(calendar.component(.Month, fromDate: startDate!))"
                    dataPoints.append("\(month)/\(calendar.component(.Day, fromDate: startDate!))");
                
                    ++i
                    startDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: startDate!, options: .WrapComponents);
                    }
                    // 4. Update UI. HealthKit use an internal queue. We make sure that we interact with the UI in the main thread
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let lineChartDataSet = LineChartDataSet(yVals: chartVals, label: "Calories")
                        //lineChartDataSet.drawCirclesEnabled = false;
                        lineChartDataSet.drawCubicEnabled = true;
                        //lineChartDataSet.colors = ChartColorTemplates.colorful();
                    
                        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
                        self.linechartView.data = lineChartData
                        self.linechartView.data?.setValueTextColor(UIColor.blackColor())
                        
                        
                        
                        
                        self.linechartView.descriptionText = ""
                        var yaxis = ChartYAxis();
                        var xaxis = ChartXAxis();
                        xaxis = self.linechartView.xAxis;
                        xaxis.wordWrapEnabled = true;
                        xaxis.spaceBetweenLabels = 1
                        xaxis.labelPosition = .Top;
        
                        yaxis = self.linechartView.leftAxis;
                        yaxis.enabled = true;
                      
                        var yaxis2 = self.linechartView.rightAxis;
                        yaxis2.enabled = false;
                    

                        self.linechartView.animate(xAxisDuration: 0.2, yAxisDuration: 0.2, easingOptionX: .EaseInCubic, easingOptionY: .EaseInCubic)
                        
                        
                    });
                }
   
            }
        })
        
    }
    
    /*var dataArray:[Double] = [];
    var chartVals2:[ChartDataEntry] = []
      var dataPoints2 = [String]();
    
    func getCaloriesDay(d:NSDate){
        print("in drawGraph");
        
        var sampleValue = 0.0;
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        var endDate = d;
      
        var x = healthManager.readDayEnergy(sampleType!, date: d, completion: { (mostRecentCalories, error) -> Void in
                
                if( error != nil )
                {
                    print("Error reading calories from HealthKit Store: \(error.localizedDescription)")
                    return
                }
                else{
                    var calVal = mostRecentCalories * 0.000239006
            
                }
                    // 4. Update UI. HealthKit use an internal queue. We make sure that we interact with the UI in the main thread
        
        
        
        
        });
        
       
    
    }*/
    
    func getWeeklyData () { // statistics
        
        
        let calendar = NSCalendar.currentCalendar()
        
        let interval = NSDateComponents()
        interval.day = 1
        
        // Set the anchor date to Monday at 3:00 a.m.
        let anchorComponents = calendar.components([.Day, .Month, .Year, .Weekday], fromDate: NSDate())
        anchorComponents.hour = 1
        
        //let offset = (7 + anchorComponents.weekday - 2) % 7
        anchorComponents.day = 1;
        anchorComponents.hour = 1
        
        guard let anchorDate = calendar.dateFromComponents(anchorComponents) else {
            fatalError("*** unable to create a valid date from the given components ***")
        }
        
        guard let quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned) else {
            fatalError("*** Unable to create a step count type ***")
        }
        
        // Create the query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: nil,
                                                options: .CumulativeSum,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        // Set the results handler
        query.initialResultsHandler = {
            query, results, error in
            
            guard let statsCollection = results else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription) ***")
            }
            
            let endDate = NSDate()
            
            guard let startDate = calendar.dateByAddingUnit(.Day, value: -7, toDate: endDate, options: []) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            // Plot data over past week
            statsCollection.enumerateStatisticsFromDate(startDate, toDate: endDate) { [unowned self] statistics, stop in
                
                if let quantity = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let value = quantity.doubleValueForUnit(HKUnit.jouleUnit()) * 0.000239006;
                 
                    // Call a custom method to plot each data point.
                    //self.plotWeeklyStepCount(value, forDate: date)
                    self.addPoints(value, forDate: date)
                }
            }
        }
        healthStore.executeQuery(query)
        plotPoints();
    }
    
    var chartVals:[ChartDataEntry] = []
    var dataPoints = [String]();
    var index = 0;
   
    func addPoints(value:Double, forDate:NSDate ){
        let calendar = NSCalendar.currentCalendar()
        let dataEntry = ChartDataEntry(value: value, xIndex: self.index)
        print(value);
        chartVals.append(dataEntry)
        let month = calendar.component(.Month, fromDate: forDate)
        let day = calendar.component(.Day, fromDate: forDate)
        dataPoints.append("\(month)/\(day)")
        self.index++;
    }
    
    func plotPoints (){ // plots data Points
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let lineChartDataSet = LineChartDataSet(yVals: self.chartVals, label: "Calories")
            //lineChartDataSet.drawCirclesEnabled = false;
            lineChartDataSet.drawCubicEnabled = true;
            //lineChartDataSet.colors = ChartColorTemplates.colorful();
            
            let lineChartData = LineChartData(xVals: self.dataPoints, dataSet: lineChartDataSet)
            self.linechartView.data = lineChartData
            self.linechartView.data?.setValueTextColor(UIColor.blackColor())
            
            
            
            
            self.linechartView.descriptionText = ""
            var yaxis = ChartYAxis();
            var xaxis = ChartXAxis();
            xaxis = self.linechartView.xAxis;
            xaxis.wordWrapEnabled = true;
            xaxis.spaceBetweenLabels = 1
           // xaxis.labelPosition = .Bottom;
            
            yaxis = self.linechartView.leftAxis;
            yaxis.enabled = true;
            
            var yaxis2 = self.linechartView.rightAxis;
            yaxis2.enabled = false;
            
            
            self.linechartView.animate(xAxisDuration: 0.2, yAxisDuration: 0.2, easingOptionX: .EaseInCubic, easingOptionY: .EaseInCubic)
        });
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
                self.weightVal = kilograms;
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
                self.gender = 0;
            case .Male:
                biologicalSexText = "Male"
                self.gender = 1;
            default:
                self.gender = 1;
                break;
            }
            
        }
        return biologicalSexText;
    }
    
}
