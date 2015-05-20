//
//  RSSAddVC.swift
//  multi-RSSFeed
//
//  Created by Mark Shine on 16/04/2015.
//  Copyright (c) 2015 Mark Shine. All rights reserved.
//


import UIKit

class RSSAddVC: UIViewController{
    
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var urlTF: UITextField!
    
    
    
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SaveButton(sender: AnyObject) {
        var url:NSString = urlTF.text
        var name:NSString = nameTF.text
        if ( url.isEqualToString("")) {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            var username = prefs.valueForKey("USERNAME") as String
            var post:NSString = "rssurl=\(url)&rssName=\(name)&username=\(username)"
            NSLog("PostData: %@",post);
            var url:NSURL = NSURL(string: "http://zippy-meteor-60-226751.euw1.nitrousbox.com/addrss.php")!
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String( postData.length )
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.timeoutInterval = 30
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            let queue:NSOperationQueue = NSOperationQueue()
            
            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                var err: NSError
                let res = response as NSHTTPURLResponse!
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    
                    var error: NSError?
                    if var jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary {
                        
                        println("jsonArray: \(jsonArray)")
                        dispatch_async(dispatch_get_main_queue()) {
                            
                                var success:Int = jsonArray.valueForKey("success") as Int
                            if success == 1 {
                                var alertView:UIAlertView = UIAlertView()
                                alertView.title = "RSS Add Successfully"
                                alertView.message = "The RSS Feed has been added to your account."
                                alertView.delegate = self
                                alertView.addButtonWithTitle("OK")
                                alertView.show()
 
                            }else{
                                var alertView:UIAlertView = UIAlertView()
                                alertView.title = "RSS Add Failed"
                                alertView.message = "The RSS Feed has failed, please try again."
                                alertView.delegate = self
                                alertView.addButtonWithTitle("OK")
                                alertView.show()
 
                            }
                               
                            
                        }
                    }else{
                        
                    }
                }
            })
            
        }
    }

    }

    // MARK: Funcation
    // Request Solutions Viewed By User, Get History List
  