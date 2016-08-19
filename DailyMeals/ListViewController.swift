//
//  ListViewController.swift
//  DailyMeals
//
//  Created by Mzalih on 18/11/15.
//  Copyright © 2015 Meals. All rights reserved.
//
//TO DO COMMENDTS (Add proper comments for all method)
import UIKit


class ListViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource,UISplitViewControllerDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var calLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    var detailViewController: DetailViewController? = nil
    var objects = DataStructure.getMeal()
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentTransparentNavigationBar();
        updateCalCount();
         //CAHNGE DEPRECATION WARNING
        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ListViewController.insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    func presentTransparentNavigationBar() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.setNavigationBarHidden(false, animated:true)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(self.tableView.indexPathForSelectedRow != nil){
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow! , animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(sender: AnyObject) {
        
        // Here goes the add button
        
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.section].foodItems[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.masterView = self
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                // self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return objects.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (objects[section].foodItems).count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let food = objects[indexPath.section].foodItems[indexPath.row]
        
        let label =  cell.viewWithTag(102) as? UILabel
        label?.text  = food.food!.name
        
        let label2 =  cell.viewWithTag(103) as? UILabel
        label2?.text = (food.food?.servingSize!.name)!;
        
        let label3 =  cell.viewWithTag(101) as? UILabel
        label3?.text = food.food!.calories.description + " kcal"
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects[indexPath.section].foodItems.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            updateCalCount();
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vheadView = UIView()
        vheadView.backgroundColor = UIColor.whiteColor()
        let  headerCell = UILabel()
        headerCell.frame=CGRectMake(15, 10, 200, 20)
        vheadView.addSubview(headerCell)
        
        headerCell.text = objects[section].name;
        //return sectionHeaderView
        return vheadView
    }
    func updateCalCount(){
        calLabel.text = (DataStructure.calculateTotalCalories(objects)).description + " kCal";
    }
    
    
    
}

