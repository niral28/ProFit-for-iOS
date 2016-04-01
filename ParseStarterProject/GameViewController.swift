//
//  GameViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Niral Shah on 3/28/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var WorkoutNumber: UILabel!
    @IBOutlet weak var wheel: UIImageView!
    @IBOutlet weak var fitCoinLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fitCoinLabel.text = "\(Int(fitCoins))"
        workoutExplanation.text = "Spin the wheel and we'll generate an exercise for you!"
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var workoutExplanation: UITextView!
    
    let workouts = ["Arm Circles: (targets your triceps, biceps, and shoulders)"+" While standing straight with your feet flat on the ground and arms extended out to the side at a 90-degree angle to your body, start moving your arms in small, fast circles forward.\n" +
    "Do as many rotations as you can and then reverse the motion, doing as many circles as you can in the reverse direction.\n"+"Take a break and repeat two more times.\n"+"If you need to sit, make sure your feet are flat on the ground and your back is straight.\n"+"You will feel this exercise in your shoulders. You’ll be able to do more revolutions if you keep your abdominal muscles pulled in and tight.\n ",
        "BUTT BLASTER - This exercise will tone the muscles of your hamstrings, glutes and lower back. Begin by getting on your hands and knees on the floor. Your hands should be directly underneath your shoulders and your thighs should be at a right angle to your torso. Next, take one leg and extend it upward as high in the air as you can, squeezing the glutes throughout the movement. Return to the starting position and do the same with the opposite leg. Repeat for three sets of 20 to 25 repetitions.",
        
        "TRAVELING CLIMBER - Begin in a full plank position. Perform a traditional mountain climber by quickly alternating knees into chest, and then begin to 'run' feet about 45 degrees to the right. Run back to center, and then travel 45 degrees to the left. That's one rep. Do 10 reps as fast as possible." ,
        "Pull-ups:\n"+"To perform pull-ups correctly, place your hands shoulder-width apart on the horizontal bar.\n"+"Next, raise your body until your chin is just over the bar level.\n"+"Then ease your body back down and repeat.\n", "ALTERNATING LEG WALKS/DROPS - This exercise is beneficial for the rectus and transverse abdominis muscle. Assume the same position as for the vertical leg crunch. Again, contract your abdominal muscles and raise your torso up until your shoulder blades leave the floor. Do not pull on your neck. Keep your legs in a fixed position and slowly lower one leg until it is almost touching the floor; keep the other leg static. Return and repeat with the opposite leg. Repeat with alternating legs until you have completed 12 repetitions. Do two to three sets of this exercise.",
        "CONTRALATERAL LIMB RAISES - Begin on your belly with your arms extended in front of your head. Squeeze your lower back to raise your left arm and right leg about 6 inches off the ground at the same time. Lower them back to the ground and raise your right arm and left leg.", "Wide Push Up: Done exactly like a traditional pushup but with your hands set as wide as is comfortable and you can control.  We suggest hands 2 to 4 inches outside the width of your elbows when arms are straight out from your sides. This version puts more strain on your chest muscles so drop to your knees if your form starts to slide.",
        "Side Push Up:  Lay on your side and place the arm closest to the ground around your waist and the other arm in front of your chest with your hand flat on the ground with your fingers pointing up inline with your body. Press into your hand hinging at your hip lifting your shoulders up off of the ground. If you are particularly strong then come up onto your hands and knees rather than your hip and if you are Superman then come up onto your feet (I have never seen the this last version done, by the way).",
        
        "Standing Chop (for waist, obliques, lower back, glutes, and legs)\n"+"Stand with feet hip-width apart.\n"+"Extend left arm overhead, right hand resting on hip.\n"+"Keep left knee soft, bring right knee up and pull left arm down in a controlled chopping motion.\n"+"Aim for the outside of the knee with your elbow, for one count.\n"+"Return to start for two counts.\n"+"Do 8 to 12 repetitions on each side.\n"
];
    
    var count = 1.0;
    var currentAngle = 0.0;
    var fitCoins = Double();
    @IBAction func spinButton(sender: AnyObject) {
        print("in rotation")
       
      let image = wheel.image!;
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var rads = -180.0;
           
            //var randomNum = Double(Int(arc4random_uniform(3) + 1))
         //   print("random Num:\(randomNum)")
            //rads = (self.count*randomNum*(45)*3.14/180);
          /*  if self.count == 1 {
                rads = ((180)*3.14/180);
                  self.count = rads;
            }
            else {
                rads = ((180)*3.14/180 + self.count)%(2*3.14);
                print("\(rads)")
            }*/
          
          //  rads = direction * rads;
            //print("angle \(rads)");
            
           // var direction = 1.0;
           
            if self.count != 1 {
                self.currentAngle -= 225;
                rads = self.currentAngle;
            }
            
          
          
            
            var transform = CGAffineTransformMakeRotation(CGFloat(rads));
           
            UIView.animateWithDuration(1, animations: {
                //self.wheel.animationRepeatCount = 3;
                self.wheel.transform = transform;
            });
            
            self.currentAngle -= 180;
            rads = self.currentAngle;
            
            var transform2 = CGAffineTransformMakeRotation(CGFloat(rads));
            UIView.animateWithDuration(1.25, animations: {
                //self.wheel.animationRepeatCount = 3;
                self.wheel.transform = transform2;
            });
            
            self.currentAngle -= 180;
            rads = self.currentAngle;
            
            var transform5 = CGAffineTransformMakeRotation(CGFloat(rads));
            UIView.animateWithDuration(1.5, animations: {
                //self.wheel.animationRepeatCount = 3;
                self.wheel.transform = transform5;
            });
            
            self.currentAngle -= 180;
            rads = self.currentAngle;
            
            var transform6 = CGAffineTransformMakeRotation(CGFloat(rads));
            UIView.animateWithDuration(2, animations: {
                //self.wheel.animationRepeatCount = 3;
                self.wheel.transform = transform6;
            });
            
            self.currentAngle -= 180;
            rads = self.currentAngle;
            
            var transform7 = CGAffineTransformMakeRotation(CGFloat(rads));
            UIView.animateWithDuration(3, animations: {
                //self.wheel.animationRepeatCount = 3;
                self.wheel.transform = transform7;
            });
            
            self.currentAngle -= 180;
            rads = self.currentAngle;
            var transform3 = CGAffineTransformMakeRotation(CGFloat(rads));
            UIView.animateWithDuration(3.5, animations: {
                //self.wheel.animationRepeatCount = 3;
                self.wheel.transform = transform3;
            });
            
         
            self.currentAngle -= 180;
            rads = self.currentAngle;
            var transform4 = CGAffineTransformMakeRotation(CGFloat(rads));
            UIView.animateWithDuration(4, animations: {
                //self.wheel.animationRepeatCount = 3;
                self.wheel.transform = transform4;
            });
 
            
            /*self.wheel.animationDuration = 10000
            self.wheel.animationRepeatCount = 2;
            self.wheel.startAnimating()
            self.wheel.transform = transform;
            var rotationAnimation = CABasicAnimation();
            rotationAnimation.toValue = 180
            rotationAnimation.duration = 10000
            rotationAnimation.cumulative = true;
            rotationAnimation.repeatCount = 3
            self.wheel.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation") */
        });
        count+=1;
        
  
       
    
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let delay = 4.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                 self.updateTextBox()
            }
            
            self.WorkoutNumber.text = "\(self.count-1)";
            let progressBarPercent = Float((self.count)/9)
            self.progressBar.setProgress(progressBarPercent, animated: true)
        });
        
        
        
    }

    @IBAction func nextButton(sender: AnyObject) {
        
    }
    
    func updateTextBox() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var index = Int(self.count-1);
            index = index % 9;
            if index == 0 { // arm
                self.workoutExplanation.text = self.workouts[index];
            }
            else if index == 1 { // arm
                self.workoutExplanation.text = self.workouts[index-1];
            }
            else if index == 2 {
                self.workoutExplanation.text = self.workouts[index-1];
            }
            else if index == 3 {
                self.workoutExplanation.text = self.workouts[index-1];
            }
            else if index == 4{
                self.workoutExplanation.text = self.workouts[index-1];
                
            } else if index == 5 {
                self.workoutExplanation.text = self.workouts[index-1];
                
            } else if index == 6 {
                self.workoutExplanation.text = self.workouts[index-1];
                
            } else if index == 7 {
                self.workoutExplanation.text = self.workouts[index-1];
                
            } else if index == 8 {
                self.workoutExplanation.text = self.workouts[index-1];
            } else{
                self.workoutExplanation.text = "Do 50 pushups";
            }
            
        });
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var secondTab = self.popoverPresentationController as! ArenaViewController
        secondTab.fitCoinValue = self.fitCoins
    }*/
    

}
