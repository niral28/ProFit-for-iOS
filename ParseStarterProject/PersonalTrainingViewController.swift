//
//  PersonalTrainingViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Niral Shah on 4/26/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class PersonalTrainingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {


    @IBOutlet weak var workoutTable: UITableView!
    @IBOutlet weak var workoutPlan: UIPickerView!
    var pickerData : [String] = [String]()
    var getLean: [String] = [String] ();
    var getStrong: [String] = [String] ();
    var getFast : [String] = [String] ();
    var getFlexible : [String] = [String] ();
    var doItAll : [String] = [String] ();
    // Workout Lists (Arrays):
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.workoutPlan.dataSource = self;
        self.workoutPlan.delegate = self;
        
        pickerData = ["Get Lean", "Get Strong", "Get Faster", "Get Flexible", "Be Rocky!(All)"];
          self.getLean = ["TRAVELING CLIMBER - Begin in a full plank position. Perform a traditional mountain climber by quickly alternating knees into chest, and then begin to 'run' feet about 45 degrees to the right. Run back to center, and then travel 45 degrees to the left. That's one rep.", "JACK IN AND OUT - With feet wide, lower into a deep squat and extend arms out to the sides of shoulders, palms facing up. Jump up out of squat, bringing feet together and clapping hands overhead. That's one rep.", "BUTT BLASTER - This exercise will tone the muscles of your hamstrings, glutes and lower back. Begin by getting on your hands and knees on the floor. Your hands should be directly underneath your shoulders and your thighs should be at a right angle to your torso. Next, take one leg and extend it upward as high in the air as you can, squeezing the glutes throughout the movement. Return to the starting position and do the same with the opposite leg.","PLANK SQUAT HOPS - Begin in a straight-arm plank, with feet together and abs braced in tight. Bend knees and quickly jump legs forward, landing in a deep squat with toes just outside of hands. Immediately jump back out to plank position.", "SQUAT JUMP - With your feet hip-width apart, squat until your thighs are parallel to the floor, and then jump as high as you can. Allow your knees to bend 45 degrees when you land, pause in deep squat position for 1 full second, and then jump again."];
        self.getStrong =
        // Do any additional setup after loading the view.
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
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
   
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 13.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return myTitle
    }
    

}
