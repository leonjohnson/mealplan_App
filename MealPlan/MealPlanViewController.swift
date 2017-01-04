/*
 Show the date and back and forth buttons
 Load tomorrow when flick forward
 
 */

import UIKit
import RealmSwift
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



class MealPlanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MPTableViewCellDelegate, MPViewControllerDelegate {
    
    var showExplainerScreen : Bool?
    var settingsControl : Bool? //For SettingsTab bar
    
    //@IBOutlet var workOutIcon: UIView!
    @IBOutlet var mealPlanListTable : UITableView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var bkgrd: UIView!
    
    @IBOutlet weak var mealPlanDate: UILabel!
    @IBOutlet weak var backDateButton: UIButton!
    @IBOutlet weak var nextDateButton: UIButton!
    @IBOutlet weak var mealPlanTally: MacrosTallyView!
    
    var alertController : UIAlertController?
    var deleteSheetIndexSelected : Int = -1
    var dragger:DragToTable?
    var meals :[Meal] = [Meal]()
    var thisWeek: Week = Week()
    var nextWeek: Week = Week()
    var dateCount:Int = 0
    var lastDayVisitedBeforeLeavingPage:Int = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var stringWithName = DataHandler.getActiveUser().name
        if stringWithName.uppercased().characters.last == "S"{
            stringWithName = stringWithName + "' meal plan"
        } else{
            stringWithName = stringWithName + "'s meal plan"
        }
        nameLabel.attributedText? = NSAttributedString(string:stringWithName, attributes:[NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        mealPlanTally.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        lastDayVisitedBeforeLeavingPage = dateCount
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealPlanListTable.delegate = self
        backDateButton.isUserInteractionEnabled = false
        backDateButton.alpha = 0.5
        thisWeek = SetUpMealPlan.getThisWeekAndNext()[0]
        let calendar: Calendar = Calendar.current
        let date1 = calendar.startOfDay(for: thisWeek.start_date as Date)
        let date2 = calendar.startOfDay(for: Date())
        let flags = NSCalendar.Unit.day
        let components = (calendar as NSCalendar).components(flags, from: date1, to: date2, options: []) // the difference in days
        print("Dates : \(date1) and \(date2)")
        
        
        dateCount = components.day!
        print("The difference in days = \(dateCount)")
        
        let dateForthisMealPlan = setDate()
        //meals = Array(data.meals)
        meals = Array(thisWeek.dailyMeals[dateCount].meals)
        
        mealPlanListTable.reloadData();
        mealPlanDate.text = dateForthisMealPlan // Monday June 30, 2014 10:42:21am PS
        mealPlanDate.attributedText? = NSAttributedString(string:mealPlanDate.text!, attributes:[NSFontAttributeName:Constants.MEAL_PLAN_DATE, NSForegroundColorAttributeName:Constants.MP_WHITE])

        Config.setBoolValue(Constants.HAS_PROFILE,status: true) // ENABLE TO MOVE TO START PAGE
        
        alertController = UIAlertController(title: "Reason for removing this food?",
                                            message: "",
                                            preferredStyle: .actionSheet)
        
        let tooEarlyAction : UIAlertAction = UIAlertAction(title: "Too early for this",
                                                           style: .destructive,
                                                           handler: {
                                                            (paramAction:UIAlertAction!) in
                                                            self.deleteSheetIndexSelected = 0
        })
        
        let dislikeAction : UIAlertAction = UIAlertAction(title: "Dislike this",
                                                          style: .destructive,
                                                          handler: {
                                                            (paramAction:UIAlertAction!) in
                                                            self.deleteSheetIndexSelected = 1
        })
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel",
                                                         style: .cancel,
                                                         handler: {
                                                            (paramAction:UIAlertAction!) in
                                                            self.alertController?.dismiss(animated: true, completion: nil)
        })
        
        
        alertController?.addAction(tooEarlyAction)
        alertController?.addAction(dislikeAction)
        alertController?.addAction(cancelAction)
        
        
        //self.workOutIcon.hidden = true
        
        //Code commented for Tempraory time based on client request.[code for view to drag to each meal plans header]
        //        dragger = DragToTable.activate(workOutIcon, table: mealPlanListTable, view: self.view, listen: { (indexPath) -> Void in
        //
        //            let item =  self.objects[indexPath.section]
        //
        //            if(item.foodItems.last?.food!.pk != 0){
        //
        //                let work = DataHandler.getOrCreateFood(0)
        //
        //                DataHandler.addFoodItemToMeal(item, foodItem:DataHandler.createFoodItem(work, numberServing: 1) )
        //            }
        //        })
        // Do any additional setup after loading the view.
    }

    
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
        changeMealPlanDisplayed(nil)
        //updateMacroTally(forDay: dateCount)
    }
    
    func getThisWeek()->Week{
        return thisWeek
    }
    
    func updateMacroTally(forDay:Int){
        var longString = ""
        let variance = thisWeek.dailyMeals[forDay].calculateMacroDiscrepancy(macros: thisWeek.macroAllocation)
        if variance.yesOrNo == false{
            mealPlanTally.headline.attributedText = NSAttributedString(string: "The macros in your meal plan are looking good today.", attributes:[NSFontAttributeName:Constants.SMALL_FONT, NSForegroundColorAttributeName:Constants.MP_WHITE])
            if let checkMark = UIImage(named: "macroCheckMark") {
                mealPlanTally.imageView.image = checkMark
            }
        } else {
            if variance.amount[Constants.PROTEINS] > 0 {
                longString.append("\n\(Constants.roundToPlaces(variance.amount[Constants.PROTEINS]!, decimalPlaces: 1))g of protein")
            }
            if variance.amount[Constants.CARBOHYDRATES] > 0 {
                longString.append("\n\(Constants.roundToPlaces(variance.amount[Constants.CARBOHYDRATES]!, decimalPlaces: 1))g of carbohyrdates")
            }
            if variance.amount[Constants.FATS] > 0 {
                longString.append("\n\(Constants.roundToPlaces(variance.amount[Constants.FATS]!, decimalPlaces: 1))g of fat")
            }
            mealPlanTally.headline.attributedText = NSAttributedString(string: "You need an extra: \(longString) today.", attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_WHITE])
            mealPlanTally.imageView.image = #imageLiteral(resourceName: "CrossMark")
            
            //"Out by: \(variance.amount[Constants.PROTEINS]), \(variance.amount[Constants.CARBOHYDRATES]), \(variance.amount[Constants.FATS])"
        }
    }

    
    
    func setDate() -> (String?) {
        var components = DateComponents()
        let index : Int = (dateCount > 6 && dateCount < 15) ? dateCount - 7 : dateCount
        components.day = index
        let dateForthisMealPlan = (Calendar.current as NSCalendar).date(byAdding: components, to: thisWeek.start_date as Date, options: NSCalendar.Options(rawValue: 0))
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        //mealPlanDate.text = formatter.stringFromDate(dateForthisMealPlan!) // Monday June 30, 2014 10:42:21am PS
        return formatter.string(from: dateForthisMealPlan!)
    }
    
    
    
    
    @IBAction func changeMealPlanDisplayed(_ sender: UIButton?){
        var index : Int?
        if sender != nil{
            dateCount = dateCount + (sender?.tag)!
        }
        

        //Update the mealPlan selected
        if dateCount > 6 && dateCount < 15 {
            //this is week 2
            thisWeek = SetUpMealPlan.getThisWeekAndNext()[1]
            index = dateCount - 7
        }
        
        if (dateCount >= 0) && (dateCount <= 6) {
            //this is week 1
            thisWeek = SetUpMealPlan.getThisWeekAndNext()[0]
            index = dateCount
        }
        
        let dateForthisMealPlan = setDate()

        //Update the buttons
        if dateCount == 0 {
            backDateButton.isUserInteractionEnabled = false
            backDateButton.alpha = 0.5
        } else {
            backDateButton.isUserInteractionEnabled = true
            backDateButton.alpha = 1.0
        }
        
        if (dateCount == 13) && (thisWeek == SetUpMealPlan.getThisWeekAndNext()[1]){
            nextDateButton.isUserInteractionEnabled = false
            nextDateButton.alpha = 0.5
        } else {
            nextDateButton.isUserInteractionEnabled = true
            nextDateButton.alpha = 1.0
        }
        
        if dateCount < 0{
            backDateButton.isUserInteractionEnabled = false
            backDateButton.alpha = 0.5
            return
        }
        
        //Update the UI
        
        mealPlanDate.text = dateForthisMealPlan
        mealPlanDate.attributedText? = NSAttributedString(string:mealPlanDate.text!, attributes:[NSFontAttributeName:Constants.MEAL_PLAN_DATE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        meals = Array(thisWeek.dailyMeals[index!].meals)
        mealPlanListTable.reloadData();
        //updateMacroTally(forDay: index!)
    }
    
    
    
    
    
    
    func handleNotification(){
        let notifications =  UIApplication.shared.scheduledLocalNotifications
        if(notifications?.count > 0)
        {
            // Cancel existing one
            fireNotification();
        }else
        {
            fireNotification();
        }
    }
    
    //For local Notification Alert:
    func enableLocalNotification(){
        let settings = UIUserNotificationSettings(types: [.alert, .badge , .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    
    
    func fireNotification(){
        let localNotification = UILocalNotification();
        localNotification.fireDate = Date(timeIntervalSinceNow: 60*60*24*7 );
        localNotification.alertTitle = "Share How "
        
        localNotification.alertBody = "Wow its a week again ";
        localNotification.timeZone = TimeZone.current;
        UIApplication.shared.scheduleLocalNotification(localNotification);
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 70
    }
    

    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (meals[section].foodItems).count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TABLE_ROW_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MPTableViewCell
        let foodItem : FoodItem = meals[indexPath.section].foodItems[indexPath.row]
        let label =  cell.viewWithTag(102) as? UILabel
        label?.attributedText = NSAttributedString(string: foodItem.food!.name, attributes:[NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        
        if(foodItem.food!.pk == 0){
            cell.backgroundColor =  UIColor(
                red:0.73,
                green:0.76,
                blue:1.0,
                alpha:1.0)
            
            let label2 =  cell.viewWithTag(103) as? UILabel
            label2?.text =  "";
            
            let label3 =  cell.viewWithTag(101) as? UILabel
            label3?.text =  ""
            
        } else {
            cell.backgroundColor = UIColor.clear;
            let label2 =  cell.viewWithTag(103) as? UILabel
            
            let q = ServingSize.getServingQuantityAsNumber((foodItem.food?.servingSize)!)
            let servingQuantityAsNumber = roundToPlaces(q, decimalPlaces: 2)
            
            var ending = foodItem.food!.servingSize!.name
            switch ending {
            case Constants.grams:
                ending = "g"
            case Constants.ml:
                ending = "ml"
            case Constants.slice:
                if foodItem.numberServing > 1{
                    ending = " slices"
                } else {
                    ending = " slice"
                }
            case Constants.item:
                if (foodItem.food?.name.hasSuffix("bread"))!{
                    ending = " " + ending
                } else {
                    ending = " " + (foodItem.food?.name)! + "s"
                }
                
            default:
                ending = " " + ending
            }
            
            let amount = Int(roundToPlaces((foodItem.numberServing * servingQuantityAsNumber), decimalPlaces: 0))

            label2?.attributedText = NSAttributedString(string: amount.description + ending, attributes:[NSFontAttributeName:Constants.MEAL_PLAN_SERVINGSIZE_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE]);
            
            let label3 =  cell.viewWithTag(101) as? UILabel
            label3?.attributedText = NSAttributedString(string: Int(foodItem.getTotalCal()).description, attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_WHITE])
            
            cell.delegate = self
            cell.foodItemIndexPath = indexPath
        }
        
        //cell seprator line programztically:
        let sep = UIView(frame:CGRect(x: 0, y: 1, width: cell.frame.size.width, height: 0.5) )
        sep.backgroundColor = UIColor.white
        cell.addSubview(sep)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //let fitem = meals[indexPath.section].foodItems[indexPath.row];
            //DataHandler.removeFoodItemFromMeal(meals[indexPath.section], index: indexPath.row)
            //DataHandler.removeFoodItem(fitem);
            
            /*
            self.presentViewController(alertController!, animated: true, completion: {
                
            })
            */
            
            //tableView.deleteRows(at: [indexPath], with: .fade)
            //tableView.reloadData();
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vheadView = UIView()
        vheadView.backgroundColor = UIColor.clear
        let headerCell = UILabel()
        headerCell.frame=CGRect(x: 10, y: 10, width: tableView.frame.width-30, height: 20)
        vheadView.addSubview(headerCell)
        headerCell.attributedText = NSAttributedString(string: meals[section].name, attributes: [NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        //create label inside header view
        let calorieCountLabel = UILabel()
        calorieCountLabel.frame = CGRect(x: 10, y: 10, width: tableView.frame.width-25, height: 20)
        calorieCountLabel.textAlignment = NSTextAlignment.right
        calorieCountLabel.textColor = UIColor.white
        calorieCountLabel.font = UIFont.systemFont(ofSize: 17)
        var totalCaloriesString = ""
        if meals[section].totalCalories() > 0 {
            totalCaloriesString = String(Int(meals[section].totalCalories()))
        } else {
            totalCaloriesString = "0"
        }
        
        //totalCaloriesString = Int(meals[section].totalCalories())
        calorieCountLabel.attributedText = NSAttributedString(string: totalCaloriesString + " kcal", attributes: [NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        vheadView.addSubview(calorieCountLabel)
        
        //create button inside header view
        let addItemButton = UIButton()
        addItemButton.frame = CGRect(x: 10, y: 25, width: self.view.frame.size.width - 100, height: 35)
        //addItemButton.setTitle("Add item + ", forState: UIControlState.Normal)
        addItemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        addItemButton.setAttributedTitle(NSAttributedString(string:"Add item +", attributes:[NSFontAttributeName:Constants.STANDARD_FONT_BOLD, NSForegroundColorAttributeName:Constants.MP_WHITE]), for: UIControlState())
        
        addItemButton.titleLabel?.textColor = UIColor.white
        addItemButton.titleLabel?.textAlignment = NSTextAlignment.left
        vheadView.addSubview(addItemButton)
        addItemButton.addTarget(self, action: #selector(MealPlanViewController.findFoodSearchAction(_:)), for: UIControlEvents.touchUpInside)
        //addItemButton.addTarget(self, action: "findFoodSearchAction:", forControlEvents: UIControlEvents.TouchUpInside)
        addItemButton.tag = section
        
        //let sep = UIView(frame:CGRectMake(0, 55, self.view.frame.size.width, 1) )
        //sep.backgroundColor = UIColor.whiteColor()
        //vheadView.addSubview(sep)
        
        return vheadView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    
    //IBAction for AddItemButton on Header view
    
    func findFoodSearchAction(_ sender: UIButton){
        
        let storyboard = UIStoryboard(name: "SearchForFood", bundle: nil)
        let scene = storyboard.instantiateViewController(withIdentifier: "foodSearchList") as! FoodSearchViewController
        scene.meal = meals[sender.tag]
        
        if((self.navigationController) != nil){
            self.navigationController?.pushViewController(scene, animated: true);
        }else{
            self.present(scene, animated: true, completion: nil)
        }
        
    }
    // MARK: - Segues
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let indexPath = self.mealPlanListTable.indexPathForSelectedRow {
            let object =   meals[indexPath.section].foodItems[indexPath.row]
            if(object.food!.pk == 0){
                self.mealPlanListTable.deselectRow(at: indexPath, animated: true)
                return false
            }
        }
        return true
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.mealPlanListTable.indexPathForSelectedRow {
                self.mealPlanListTable.deselectRow(at: indexPath, animated: true)
                let object =   meals[indexPath.section].foodItems[indexPath.row]
                let controller = segue.destination as! DetailViewController
                controller.delegate = self
                controller.meal = meals[indexPath.section]
                controller.detailItem = object
                controller.foodItemIndexPath = indexPath
                controller.newItemMode = false
                //controller.hideAddButton = true
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                // self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }
    
    
    func roundToPlaces(_ value: Double, decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return round(value * divisor) / divisor
    }
    
    
    
    
    // cell delegate
    func editFoodItemAtIndexPath(_ indexPath: IndexPath, editType: String) {
        switch deleteSheetIndexSelected {
        case 0:
            print("sheet 0")
        case 1:
            print("sheet 1")
        default:
            print("")
        }
        
        switch editType {
        case Constants.DELETE:
            print("delete called")
            self.present(alertController!, animated: true, completion: {
                let foodItem = self.meals[indexPath.section].foodItems[indexPath.row]
                DataHandler.removeFoodItem(foodItem)
                DataHandler.updateCalorieConsumption(thisWeek: self.thisWeek)
                //DataHandler.removeFoodItemFromMeal(meals[indexPath.section], index: indexPath.row)
                //mealPlanListTable.reloadData()
                //self.mealPlanListTable.reloadSections(sections as IndexSet, with: .automatic)
                //http://stackoverflow.com/questions/14576921/uitableview-reloaddata-with-animation
                let sections = NSIndexSet(index: indexPath.section)
                self.mealPlanListTable.reloadSections(sections as IndexSet, with: .automatic)
            })
         case Constants.EDIT:
            print("edit called")
            let fi = meals[indexPath.section].foodItems[indexPath.row]
            DataHandler.updateFoodItem(fi, eaten: true)
            DataHandler.updateCalorieConsumption(thisWeek: self.thisWeek)
            
        default:
            break
        }
    }
    
    
    func displayDeleteSheet(_ reason: String) {
        self.present(alertController!, animated: true, completion: nil)
    }
    
    
}
