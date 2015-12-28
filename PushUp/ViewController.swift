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
        dispatch_async(dispatch_get_main_queue()) {
            self.counterLabel.text = String(format:"%d", self.counter);
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSessionPresetLow;
        let devices = AVCaptureDevice.devices();
        
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if (device.position == AVCaptureDevicePosition.Front) {
                    captureDevice = device as? AVCaptureDevice;
                    if (captureDevice != nil) {
                        beginSession();
                    }
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func beginSession() {
        var err : NSError? = nil;
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch _ {
            print("error: \(err?.localizedDescription)");
        }
        
        captureSession.startRunning();
        let output = AVCaptureVideoDataOutput();
        output.setSampleBufferDelegate(self, queue: dispatch_queue_create("sample buffer", DISPATCH_QUEUE_SERIAL));
        captureSession.addOutput(output);
    }
    
    func captureOutput(captureOutput : AVCaptureOutput, sampleBuffer : CMSampleBufferRef) {
        
    }
    
    // protocol implementation
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        let metadataDict : Dictionary = CMCopyDictionaryOfAttachments(nil, sampleBuffer, kCMAttachmentMode_ShouldPropagate)! as Dictionary;
        let exifMetadata : NSMutableDictionary = metadataDict[kCGImagePropertyExifDictionary as NSString] as! NSMutableDictionary;
        let brightnessValue = exifMetadata[kCGImagePropertyExifBrightnessValue as NSString] as! Float;
        if (brightnessValue <= 1.0 && !inProgress) {
            inProgress = true;
        }
        if (brightnessValue > 1.0 && inProgress) {
            inProgress = false;
            counter++;
            dispatch_async(dispatch_get_main_queue()) {
                self.counterLabel.text = String(format:"%d", self.counter);
            }
            print(String(format:"brightness value: %.2f", brightnessValue));
        }
    }
}

