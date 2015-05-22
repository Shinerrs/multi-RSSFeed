//
//  
//  multi-RSSFeed
//
//  Created by Mark Shine on 16/04/2015.
//  Copyright (c) 2015 Mark Shine. All rights reserved.
//
import UIKit

class RSSDisplayVC: UIViewController{
    
    
    var sTitle:String!
    var sContent:String!
    var readMore:String!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var content: UILabel!
 
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
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
            println(self.sTitle)
          lbTitle.text = self.sTitle
          content.text = self.sContent
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a variable that you want to send
        
        if segue.identifier == "RSSReadMore" {
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destinationViewController as RSSWebViewVC
            
            destinationVC.url = readMore
            
        }
        
    }
    
    @IBAction func ReadMoreTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("RSSReadMore", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}