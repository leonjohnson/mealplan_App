import UIKit

class MealPlanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //For SettingsTab bar
    var settingsControl : Bool?
    
    @IBOutlet var workOutIcon: UIView!
    @IBOutlet var mealPlanListTable : UITableView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var bkgrd: UIView!
    
    var dragger:DragToTable?
    var objects :[Meal] = [Meal]()
    
    
    
    override func viewDidAppear(animated: Bool)
    {

        let data =  DataHandler.readMealData(0)
        //print(data)
        objects = Array(data.meals)
        mealPlanListTable.reloadData();
        
        // Setup the notifications
        //handleNotifivarion()
        //enableLocalNotification();
        
        
        DataStructure.createMealPlans()
    }
    
    
    

    
    
    func handleNotification()
    {
        let notifications =  UIApplication.sharedApplication().scheduledLocalNotifications
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
    func enableLocalNotification()
    {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge , .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    
    func fireNotification(){
        let localNotification = UILocalNotification();
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 60*60*24*7 );
        localNotification.alertTitle = "Share How "
       
        localNotification.alertBody = "Wow its a week again ";
        localNotification.timeZone = NSTimeZone.defaultTimeZone();
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification);
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        
        // ENABLE TO MOVE TO START PAGE
        Config.setBoolValue(Config.HAS_PROFILE,status: true)
        
        super.viewDidLoad()
        mealPlanListTable.delegate = self
        
        self.workOutIcon.hidden = true

        
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        nameLabel.text = DataHandler.getActiveUser().name
    }
    
    
    

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 70
    }
    
    //MealPlanListTable Delegate Methods
    
    func insertNewObject(sender: AnyObject) {
        
        // Here goes the add button
        
    }
    
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return objects.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (objects[section].foodItems).count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let foodItem = objects[indexPath.section].foodItems[indexPath.row]
        
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
            cell.backgroundColor = UIColor.clearColor();
            let label2 =  cell.viewWithTag(103) as? UILabel
            let ending = foodItem.food!.servingSize!.name
            let quantity = ServingSize.getQuantity((foodItem.food?.servingSize)!)
            label2?.attributedText = NSAttributedString(string: Int(foodItem.numberServing * quantity).description + ending , attributes:[NSFontAttributeName:Constants.MEAL_PLAN_SERVINGSIZE_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE]);
            
            let label3 =  cell.viewWithTag(101) as? UILabel
            label3?.attributedText = NSAttributedString(string: Int(foodItem.getTotalCal()).description, attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_WHITE])
            
        }
        
        //cell seprator line programztically:
        let sep = UIView(frame:CGRectMake(0, 1, cell.frame.size.width, 0.5) )
        sep.backgroundColor = UIColor.whiteColor()
        cell.addSubview(sep)
 
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let fitem = objects[indexPath.section].foodItems[indexPath.row];
            DataHandler.removeFoodItemFromMeal(objects[indexPath.section], index: indexPath.row)
            DataHandler.removeFoodItem(fitem);
            
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData();
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vheadView = UIView()
        
        vheadView.backgroundColor = UIColor.clearColor()
        
        let  headerCell = UILabel()
        headerCell.frame=CGRectMake(10, 10, tableView.frame.width-30, 20)
        vheadView.addSubview(headerCell)
        headerCell.attributedText = NSAttributedString(string: objects[section].name, attributes: [NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        
        
        //create label inside header view
        let calorieCountLabel = UILabel()
        
        calorieCountLabel.frame = CGRectMake(10, 10, tableView.frame.width-30, 20)
        calorieCountLabel.textAlignment = NSTextAlignment.Right
        calorieCountLabel.textColor = UIColor.whiteColor()
        calorieCountLabel.font = UIFont.systemFontOfSize(17)
        calorieCountLabel.attributedText = NSAttributedString(string: Int(DataStructure.calculateTotalCalories([objects[section]])).description + " kcal", attributes: [NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])

        
        vheadView.addSubview(calorieCountLabel)
        
        //create button inside header view
        let addItemButton = UIButton()
        addItemButton.frame = CGRectMake(10, 25, self.view.frame.size.width - 100, 35)
        //addItemButton.setTitle("Add item + ", forState: UIControlState.Normal)
        addItemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        addItemButton.setAttributedTitle(NSAttributedString(string:"Add item +", attributes:[NSFontAttributeName:Constants.MEAL_PLAN_SUBTITLE, NSForegroundColorAttributeName:Constants.MP_WHITE]), forState: UIControlState.Normal)
        
        
        addItemButton.titleLabel?.textColor = UIColor.whiteColor()
        addItemButton.titleLabel?.textAlignment = NSTextAlignment.Left
        vheadView.addSubview(addItemButton)
        addItemButton.addTarget(self, action: #selector(MealPlanViewController.findFoodSearchAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //addItemButton.addTarget(self, action: "findFoodSearchAction:", forControlEvents: UIControlEvents.TouchUpInside)
        addItemButton.tag = section
        
        //let sep = UIView(frame:CGRectMake(0, 55, self.view.frame.size.width, 1) )
        //sep.backgroundColor = UIColor.whiteColor()
        //vheadView.addSubview(sep)
        
        return vheadView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    
    //IBAction for AddItemButton on Header view
    
    func findFoodSearchAction(sender: UIButton){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let scene = storyboard.instantiateViewControllerWithIdentifier("foodSearchList") as! FoodSearchViewController
        scene.meal = objects[sender.tag]
        
        if((self.navigationController) != nil){
            self.navigationController?.pushViewController(scene, animated: true);
        }else{
            self.presentViewController(scene, animated: true, completion: nil)
        }
        
    }
    // MARK: - Segues
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if let indexPath = self.mealPlanListTable.indexPathForSelectedRow {
            
            let object =   objects[indexPath.section].foodItems[indexPath.row]
            if(object.food!.pk == 0){
                self.mealPlanListTable.deselectRowAtIndexPath(indexPath, animated: true)
                return false
            }
        }
        return true
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.mealPlanListTable.indexPathForSelectedRow {
                self.mealPlanListTable.deselectRowAtIndexPath(indexPath, animated: true)
                let object =   objects[indexPath.section].foodItems[indexPath.row]
                
                
                let controller = segue.destinationViewController as! DetailViewController
                controller.meal = objects[indexPath.section]
                controller.detailItem = object
                //controller.hideAddButton = true
                //   controller.masterView = self
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                // self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }
    
    
    
    
}
