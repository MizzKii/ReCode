//
//  ViewController.swift
//  ReCode
//
//  Created by Panudech Chuangnuktum on 4/13/2558 BE.
//  Copyright (c) 2558 MizzKii. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var ip = "http://54.191.102.248/index.php/login/json/"
    var managedContext:NSManagedObjectContext?
    var results:[NSManagedObject]?
    
    var sound = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext!
        let request = NSFetchRequest(entityName:"Data")
        results =  managedContext!.executeFetchRequest(request,error: nil) as? [NSManagedObject]
        
        
       // NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("Check"), userInfo: nil, repeats: false)
//        let v = self.storyboard?.instantiateViewControllerWithIdentifier("Code") as! GenCode
//        self.navigationController?.pushViewController(v, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        Check()
    }
    
    private func Check() {
        if results?.count > 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("Code") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Login(sender: UIButton) {
        
        let user:String = username.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let pass:String = password.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if user != "" && pass != "" {
            let url = "\(ip)\(pass)/\(user)/"
            
            
            //2
    //        let entity =  NSEntityDescription
    //            .entityForName("Data",
    //            inManagedObjectContext:
    //            managedContext)
    //        
    //        let data = NSManagedObject(entity: entity!,
    //            insertIntoManagedObjectContext:managedContext)
            
            //let data = NSEntityDescription.insertNewObjectForEntityForName("Data", inManagedObjectContext: managedContext) as! NSManagedObject
            
            
            
            //3
    //        data.setValue(url, forKey: "url")
    //        managedContext.save(nil)
            
            if results!.count > 0 {
                results![0].setValue(url, forKey: "url")
            }else {
                let data = NSEntityDescription.insertNewObjectForEntityForName("Data", inManagedObjectContext: managedContext!) as! NSManagedObject
                data.setValue(url, forKey: "url")
            }
            
            //4
            //println(data)
            var error: NSError?
            if !managedContext!.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }else {
                Play()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("Code") as! UIViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    private func Play() {
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("whoos_wipe", ofType: "mp3")!)
        
//        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
//        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        sound = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        //sound.prepareToPlay()
        sound.play()
    }

}

