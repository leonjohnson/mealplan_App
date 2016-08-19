import UIKit

class Step4ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    
    //var fromController = NSString()
    
    @IBOutlet var backButton : UIButton!
    @IBOutlet var disLikeFoodListTable : UITableView!
    @IBOutlet var disLikeFoodLabel : UILabel!
    @IBOutlet var disLikeSearchBar : UISearchBar!
    @IBOutlet var step4FinishButton : mpButton!
    @IBOutlet var closeButton : UIButton!
    
    
    var localData = DataHandler.getAllFoodsExceptLikedFoods("");
    var filterdData:[Food]?
    var resultSearchController = UISearchController()
    //Deafult Value setting
    var dislikeFoodValue = NSMutableArray()
    var likedFoods = NSMutableArray()
    
    //For SettingsTab bar
    var settingsControl : Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loaded....")
        //To hide close button when app. loads normaly from Profile view.
        closeButton.hidden = true
        
        disLikeFoodListTable.delegate = self       
        filterdData = localData
        
    
        if (settingsControl != nil)
        {
            
            //Close Button whn app. loads from settings view.
            closeButton.hidden = false
    
        let arrayOfObjects = Array(DataHandler.getDisLikedFoods().foods);
        let arrayOfLikedObjects = Array(DataHandler.getLikeFoods().foods);
    
            for item in arrayOfObjects {
            dislikeFoodValue.addObject(item)
            print("added object....")
            }
            print("count in arrayOfLikedObjects: %f", arrayOfLikedObjects.count)
            dislikeFoodValue.removeObjectsInArray(arrayOfLikedObjects)
        }
        
        filterdData = localData
        disLikeFoodListTable.delegate = self
        
        //For Multiselecting the cells in Table
        self.disLikeFoodListTable.allowsMultipleSelection = true
    
    
        let attrsA = [NSFontAttributeName: Constants.FOOD_LABEL_FONT, NSForegroundColorAttributeName:Constants.FOOD_LABEL_COLOR]
        let a = NSMutableAttributedString(string:Constants.THE_FOODS_STRING, attributes:attrsA)
        let attrsB =  [NSFontAttributeName: Constants.FOOD_LABEL_FONT_BOLD, NSForegroundColorAttributeName: Constants.FOOD_LABEL_COLOR]
        let b = NSAttributedString(string:Constants.DISLIKE_STRING, attributes:attrsB)
        
        a.appendAttributedString(b)
        //disLikeFoodLabel.attributedText = a
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func closeAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
    
    
    //MealPlanListTable Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        //if(self.resultSearchController.active) {
            //return filterdData!.count
       // }
        return filterdData!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("step4CellIdentifier", forIndexPath: indexPath) as! Step4TableViewCell
        cell.textLabel?.text = filterdData![indexPath.row].name
        cell.textLabel?.font = Constants.STANDARD_FONT
        
        if(dislikeFoodValue.containsObject(filterdData![indexPath.row])){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    //Selecting Multiple Cells
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.textLabel?.font = Constants.STANDARD_FONT
        
        if( dislikeFoodValue.containsObject(filterdData![indexPath.row])){
            dislikeFoodValue.removeObject(filterdData![indexPath.row])
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }else{
            dislikeFoodValue.addObject(filterdData![indexPath.row])
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        disLikeSearchBar.resignFirstResponder()
    }
    
    //DeSelecting Multiple Cells
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        disLikeSearchBar.resignFirstResponder()
    }
    
    
    //SearchBar Delegates
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText == ""){
            filterdData = localData
            disLikeSearchBar.resignFirstResponder()
            
         }else{
            filterdData = localData.filter({
                
                if($0.name.lowercaseString.containsString(searchText.lowercaseString)){
                    return true
                }
                return false
            });
        }
        disLikeFoodListTable.reloadData()
    }
    
    
    //IBAction for NextButton Clicked in Step4 VC. Saving all datas into an ProfileClass.
    @IBAction func step4FinishClicked (sender : AnyObject){
      
        
        DataHandler.updateDisLikeFoods(dislikeFoodValue)
       
        //if from Settings Tab bar View.
        if ((settingsControl) != nil){
            self.navigationController?.popViewControllerAnimated(true)
        }else{

        self.performSegueWithIdentifier("step4Identifier", sender: nil)
        }


    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "step4Identifier"{
            let vc = segue.destinationViewController as! CaloriesViewController
            vc.fromController = "step4Identifier"
        }
    }
    
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func BackAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
