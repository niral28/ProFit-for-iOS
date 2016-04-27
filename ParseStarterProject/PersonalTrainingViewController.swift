//
//  PersonalTrainingViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Niral Shah on 4/26/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class PersonalTrainingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {


    
    @IBOutlet weak var workoutPlan: UIPickerView!
    @IBOutlet weak var workoutPicture: UIImageView!
    @IBOutlet weak var completedWorkout: UIButton!
    @IBOutlet weak var workoutExplanation: UITextView!
    
    var currentWorkout = Int(); // keep track of selected workout plan
    var pickerData : [String] = [String]()
    var getLean: [String] = [String] ();
    var getStrong: [String] = [String] ();
    var getFast : [String] = [String] ();
    var getFlexible : [String] = [String] ();
    var doItAll : [String] = [String] ();
    
    //Exercise Index Tracking
    var exr1Count = 0;
    var exr2Count = 0;
    var exr3Count = 0;
    var exr4Count = 0;
    var exr5Count = 0;
    
    // Workout Lists (Arrays):
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.workoutPlan.dataSource = self;
        self.workoutPlan.delegate = self;
        
        pickerData = ["Get Lean", "Get Strong", "Get Faster", "Get Flexible", "Be Rocky!(All)"];
          self.getLean = ["TRAVELING CLIMBER - Begin in a full plank position. Perform a traditional mountain climber by quickly alternating knees into chest, and then begin to 'run' feet about 45 degrees to the right. Run back to center, and then travel 45 degrees to the left. That's one rep.", "JACK IN AND OUT - With feet wide, lower into a deep squat and extend arms out to the sides of shoulders, palms facing up. Jump up out of squat, bringing feet together and clapping hands overhead. That's one rep.", "BUTT BLASTER - This exercise will tone the muscles of your hamstrings, glutes and lower back. Begin by getting on your hands and knees on the floor. Your hands should be directly underneath your shoulders and your thighs should be at a right angle to your torso. Next, take one leg and extend it upward as high in the air as you can, squeezing the glutes throughout the movement. Return to the starting position and do the same with the opposite leg.","PLANK SQUAT HOPS - Begin in a straight-arm plank, with feet together and abs braced in tight. Bend knees and quickly jump legs forward, landing in a deep squat with toes just outside of hands. Immediately jump back out to plank position.", "SQUAT JUMP - With your feet hip-width apart, squat until your thighs are parallel to the floor, and then jump as high as you can. Allow your knees to bend 45 degrees when you land, pause in deep squat position for 1 full second, and then jump again.","Congrats your finished with all the workouts!"];
        self.getStrong = ["Tricep Dip:\nWhile sitting on a chair, grip the edge of the seat with your hands and stretch your legs out in front of you.\nMove your body forward so that your feet are flat, your arms are bent behind you holding you up and your body is extended above the ground.\nSlowly raise and lower your body using your triceps.\n", "Side Push Up:  Lay on your side and place the arm closest to the ground around your waist and the other arm in front of your chest with your hand flat on the ground with your fingers pointing up inline with your body. Press into your hand hinging at your hip lifting your shoulders up off of the ground. If you are particularly strong then come up onto your hands and knees rather than your hip and if you are Superman then come up onto your feet (I have never seen the this last version done, by the way).", "ALTERNATING LEG WALKS/DROPS - This exercise is beneficial for the rectus and transverse abdominis muscle. Assume the same position as for the vertical leg crunch. Again, contract your abdominal muscles and raise your torso up until your shoulder blades leave the floor. Do not pull on your neck. Keep your legs in a fixed position and slowly lower one leg until it is almost touching the floor; keep the other leg static. Return and repeat with the opposite leg. Repeat with alternating legs.", "Inverted row: (targets your biceps)You need to have something to grab onto that is within your reach while lying flat on the ground. Recommend to lay under a coffee table or sturdy chair.\nWhile gripping the edge of the table or chair, pull your upper body up off the ground, hold for a few seconds and lower yourself back down.\n", "Push-up: To do push-ups correctly, make sure your body is properly aligned.\nKeep your feet together with your toes pointed down and your hands shoulder-width apart. The entire length of your body should run parallel to the ground. Your hips and back should be flat.\nThis alignment needs to be maintained as you bend your elbows and lower your body to within an inch or so off the floor.\nThen reverse this motion and repeat.\n", "Congrats your finished with all the workouts!"];
        self.getFast = ["SQUAT JUMP - With your feet hip-width apart, squat until your thighs are parallel to the floor, and then jump as high as you can. Allow your knees to bend 45 degrees when you land, pause in deep squat position for 1 full second, and then jump again.", "TRAVELING CLIMBER - Begin in a full plank position. Perform a traditional mountain climber by quickly alternating knees into chest, and then begin to 'run' feet about 45 degrees to the right. Run back to center, and then travel 45 degrees to the left. That's one rep.", "WALKING SINGLE-LEG STRAIGHT-LEG DEADLIFT REACH - Stand with your feet hip-width apart and your arms hanging to the side of your thighs. Lift your right leg behind you. Keeping your lower back naturally arched, bend forward at your hips and lower your torso until it’s nearly parallel to the floor while you reach your opposite hand to the floor. Return to the starting position, take two steps forward, then repeat the movement with the opposite leg.","SIDE LUNGE - Stand with your feet about twice shoulder-width apart. Keeping your right leg straight, push your hips back and to the left. Then bend your left knee and lower your body until your left thigh is parallel to the floor. Your feet should remain flat on the floor at all times. Pause for 2 seconds, and then return to the starting position. Complete all reps and switch sides.","Congrats your finished with all the workouts!" ];
        self.getFlexible = ["Body Weight Squats (for quadriceps, calves, hamstrings)\nStand with your feet spread wider than your shoulder-width apart.\nHold your arms straight out and your shoulder level, parallel to the floor.\nKeep torso up-tight, lower back slightly arched.\nBrace your abs and lower your body as far as you can by pushing your hips back and bending your knees.\nPause. Now push yourself back to the starting position.\n", "ALTERNATING LEG WALKS/DROPS - This exercise is beneficial for the rectus and transverse abdominis muscle. Assume the same position as for the vertical leg crunch. Again, contract your abdominal muscles and raise your torso up until your shoulder blades leave the floor. Do not pull on your neck. Keep your legs in a fixed position and slowly lower one leg until it is almost touching the floor; keep the other leg static. Return and repeat with the opposite leg. Repeat with alternating legs.", "Standing Chop (for waist, obliques, lower back, glutes, and legs)\nStand with feet hip-width apart.\nExtend left arm overhead, right hand resting on hip.\nKeep left knee soft, bring right knee up and pull left arm down in a controlled chopping motion.\nAim for the outside of the knee with your elbow, for one count.\nReturn to start for two counts.\n", "Criss-Cross (for abs, obliques, and quads)\nLie down on your back, clasp hands behind head, and slightly lift the tops of your shoulder blades off floor.\nStraighten and lift left leg off the floor as you twist at waist.\nBring right knee slowly in toward left shoulder (be careful not to round your back or pull on your head or neck).\nHold for two counts, then twist to the other side for one repetition.\n","Congrats your finished with all the workouts!"];
        self.doItAll = self.getLean + self.getStrong + self.getFast + self.getFlexible ;
        updateTextBox();
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
       // self.currentWorkout = row;
        self.updateTextBox();
        return pickerData[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentWorkout = row;
        self.updateTextBox();
    }
   
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 13.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        
        return myTitle
    }
    
    
    func updateTextBox() {
        print("in update textbox: \(self.currentWorkout)");
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if self.currentWorkout == 0 { // getLean
                if (self.exr1Count < self.getLean.count){
                    self.workoutExplanation.text = self.getLean[self.exr1Count];
                    
                } else{
                    self.exr1Count = 0;
                }

            } else if (self.currentWorkout == 1){ //getStrong
                print("Change");
                if (self.exr2Count < self.getStrong.count){
                    self.workoutExplanation.text = self.getStrong[self.exr2Count];
                    
                } else{
                    self.exr2Count = 0;
                }
                
            } else if (self.currentWorkout == 2){ //getFast
                if (self.exr3Count < self.getFast.count){
                    self.workoutExplanation.text = self.getFast[self.exr3Count];
                    
                } else{
                    self.exr3Count = 0;
                }
                
            } else if (self.currentWorkout == 3) { // getFlexible
                if (self.exr4Count < self.getFlexible.count){
                    self.workoutExplanation.text = self.getFlexible[self.exr4Count];
                    
                } else{
                    self.exr4Count = 0;
                }
             
            } else if (self.currentWorkout == 4){ // be rocky!
                if (self.exr5Count < self.getLean.count){
                    self.workoutExplanation.text = self.doItAll[self.exr5Count];
                    
                } else{
                    self.exr5Count = 0;
                }
                
            }
            
        });
    }
    

    @IBAction func nextExercise(sender: AnyObject) {
        if self.currentWorkout == 0 {
            ++self.exr1Count
            self.updateTextBox();
        } else if (self.currentWorkout == 1){
            ++self.exr2Count
            self.updateTextBox();
        }
        else if (self.currentWorkout == 2){
            ++self.exr3Count
            self.updateTextBox();
        }else if (self.currentWorkout == 3){
            ++self.exr4Count
            self.updateTextBox();
        }else if (self.currentWorkout == 4){
            ++self.exr5Count
            self.updateTextBox();
        }
    }
    

}
