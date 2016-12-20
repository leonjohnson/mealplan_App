import UIKit

class Step4ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    
    //var fromController = NSString()
    
    @IBOutlet var backButton : UIButton!
    @IBOutlet var disLikeFoodListTable : UITableView!
    @IBOutlet var disLikeFoodLabel : UILabel!
    @IBOutlet var disLikeSearchBar : UISearchBar!
    @IBOutlet var step4FinishButton : MPButton!
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
        
        //To hide close button when app. loads normaly from Profile view.
        closeButton.isHidden = true
        
        disLikeFoodListTable.delegate = self       
        filterdData = localData
        
    
        if (settingsControl != nil)
        {
            
            //Close Button whn app. loads from settings view.
            closeButton.isHidden = false
    
        let arrayOfObjects = Array(DataHandler.getDisLikedFoods().foods);
        let arrayOfLikedObjects = Array(DataHandler.getLikeFoods().foods);
    
            for item in arrayOfObjects {
            dislikeFoodValue.add(item)
            print("added object....")
            }
            print("count in arrayOfLikedObjects: %f", arrayOfLikedObjects.count)
            dislikeFoodValue.removeObjects(in: arrayOfLikedObjects)
        }
        
        filterdData = localData
        disLikeFoodListTable.delegate = self
        
        //For Multiselecting the cells in Table
        self.disLikeFoodListTable.allowsMultipleSelection = true
    
    
        let attrsA = [NSFontAttributeName: Constants.FOOD_LABEL_FONT, NSForegroundColorAttributeName:Constants.FOOD_LABEL_COLOR]
        let a = NSMutableAttributedString(string:Constants.THE_FOODS_STRING, attributes:attrsA)
        let attrsB =  [NSFontAttributeName: Constants.FOOD_LABEL_FONT_BOLD, NSForegroundColorAttributeName: Constants.FOOD_LABEL_COLOR]
        let b = NSAttributedString(string:Constants.DISLIKE_STRING, attributes:attrsB)
        
        a.append(b)
        //disLikeFoodLabel.attributedText = a
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func closeAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        //if(self.resultSearchController.active) {
            //return filterdData!.count
       // }
        return filterdData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "step4CellIdentifier", for: indexPath) as! Step4TableViewCell
        cell.textLabel?.text = filterdData![indexPath.row].name
        cell.textLabel?.font = Constants.STANDARD_FONT
        
        if(dislikeFoodValue.contains(filterdData![indexPath.row])){
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
        cell!.textLabel?.font = Constants.STANDARD_FONT
        
        if( dislikeFoodValue.contains(filterdData![indexPath.row])){
            dislikeFoodValue.remove(filterdData![indexPath.row])
            cell!.accessoryType = UITableViewCellAccessoryType.none
        }else{
            dislikeFoodValue.add(filterdData![indexPath.row])
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        disLikeSearchBar.resignFirstResponder()
    }
    
    //DeSelecting Multiple Cells
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        disLikeSearchBar.resignFirstResponder()
    }
    
    
    //SearchBar Delegates
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText == ""){
            filterdData = localData
            disLikeSearchBar.resignFirstResponder()
            
         }else{
            filterdData = localData.filter({
                
                if($0.name.lowercased().contains(searchText.lowercased())){
                    return true
                }
                return false
            });
        }
        disLikeFoodListTable.reloadData()
    }
    
    
    //IBAction for NextButton Clicked in Step4 VC. Saving all datas into an ProfileClass.
    @IBAction func step4FinishClicked (_ sender : AnyObject){
      
        
        DataHandler.updateDisLikeFoods(dislikeFoodValue)
       
        //if from Settings Tab bar View.
        if ((settingsControl) != nil){
            _ = self.navigationController?.popViewController(animated: true)
        }else{

        self.performSegue(withIdentifier: "explanation", sender: nil)
        }


    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let vc = segue.destination as! ExplanationViewController
    }
    
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func BackAction(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
