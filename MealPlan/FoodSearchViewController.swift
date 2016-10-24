//
//  FoodSearchViewController.swift
//  DailyMeals
//
//  Created by Jithu on 3/17/16.
//  Copyright © 2016 Meals. All rights reserved.
//
//TO DO COMMENDTS (Add proper comments for all method)
import UIKit

class FoodSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
    
    @IBOutlet var foodListTable : UITableView!
    @IBOutlet var closeButton : UIButton!
    
    var localData = DataHandler.readFoodsData("");
    var filterdData:[Food]?
    var meal:Meal?
    var filterText:String = ""
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        filterdData = localData;
        foodListTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterText = searchText.lowercaseString
        filterdData = localData.filter({
            
            if($0.name.lowercaseString.containsString(searchText.lowercaseString)){
                return true
            }
            return false
        });
        foodListTable.reloadData();
        
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        filterdData = localData;
        foodListTable.reloadData();

    }
    var searchTable:UITableView?
    //TABLEVIEW DELEGATE & DATASOURCE
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView == foodListTable ){
            return filterdData!.count
        }
        searchTable = tableView
        return filterdData!.count + 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("foodListCellIdentifier") as? FoodListTableViewCell
        if(cell == nil){
            cell = FoodListTableViewCell();
        }
        
        if(filterdData?.count == indexPath.row){
            cell!.textLabel?.text = "Search online"
        }else{
            cell!.textLabel?.text = filterdData![indexPath.row].name
        }
        return cell!
        
    }
    
    
    @IBAction func CloseAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(filterdData?.count == indexPath.row){
           // print( "Search online")
            searchOnline(filterText);
        }else{
            let food = filterdData![indexPath.row];
            let item = DataHandler.createFoodItem(food, numberServing: 1)
            if(meal != nil){
                
                //DataHandler.addFoodItemToMeal(meal!, foodItem:item);
            }
           // self.navigationController?.popViewControllerAnimated(true)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let scene = storyboard.instantiateViewControllerWithIdentifier("servingDetails") as! DetailViewController
            scene.detailItem = item
            //scene.hideAddButton = false
            scene.meal = meal
            self.navigationController?.pushViewController(scene, animated: true)
        }
    }
    
    
    func searchOnline(text:String){
        //encode a URL string for accepting all special characters in search.
        let originalString = text
        let escapedString = originalString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        Connect.fetchFoodItems(escapedString!, limit: Constants.API_SEARCH_LIMIT, offset:Constants.API_SEARCH_OFSET, view: self.view) { (items, status) -> Void in
            if(status){
                //Move now
                self.filterdData = items;
                self.searchTable?.reloadData();
            }
            else{
                // create the alert
                let alert = UIAlertController(title: "", message: "No more data", preferredStyle: UIAlertControllerStyle.Alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                // show the alert
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
                
                
                
                return
            }

        }
        
    }
    
    
    
}
