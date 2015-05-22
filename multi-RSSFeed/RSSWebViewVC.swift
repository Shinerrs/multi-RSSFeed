//
//  RSSWebViewVC.swift
//  multi-RSSFeed
//
//  Created by Mark Shine on 22/05/2015.
//  Copyright (c) 2015 Mark Shine. All rights reserved.
//

import UIKit

class RSSWebViewVC: UIViewController{
    
    
    @IBOutlet weak var webView: UIWebView!
    var url:String!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL (string: self.url);
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
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
    
}