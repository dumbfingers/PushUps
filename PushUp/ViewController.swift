//
//  ViewController.swift
//  PushUp
//
//  Created by Yaxi Ye on 26/12/2015.
//  Copyright © 2015 Yaxi Ye. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    let captureSession = AVCaptureSession();
    var captureDevice : AVCaptureDevice?;
    var counter : Int = 0;
    var inProgress : Bool = false;

    @IBOutlet weak var counterLabel: UILabel!
    
    @IBAction func onResetClick(sender: UIButton) {
        self.counter = 0;
        self.counterLabel.text = String(format:"%d", self.counter);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.currentDevice().proximityMonitoringEnabled = true;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sensorStateChanged", name: "UIDeviceProximityStateDidChangeNotification", object: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sensorStateChanged() {
        if (UIDevice.currentDevice().proximityState == true && !inProgress) {
            inProgress = true;
            print("Close to user");
        } else {
            inProgress = false;
            print("Not close to user");
            counter++;
            self.counterLabel.text = String(format:"%d", self.counter);
        }
    }
}

