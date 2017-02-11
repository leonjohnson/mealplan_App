/*
 Show the date and back and forth buttons
 Load tomorrow when flick forward
 
 */

import UIKit
import RealmSwift
import FacebookCore
import MessageUI

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


extension UIView {
    func getSubviewByName(name:String) -> UIView? {
        
        if (object_getClassName(self) == name._bridgeToObjectiveC().utf8String) {
            return self
        }
        
        for v in (self.subviews as Array<UIView>) {
            var child = v.getSubviewByName(name: name)
            
            if (child != nil) {
                return child
            }
        }
        
        return nil
    }
}


class MealPlanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MPTableViewCellDelegate, MPViewControllerDelegate {
    
    var showExplainerScreen : Bool?
    var settingsControl : Bool? //For SettingsTab bar
    
    //@IBOutlet var workOutIcon: UIView!
    @IBOutlet var mealPlanListTable : UITableView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var editLabel: UIButton!
    @IBOutlet weak var bkgrd: UIView!
    @IBOutlet var navigatorView : UIView!
    
    @IBOutlet weak var mealPlanDate: UILabel!
    @IBOutlet weak var backDateButton: UIButton!
    @IBOutlet weak var nextDateButton: UIButton!
    var feedbackButton: UIButton = UIButton()
    
