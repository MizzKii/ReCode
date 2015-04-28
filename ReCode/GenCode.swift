//
//  GenCode.swift
//  ReCode
//
//  Created by Panudech Chuangnuktum on 4/13/2558 BE.
//  Copyright (c) 2558 MizzKii. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation

class GenCode: UIViewController {
    
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var reCode: UIButton!
    var url:String = ""
    var change = false
    var timer:NSTimer?
    var code = ""
    
    var managedContext:NSManagedObjectContext?
    var fetchedResults:[NSManagedObject]?
    
    var alert:UIAlertController?
    
    var sound = AVAudioPlayer()
    var first = true
    
    override func viewDidLoad() {
        //url = NSUserDefaults.standardUserDefaults().objectForKey("url") as String
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        
        //2
        let Data = NSFetchRequest(entityName:"Data")
        
        //3
        var error: NSError?
        
        fetchedResults =  managedContext!.executeFetchRequest(Data,error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            for result in results {
                let tmp = result.valueForKey("url") as! String
                println("+\(tmp)")
            }
            url = results[0].valueForKey("url") as! String
            println("-\(url)")
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        Gen()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("UpdateCode"), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert!, animated: true, completion: nil)
    }
    
    func Gen() {
        let url = NSURL(string: self.url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error
            -> Void in
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            self.code = jsonResult["code"] as! String
            println(self.code)
            self.change = true
        })
        task.resume()
    }
    
    func UpdateCode() {
        if(change) {
            change = false
            self.codeField.text = code
            reCode.enabled = true
            
            alert?.dismissViewControllerAnimated(true, completion: nil)
            if code == "Fail" {
                alert = UIAlertController(title: "Fail", message: "Username or Password Incorrect.", preferredStyle: UIAlertControllerStyle.Alert)
//                let tryAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default){ (ac: UIAlertAction!) -> Void in
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewControllerWithIdentifier("SignIn") as! UIViewController
//                    self.presentViewController(vc, animated: true, completion: nil)
//                }
                let tryAction = UIAlertAction(title: "Try Again", style: .Default, handler: {(action:UIAlertAction!)-> Void in
                self.SignOut() })
                alert?.addAction(tryAction)
                self.presentViewController(alert!, animated: true, completion: nil)
            }else {
                if first {
                    Play("on_top_of_the_world")
                    first = false
                }
            }
        }
    }
    
    @IBAction func ReCode(sender: UIButton) {
        reCode.enabled = false
        codeField.text = "Load..."
        Gen();
        alert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert!, animated: true, completion: nil)
    }
    
    @IBAction func LogOut(sender: UIButton) {
        SignOut()
    }
    
    private func SignOut() {
        Play("whoos_wipe")
        
        managedContext!.deleteObject(fetchedResults![0])
        fetchedResults!.removeAtIndex(0)
        
        var error: NSError?
        if !managedContext!.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SignIn") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    private func Play(name:String) {
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: "mp3")!)
        
	        
        var error:NSError?
        sound = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        //sound.prepareToPlay()
        sound.play()
    }
}