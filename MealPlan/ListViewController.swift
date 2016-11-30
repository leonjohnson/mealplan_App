//
//  ListViewController.swift
//  DailyMeals
//
//  Created by Mzalih on 18/11/15.
//  Copyright © 2015 Meals. All rights reserved.
//
//TO DO COMMENDTS (Add proper comments for all method)
import UIKit
import RealmSwift


class ListViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource,UISplitViewControllerDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var calLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    var detailViewController: DetailViewController? = nil
    var objects = MealPlanAlgorithm.getMeal()
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        presentTransparentNavigationBar();
        updateCalCount();
         //CAHNGE DEPRECATION WARNING
        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ListViewController.insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    func presentTransparentNavigationBar() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.setNavigationBarHidden(false, animated:true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.tableView.indexPathForSelectedRow != nil){
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow! , animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(_ sender: AnyObject) {
        
        // Here goes the add button
        
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.section].foodItems[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.masterView = self
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                // self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (objects[section].foodItems).count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let food = objects[indexPath.section].foodItems[indexPath.row]
        
        let label =  cell.viewWithTag(102) as? UILabel
        label?.text  = food.food!.name
        
        let label2 =  cell.viewWithTag(103) as? UILabel
        label2?.text = (food.food?.servingSize!.name)!;
        
        let label3 =  cell.viewWithTag(101) as? UILabel
        label3?.text = food.food!.calories.description + " kcal"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //objects[indexPath.section].foodItems.removeAtIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateCalCount();
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vheadView = UIView()
        vheadView.backgroundColor = UIColor.white
        let  headerCell = UILabel()
        headerCell.frame=CGRect(x: 15, y: 10, width: 200, height: 20)
        vheadView.addSubview(headerCell)
        
        headerCell.text = objects[section].name;
        //return sectionHeaderView
        return vheadView
    }
    func updateCalCount(){
        calLabel.text = (MealPlanAlgorithm.calculateTotalCalories(objects)).description + " kCal";
    }
    
    
    
}