    var alertController : UIAlertController?
    var deleteSheetIndexSelected : Int = -1
    var dragger:DragToTable?
    var meals :[Meal] = [Meal]()
    var thisWeek: Week = Week()
    var nextWeek: Week = Week()
    var dateCount:Int = 0
    var lastDayVisitedBeforeLeavingPage:Int = 0
    let delegate = MailComposeDelegate()
    var rowTapped : IndexPath = IndexPath()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var stringWithName = DataHandler.getActiveUser().first_name
        if stringWithName.uppercased().characters.last == "S"{
            stringWithName = stringWithName + "' meal plan"
        } else{
            stringWithName = stringWithName + "'s meal plan"
        }
        nameLabel.attributedText? = NSAttributedString(string:stringWithName, attributes:[NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        let buttonLabel = NSAttributedString(string:"Edit", attributes:[NSFontAttributeName:Constants.EDIT_BUTTON, NSForegroundColorAttributeName:Constants.MP_WHITE])
        editLabel.setAttributedTitle(buttonLabel, for: .normal)
        
        let topLayer = CALayer()
        topLayer.backgroundColor = UIColor.white.cgColor.copy(alpha: 0.5)
        topLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.5)
        let bottomLayer = CALayer()
        bottomLayer.backgroundColor = UIColor.white.cgColor.copy(alpha: 0.5)
        bottomLayer.frame = CGRect(x: 0, y: (navigatorView.frame.height), width: self.view.frame.width, height: 0.5)
        
        navigatorView.layer.addSublayer(topLayer)
        navigatorView.layer.addSublayer(bottomLayer)
        
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        mealPlanListTable.isEditing = false
        AppEventsLogger.log("MealPlanViewController view will appear")
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
        
        
        dateCount = components.day!
        
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
                                                            self.processSheetSelection()
        })
        
        let dislikeAction : UIAlertAction = UIAlertAction(title: "Dislike this",
                                                          style: .destructive,
                                                          handler: {
                                                            (paramAction:UIAlertAction!) in
                                                            self.deleteSheetIndexSelected = 1
                                                            self.processSheetSelection()
        })
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel",
                                                         style: .cancel,
                                                         handler: {
                                                            (paramAction:UIAlertAction!) in
                                                            self.deleteSheetIndexSelected = -1
                                                            self.processSheetSelection()
                                                            //self.alertController?.dismiss(animated: true, completion: nil)
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
    
    func makeTableEditable(answer: Bool){
        mealPlanListTable.isEditing = answer
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
    
    @IBAction func toggleEditButton(){
        mealPlanListTable.isEditing = !mealPlanListTable.isEditing
        mealPlanListTable.reloadData()
        switch editLabel.attributedTitle(for: .normal)!.string {
        case "Edit":
            let buttonLabel = NSAttributedString(string:"Cancel", attributes:[NSFontAttributeName:Constants.EDIT_BUTTON, NSForegroundColorAttributeName:Constants.MP_WHITE])
            editLabel.setAttributedTitle(buttonLabel, for: .normal)
            
            // check if any rows were moved
            for meal in meals{
                for fi in meal.foodItems {
                    print("\(fi.food?.name)")
                }
                
            }
            
            
        case "Cancel":
            let buttonLabel = NSAttributedString(string:"Edit", attributes:[NSFontAttributeName:Constants.EDIT_BUTTON, NSForegroundColorAttributeName:Constants.MP_WHITE])
            editLabel.setAttributedTitle(buttonLabel, for: .normal)
        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 70
    }
    

    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (meals[section].foodItems).count
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
            cell.backgroundColor = UIColor.clear
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
            
            //Calorie label
            let label3 =  cell.viewWithTag(101) as? UILabel
            label3?.attributedText = NSAttributedString(string: Int(foodItem.getTotalCal()).description, attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_WHITE])
            if mealPlanListTable.isEditing{
                label3?.isHidden = true
            } else {
                label3?.isHidden = false
            }
            
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
        return .delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        print("moved row to : \(proposedDestinationIndexPath.row)")
        
        return proposedDestinationIndexPath
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
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //moveRow(tableView: tableView, current: sourceIndexPath, future: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("\(editingStyle) called for row \(indexPath.row)")
        
        deleteRow(tableView: tableView, indexPath: indexPath)
    }
    
    
    func deleteRow(tableView:UITableView, indexPath:IndexPath){
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        let foodItem = self.meals[indexPath.section].foodItems[indexPath.row]
        DataHandler.removeFoodItem(foodItem)
        DataHandler.updateCalorieConsumption(thisWeek: self.thisWeek)
        self.mealPlanListTable.reloadSections([indexPath.section], with: .automatic)
    }
    
    func moveRow(tableView:UITableView, current:IndexPath, future:IndexPath){
        tableView.beginUpdates()
        tableView.moveRow(at: current, to: future)
        tableView.endUpdates()
        
        //let foodItems = meals[current.section].foodItems
        //DataHandler.moveFood(meals:List(meals), from: current, to: future)
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
            print("original still stands")
        }
        
        switch editType {
        case Constants.DELETE:
            self.present(alertController!, animated: true, completion: nil)
            rowTapped = indexPath
         case Constants.EDIT:
            let fi = meals[indexPath.section].foodItems[indexPath.row]
            DataHandler.updateFoodItem(fi, eaten: true)
            DataHandler.updateCalorieConsumption(thisWeek: self.thisWeek)
            
        default:
            break
        }
    }
    
    func processSheetSelection(){

        
        if self.deleteSheetIndexSelected >= 0 {
            let foodItem = self.meals[rowTapped.section].foodItems[rowTapped.row]
            DataHandler.removeFoodItem(foodItem)
            DataHandler.updateCalorieConsumption(thisWeek: self.thisWeek)
            //DataHandler.removeFoodItemFromMeal(meals[indexPath.section], index: indexPath.row)
            //mealPlanListTable.reloadData()
            //self.mealPlanListTable.reloadSections(sections as IndexSet, with: .automatic)
            //http://stackoverflow.com/questions/14576921/uitableview-reloaddata-with-animation
            let sections = NSIndexSet(index: rowTapped.section)
            self.mealPlanListTable.reloadSections(sections as IndexSet, with: .automatic)
            rowTapped = IndexPath()
            self.deleteSheetIndexSelected = -1
        }
        
    }
    
    func displayDeleteSheet(_ reason: String) {
        self.present(alertController!, animated: true, completion: nil)
    }
    
    @IBAction func askFeedback(_ sender : UIButton){
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = delegate
            mail.setToRecipients(["feedback@mealplanapp.com"])
            mail.setSubject("Feedback from \(DataHandler.getActiveUser().first_name) 👋")
            
            present(mail, animated: true)
        } else {
            // show failure alert
            
        }
    }
    
    
}
