//
//  RSSListVC.swift
//  multi-RSSFeed
//
//  Created by Mark Shine on 16/04/2015.
//  Copyright (c) 2015 Mark Shine. All rights reserved.
//


import UIKit

class RSSListVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    
    @IBOutlet weak var rssTable: UITableView!
    @IBOutlet var usernameLabel : UILabel!
    var tableData = [String]()
    var detail = [String]()
    var linkData = [String]()
    var selectOpt:String!
    var stitle:String!
    var scontent:String!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let textCellIdentifier = "TextCell"
    var sreadmore:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rssTable.dataSource = self
        rssTable.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        println("URL: \(self.selectOpt)")
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            
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
        cell.detailTextLabel?.text = detail[row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        println(self.selectOpt)
        let row = indexPath.row

        self.stitle = tableData[row]
        self.scontent = detail[row]
        self.sreadmore = linkData[row]
        
        self.performSegueWithIdentifier("RSSShow", sender: self)
      
    }
    
    
    
    // MARK: Funcation
    // Request Solutions Viewed By User, Get History List
    func ReqData(){
        self.tableData = [String]()
        self.detail = [String]()
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
                println()
                var post:NSString = "url=\(selectOpt)"
                NSLog("PostData: %@",post);
                var url:NSURL = NSURL(string: "http://zippy-meteor-60-226751.euw1.nitrousbox.com/getrss.php")!
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
                            if var jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary {
                                
                                println("jsonArray: \(jsonArray)")
                                
                                dispatch_async(dispatch_get_main_queue()) {
                                    for var i:Int = 0; i < 10; i++ {
                                        
                                        var title:String = jsonArray.valueForKeyPath("rss.channel.item:\(i).title") as String
                                        self.tableData.append(title)
                                        var content:String = jsonArray.valueForKeyPath("rss.channel.item:\(i).description") as String
                                        self.detail.append(content)
                                        var link:String = jsonArray.valueForKeyPath("rss.channel.item:\(i).link") as String
                                        self.linkData.append(link)
                                        
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
                println(detail)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a variable that you want to send
        
        if segue.identifier == "RSSShow" {
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destinationViewController as RSSDisplayVC
            destinationVC.sTitle = self.stitle
            destinationVC.sContent = self.scontent
            destinationVC.readMore = self.sreadmore
            println("Segued! \(self.stitle)")
        }
    }
   
    
    @IBAction func logoutTapped(sender : UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}