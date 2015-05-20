
//
//  HomeVC.swift
//  multi-RSSFeed
//
//  Created by Mark Shine on 16/04/2015.
//  Copyright (c) 2015 Mark Shine. All rights reserved.
//

import UIKit

class RSSRemoveVC: UIViewController, UITableViewDataSource{
    
    
    
    @IBOutlet weak var rssTable: UITableView!
    @IBOutlet var usernameLabel : UILabel!
    var tableData = [String]()
    var URLData = [String]()
    var selectOpt:String!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rssTable.dataSource = self
        ReqData();
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = tableData[row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        self.selectOpt = URLData[row]
        
        RemoveRSS();
    }
    
    
    
    // MARK: Funcation
    // Request Solutions Viewed By User, Get History List
    func ReqData(){
        self.tableData = [String]()
        self.URLData = [String]()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        }else{
            println("User logged in")
            let username:NSString = prefs.valueForKey("USERNAME") as NSString
            
            if ( username.isEqualToString("")) {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Please enter Username and Password"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            } else {
                var post:NSString = "$username=\(username)"
                NSLog("PostData: %@",post);
                var url:NSURL = NSURL(string: "http://zippy-meteor-60-226751.euw1.nitrousbox.com/listrss.php")!
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
                        if var jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? Array<NSDictionary> {
                            
                            println("jsonArray: \(jsonArray)")
                            dispatch_async(dispatch_get_main_queue()) {
                                for var i:Int = 0; i < jsonArray.count; i++ {
                                    
                                    var id:String = jsonArray[i].valueForKey("id") as String
                                  
                                    self.URLData.append(id)
                                    
                                    var rssname = jsonArray[i].valueForKey("name") as String
                                    self.tableData.append("\(rssname)")
                                    self.rssTable.reloadData()
                                }
                            }
                        }else{
                            self.URLData.append("0")
                            self.tableData.append("No RSS Feed found.")
                        }
                    }
                })
                
            }
        }
    }
    
    func RemoveRSS(){
        
           var username = prefs.valueForKey("USERNAME") as String
            var post:NSString = "id=\(selectOpt)&username=\(username)"
            NSLog("PostData: %@",post);
            var url:NSURL = NSURL(string: "http://zippy-meteor-60-226751.euw1.nitrousbox.com/removerss.php")!
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
                            self.ReqData()
                            self.rssTable.reloadData()
                            
                            
                        }
                    }else{
                        
                    }
                }
            })
            
        }
    

    
}