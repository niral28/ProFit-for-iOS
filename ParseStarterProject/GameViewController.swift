//
//  GameViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Niral Shah on 3/28/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var wheel: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    var count = 1.0;
    var currentAngle = 0.0;
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
