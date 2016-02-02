//
//  ViewController.swift
//  Superheropedia
//
//  Created by Wong You Jing on 01/02/2016.
//  Copyright © 2016 NoNonsense. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var heroes = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Superheropedia"
//        let batmanDictionary = ["name": "Batman", "identity": "Bruce Wayne"]
//        let greenLanternDictionary = ["name": "Green Lantern", "identity": "Hal Jordan"]
        let url = NSURL(string: "https://s3.amazonaws.com/mmios8week/superheroes.json")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do {
                self.heroes = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [NSDictionary]
                self.tableView.reloadData()
            }
            catch let error as NSError{
                print("json error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        let superhero = heroes[indexPath.row]
        cell.textLabel?.text = superhero.objectForKey("name") as? String
        cell.detailTextLabel?.text = superhero.objectForKey("description") as? String
        let url = NSURL(string: superhero.objectForKey("avatar_url") as! String )
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.imageView?.image = UIImage(data: data!)
                
                cell.layoutSubviews()
                
            })
        }
        
        task.resume()
        
        
        return cell
        
    }


}

