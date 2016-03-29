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
    @IBAction func spinButton(sender: AnyObject) {
        print("in rotation")
       
      let image = wheel.image!;
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var rads = 180.0;
             var randomNum = Double(Int(arc4random_uniform(8) + 1))
            print("random Num:\(randomNum)")
            if self.count == 1 {
                print("in here");
                rads = (self.count*((randomNum*22.5)+11.25 )*3.14/180);
            } else {
                rads = self.count*randomNum*22.5*(3.14/180);
            }
            
            
            var transform = CGAffineTransformMakeRotation(CGFloat(rads));
            UIView.animateWithDuration(1, animations: {
                
                self.wheel.transform = transform;
             
               // self.wheel.transform = transform;
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
