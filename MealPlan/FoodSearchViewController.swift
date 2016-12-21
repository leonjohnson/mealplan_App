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
    @IBOutlet var addNewFoodButton : MPButton!
    
    var localData : [Food]?
    var filterdData:[Food]?
    var meal:Meal?
    var filterText:String = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        localData = DataHandler.readFoodsData("");
        filterdData = localData;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        foodListTable.delegate = self
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        addNewFoodButton.setAttributedTitle(NSAttributedString(string:"Add item +", attributes:
            [NSFontAttributeName:Constants.MEAL_PLAN_SUBTITLE, 
             NSForegroundColorAttributeName:Constants.MP_WHITE,
             NSParagraphStyleAttributeName:paragraphStyle]), for: UIControlState())
        addNewFoodButton.layer.cornerRadius = 15
        
                
        //addNewFoodButton.addTarget(self, action: #selector(FoodSearchViewController.callBot), for: UIControlEvents.touchUpInside)
        
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterText = searchText.lowercased()
        filterdData = localData?.filter({
            
            if($0.name.lowercased().contains(searchText.lowercased())){
                return true
            }
            return false
        });
        foodListTable.reloadData();
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterdData = localData;
        foodListTable.reloadData();

    }
    var searchTable:UITableView?
    //TABLEVIEW DELEGATE & DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView == foodListTable ){
            return filterdData!.count
        }
        searchTable = tableView
        return filterdData!.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TABLE_ROW_HEIGHT_SMALL
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "foodListCellIdentifier") as? FoodListTableViewCell
        if(cell == nil){
            cell = FoodListTableViewCell();
        }
        
        if(filterdData?.count == indexPath.row){
            cell!.textLabel?.text = "Search online"
        }else{
            cell!.textLabel?.text = filterdData![indexPath.row].name
        }
        cell?.textLabel?.attributedText = NSAttributedString(string: (cell!.textLabel?.text)!, attributes: [NSFontAttributeName:Constants.STANDARD_FONT/*, NSForegroundColorAttributeName:Constants.MP_GREY*/])
        
        return cell!
        
    }
    
    
    @IBAction func CloseAction(_ sender: AnyObject) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            let scene = storyboard.instantiateViewController(withIdentifier: "servingDetails") as! DetailViewController
            scene.detailItem = item
            scene.newItemMode = true
            //scene.hideAddButton = false
            scene.meal = meal
            self.navigationController?.pushViewController(scene, animated: true)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vheadView = UIView()
        
        vheadView.backgroundColor = UIColor.lightGray
        
        let  headerCell = UILabel()
        headerCell.frame=CGRect(x: 10, y: 50, width: tableView.frame.width, height: 20)
        vheadView.addSubview(headerCell)
        headerCell.attributedText = NSAttributedString(string: "test", attributes: [NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        
        
        //create label inside header view
        let calorieCountLabel = UILabel()
        
        calorieCountLabel.frame = CGRect(x: 10, y: 10, width: tableView.frame.width-30, height: 20)
        calorieCountLabel.textAlignment = NSTextAlignment.right
        calorieCountLabel.textColor = UIColor.white
        calorieCountLabel.font = Constants.STANDARD_FONT
        
        vheadView.addSubview(calorieCountLabel)
        
        
        
        
        return vheadView
    }
    
    
    
    
    func searchOnline(_ text:String){
        //encode a URL string for accepting all special characters in search.
        let originalString = text
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        Connect.fetchFoodItems(escapedString!, limit: Constants.API_SEARCH_LIMIT, offset:Constants.API_SEARCH_OFSET, view: self.view) { (items, status) -> Void in
            if(status){
                //Move now
                self.filterdData = items;
                self.searchTable?.reloadData();
            }
            else{
                // create the alert
                let alert = UIAlertController(title: "", message: "No more data", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)  
                return
            }

        }
        
    }
    
    
    func callBot(){
        let storyboard = Constants.BOT_STORYBOARD
        let scene = storyboard.instantiateViewController(withIdentifier: "bot") as! BotController
        scene.botType = .addNewFood
        
        if((self.navigationController) != nil){
            scene.hidesBottomBarWhenPushed = true
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.navigationBar.frame.size = CGSize(width: (self.navigationController?.navigationBar.frame.width)!, height: 35)
            
            self.navigationController?.pushViewController(scene, animated: true);
            
            
            //self.hidesBottomBarWhenPushed = false;
        }else{
            self.present(scene, animated: true, completion: nil)
        }
    }

    
}
