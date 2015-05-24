//
//  HomeVC.swift
//  multi-RSSFeed
//
//  Created by Mark Shine on 16/04/2015.
//  Copyright (c) 2015 Mark Shine. All rights reserved.
//
import UIKit

class HomeVC: UIViewController, UITableViewDataSource{

    
    @IBOutlet weak var rssTable: UITableView!
    @IBOutlet var usernameLabel : UILabel!
    var tableData = [String]()
    var URLData = [String]()
    var IDData = [String]()
    var selectOpt:String!
    var editName:String!
    var editUrl:String!
    var editID:String!
    var idToDelete:String!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rssTable.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            self.usernameLabel.text = prefs.valueForKey("USERNAME") as NSString
        }
        ReqData();
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
        self.performSegueWithIdentifier("RSSFeedList", sender: self)
    }
    
     func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        var delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let row = indexPath.row
            self.idToDelete = self.IDData[row]
            self.RemoveRSS();
        })
        delete.backgroundColor = UIColor.redColor()
        
        var edit = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let row = indexPath.row
            self.editName = self.tableData[row]
            self.editUrl = self.URLData[row]
            self.editID = self.IDData[row]
            self.performSegueWithIdentifier("RSSEdit", sender: self)
        })
        edit.backgroundColor = UIColor.blueColor()
        
        return [delete, edit]
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
        }
    }
    
    // MARK: Funcation
    // Request Solutions Viewed By User, Get History List
    func ReqData(){
        self.tableData = [String]()
        self.URLData = [String]()
        self.IDData = [String]()
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
                var post:NSString = "username=\(username)"
                NSLog("PostData: %@",post);
                var url:NSURL = NSURL(string: "http://zippy-meteor-60-226751.euw1.nitrousbox.com/listrss.php")!
                var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                
                var postLength:NSString = String( postData.length )
                
                var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                request.timeoutInterval = 10
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
                    if res == nil {
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Network Issue!"
                        alertView.message = "There is a problem with the network to the server. Please check your internet connection and try again."
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }else{
                    if (res.statusCode >= 200 && res.statusCode < 300)
                    {
                        
                        var error: NSError?
                        if var jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? Array<NSDictionary> {
                            
                            println("jsonArray: \(jsonArray)")
                            dispatch_async(dispatch_get_main_queue()) {
                                for var i:Int = 0; i < jsonArray.count; i++ {
                                    var id:String = jsonArray[i].valueForKey("id") as String
                                    
                                    self.IDData.append(id)
                                    var url:String = jsonArray[i].valueForKey("url") as String
                                    println(url)
                                    self.URLData.append(url)
                                    
                                    var rssname = jsonArray[i].valueForKey("name") as String
                                    self.tableData.append("\(rssname)")
                                    self.rssTable.reloadData()
                                }
                            }
                        }else{
                            var alertView:UIAlertView = UIAlertView()
                            alertView.title = "No Results!"
                            alertView.message = "No results in our database found."
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()
                        }
                    }else{
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Network Issue!"
                        alertView.message = "There is a problem with the network to the server. Please check your internet connection and try again."
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                    }
                })
                println(URLData)
            }
        }
    }
    
    func RemoveRSS(){
        
        var username = prefs.valueForKey("USERNAME") as String
        var post:NSString = "id=\(idToDelete)&username=\(username)"
        NSLog("PostData: %@",post);
        var url:NSURL = NSURL(string: "http://zippy-meteor-60-226751.euw1.nitrousbox.com/removerss.php")!
        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        var postLength:NSString = String( postData.length )
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.timeoutInterval = 10
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
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "RSS Retrieve Failed"
                    alertView.message = "The RSS Feed has failed, please try again."
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }
        })
        
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a variable that you want to send
        
        if segue.identifier == "RSSEdit" {
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destinationViewController as RSSEditVC
            
            destinationVC.sID = self.editID
            destinationVC.sName = self.editName
            destinationVC.sUrl = self.editUrl
        }
        
        if segue.identifier == "RSSFeedList" {
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destinationViewController as RSSListVC
        destinationVC.selectOpt = self.selectOpt
        }
    }

    
    @IBAction func logoutTapped(sender : UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}