//
//  Step3ViewController.swift
//  DailyMeals
//
//  Created by Jithu on 3/14/16.
//  Copyright © 2016 Meals. All rights reserved.
//
//TO DO COMMENDTS (Add proper comments for all method)
import UIKit

class Step3ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //var fromController = NSString()
    
    @IBOutlet var backButton : UIButton!
    @IBOutlet var likeFoodListTable : UITableView!
    @IBOutlet var likeFoodLabel : UILabel!
    @IBOutlet weak var likeSearchBar: UISearchBar!
    @IBOutlet var step3NextButton : MPButton!
    @IBOutlet var closeButton : UIButton!
    
    //variable created for constant class
    let profile = DataHandler.getLikeFoods()
    
    //Deafult Value setting
    var likeFoodValue = NSMutableArray()

    
    var localData = DataHandler.readFoodsData("");
    var filterdData:[Food]?
    var resultSearchController = UISearchController()
  
    //For SettingsTab bar
    var settingsControl : Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To hide close button when app. loads normaly from Profile view.
        closeButton.isHidden = true
        
        
        if (settingsControl != nil){
            
            //Close Button whn app. loads from settings view.
            closeButton.isHidden = false
            
            let arrayOfObjects = Array(DataHandler.getLikeFoods().foods);
            
            for item in arrayOfObjects{
                likeFoodValue.add(item)
            }
          
            
        }
        
        filterdData = localData
        likeFoodListTable.delegate = self
        
        //For Multiselecting the cells in Table
        self.likeFoodListTable.allowsMultipleSelection = true
        
        
        //Attributing likeFoodLabel style fro two font
        let attrsA = [NSFontAttributeName: Constants.FOOD_LABEL_FONT, NSForegroundColorAttributeName:Constants.FOOD_LABEL_COLOR]
        let a = NSMutableAttributedString(string:Constants.THE_FOODS_STRING, attributes:attrsA)
        let attrsB =  [NSFontAttributeName: Constants.FOOD_LABEL_FONT_BOLD, NSForegroundColorAttributeName: Constants.FOOD_LABEL_COLOR]
        let b = NSAttributedString(string:Constants.LIKE_STRING, attributes:attrsB)
        
        a.append(b)
        //likeFoodLabel.attributedText = a
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func closeAction(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    

    //MealPlanListTable Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return filterdData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "step3CellIdentifier", for: indexPath) as! Step3TableViewCell
        cell.textLabel?.text = filterdData![indexPath.row].name
        cell.textLabel?.font = Constants.STANDARD_FONT
        
        if(likeFoodValue.contains(filterdData![indexPath.row])){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }  
        return cell
    }
    
    //Selecting Multiple Cells
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
            if(likeFoodValue.contains(filterdData![indexPath.row])){
                likeFoodValue.remove(filterdData![indexPath.row])
                cell!.accessoryType = UITableViewCellAccessoryType.none
            }else{
                if likeFoodValue.count < 5 {
                    likeFoodValue.add(filterdData![indexPath.row])
                    cell!.accessoryType = UITableViewCellAccessoryType.checkmark
                }
            }
        tableView.deselectRow(at: indexPath, animated: true)
        likeSearchBar.resignFirstResponder()

    }
    
    //DeSelecting Multiple Cells
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        likeSearchBar.resignFirstResponder()
    }
    
    
    
    
    
    //SearchBar Delegates
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            filterdData = localData
            likeSearchBar.resignFirstResponder()
        }else{
            filterdData = localData.filter({
                
                if($0.name.lowercased().contains(searchText.lowercased())){
                    return true
                }
                return false
            });
        }
        likeFoodListTable.reloadData();
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.likeSearchBar.endEditing(true)
    }


    
    
    //IBAction for NextButton Clicked in Step3 VC. Saving all datas into an ProfileClass.
    @IBAction func step3NextButtonClicked (_ sender : AnyObject){
        DataHandler.updateLikeFoods(likeFoodValue)
        //if from Settings Tab bar View.
        if ((settingsControl) != nil){
            _ = self.navigationController?.popViewController(animated: true)
        }else{
        self.performSegue(withIdentifier: "step3Identifier", sender: nil)
        }


    }
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func BackAction(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}
