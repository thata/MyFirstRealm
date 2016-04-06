//
//  MasterViewController.swift
//  MyFirstRealm
//
//  Created by Takashi Hatakeyama on 2016/04/05.
//  Copyright © 2016年 esm. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import Alamofire

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [User]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(MasterViewController.insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // ユーザをロード
        loadUsers()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        // 適当なユーザを1件追加
        let url: NSURL = NSURL(string: "https://sample-json.herokuapp.com/users.json")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = "user[name]=thata&user[age]=20".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.loadUsers()
            })
        }
        task.resume()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = String(format: "%@", object.name)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    
    func loadUsers() {
        // ユーザ一覧をJSON形式で取得
        Alamofire.request(.GET, "https://sample-json.herokuapp.com/users.json").responseJSON { response in
            if let json = response.result.value {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    let realm = RealmStore.sharedInstance

                    // JSONで取得したユーザ一覧をRealmへ登録
                    let users = Mapper<User>().mapArray(json)
                    if let users = users {
                        try! realm.write({
                            realm.add(users, update: true)
                        })
                    }

                    // Realmへ登録したユーザ一覧をobjectsへセット
                    self.objects = realm.objects(User).map({ $0 })
                    
                    self.tableView.reloadData()
                })
            }
        }
    }
}

