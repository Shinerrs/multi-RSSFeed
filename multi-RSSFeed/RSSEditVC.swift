//
//  RSSAddVC.swift
//  multi-RSSFeed
//
//  Created by Mark Shine on 16/04/2015.
//  Copyright (c) 2015 Mark Shine. All rights reserved.
//


import UIKit

class RSSEditVC: UIViewController{
    
    
    
   
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var urlLabel: UITextField!
    var sID:String!
    var sName:String!
    var sUrl:String!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        nameLabel.text = sName
        urlLabel.text = sUrl
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
    
    func verifyUrl(urlString: String?) ->Bool{
        //Check for nil
        if let urlString = urlString{
            //Create NSURL instance
            if let url = NSURL(string: urlString){
                //Check if your application can open the NSURL instance
                if UIApplication.sharedApplication().canOpenURL(url){
                    return true
                } else { return false }
            }else { return false }
        } else { return false }
    }
    
    @IBAction func EditButton(sender: AnyObject) {
        var url:String = urlLabel.text
        var name:NSString = nameLabel.text
        if verifyUrl(url){
        if ( name.isEqualToString("")) {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            var username = prefs.valueForKey("USERNAME") as String
            var post:NSString = "rssurl=\(url)&rssName=\(name)&id=\(sID)"
            NSLog("PostData: %@",post);
            var url:NSURL = NSURL(string: "http://zippy-meteor-60-226751.euw1.nitrousbox.com/editrss.php")!
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
        }else{
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Not a Valid URL"
            alertView.message = "The RSS Feed has failed, please check your URL and try again."
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
    }
}

// MARK: Funcation
// Request Solutions Viewed By User, Get History List
  