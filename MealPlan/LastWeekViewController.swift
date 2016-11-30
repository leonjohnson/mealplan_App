import UIKit

class LastWeekViewController: UIViewController,AKPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //For SettingsTab bar
    var settingsControl : Bool?
    
    
    //Last week MealPlan Level :
    var hungryLevelArray = ["Really hungry", "A little hungry", "About right", "Full"]
    var selcetedHungryLevel = 4;
    
    //Last week Bolated Level:
    var dietEaseArray = [Constants.dietEase.easy,Constants.dietEase.ok,Constants.dietEase.hard]
    var selectedDietEaseValue = -1;
    
    //Last week Help Level:
    var helpLevelValue = [true,false]
    var selectedUsefulnessValue = -1;

    
    @IBOutlet var closeButton : UIButton!
    @IBOutlet var hungryView : UIView!
    @IBOutlet var BloatedView : UIView!
    @IBOutlet var weekFeelView : UIView!
    @IBOutlet var WeekPlanView : UIView!
       
    @IBOutlet var weightSegment: UISegmentedControl!
    @IBOutlet var weightPickerValue : AKPickerView!
    @IBOutlet var weightValue : UILabel!
    
    @IBOutlet var hungryLevelTable : UITableView!
    @IBOutlet var dietEaseTable : UITableView!
    @IBOutlet var helpLevelTable : UITableView!
    
    var weightVal:Double?
    var weightValActual:Double?
    
    var parentView:Step1ViewController?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        //For adding Border color & Width
        hungryView?.layer.borderColor = UIColor.lightGray.cgColor
        hungryView?.layer.borderWidth = 1
        
        //For adding Border color & Width
        BloatedView?.layer.borderColor = UIColor.lightGray.cgColor
        BloatedView?.layer.borderWidth = 1
        
        //For adding Border color & Width
        weekFeelView?.layer.borderColor = UIColor.lightGray.cgColor
        weekFeelView?.layer.borderWidth = 1
        
        //For adding Border color & Width
        WeekPlanView?.layer.borderColor = UIColor.lightGray.cgColor
        WeekPlanView?.layer.borderWidth = 1
        */
        


        
        weightPickerValue.delegate = self;
    }
    
   
    
    //Table Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == hungryLevelTable){
            return hungryLevelArray.count
        }else if (tableView == dietEaseTable){
            return dietEaseArray.count
        }else{
            return helpLevelValue.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == hungryLevelTable){
          
            let item = hungryLevelArray[indexPath.row];
            let cell = tableView.dequeueReusableCell(withIdentifier: "hungryCell", for: indexPath)
            cell.textLabel?.text = item;
            
            
            if (selcetedHungryLevel == indexPath.row){
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            return cell
        }else if (tableView == dietEaseTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "bolatedCell", for: indexPath)
            cell.textLabel?.text = dietEaseArray[indexPath.row].rawValue
            
            if (selectedDietEaseValue == indexPath.row){
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            return cell

        }else{
            let item = helpLevelValue[indexPath.row];
            let cell = tableView.dequeueReusableCell(withIdentifier: "helpCell", for: indexPath)
            if item
            {
            cell.textLabel?.text = Constants.BOOL_YES
            }
            else
            {
            cell.textLabel?.text = Constants.BOOL_NO
            }
            
            
            if (selectedUsefulnessValue == indexPath.row){
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView == hungryLevelTable){
           
            selcetedHungryLevel = indexPath.row;
            
        }else if (tableView == dietEaseTable){
            
            selectedDietEaseValue = indexPath.row;
            
            }else{
            
            selectedUsefulnessValue = indexPath.row;
            
        }
        
        tableView.reloadData();
    }
    
    
    
    @IBAction func closeClicked (_ sender : AnyObject){
       //From Settings View:
        if ((settingsControl) != nil){
            self.navigationController?.popViewController(animated: true)
        }
        self.dismiss(animated: true) { () -> Void in
        }
    }
    
    
    @IBAction func doneClicked (_ sender : AnyObject){
        let feedBack = FeedBack();
        
        if (selcetedHungryLevel == 4){
            let alert = UIAlertController(title: "", message: "Please select hungerlevels", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }else{
            feedBack.hungerLevels = hungryLevelArray[selcetedHungryLevel];
        }
        
        if (selectedDietEaseValue < 0){
            let alert = UIAlertController(title: "", message: "Please let us know if you found the meal plan easy, OK, or hard", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }else{
            feedBack.easeOfFollowingDiet = dietEaseArray[selectedDietEaseValue];
        }
                
        if (selectedUsefulnessValue < 0 ){
            let alert = UIAlertController(title: "", message: "Please state whether the meal plan was useful", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }else{
            feedBack.didItHelped = helpLevelValue[selectedUsefulnessValue];
        }
        
        
        
        feedBack.weekWeightMeasurement  = weightVal!
        feedBack.WeekWeightUnit   =  (weightSegment.selectedSegmentIndex == 0 ? "kg" : "lbs");
        
        
        // MARK: TODO save it to the last week meel
        self.dismiss(animated: true) { () -> Void in
            
        }
        
        //From Settings View:
        if ((settingsControl) != nil){
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //Segment Control Click functionalities
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        updateWeightMode ()
    }
    
    
    //Method for changeing Kg To Lbs on change of Segment Control
    func updateWeightMode (){
        if(weightSegment.selectedSegmentIndex == 0){
            
            weightPickerValue.newEndPoint = Constants.MAX_KWEIGHT
            
            //Converting  Pound to Kg with selected value from the picker on change of Segment Control:
            let initialValue =  round((Double(weightPickerValue.getSelectedItem()) * Constants.POUND_TO_KG_CONSTANT)).description;
            let changeValue =   NSString(string:initialValue).integerValue
            weightPickerValue.selectItem(changeValue);
            
        }else{
            
            //Calculation of Selected Kg Value to Pounds on change of Segment Control:
        weightPickerValue.newEndPoint = Int(round((Double(Constants.MAX_KWEIGHT)*Constants.KG_TO_POUND_CONSTANT)))
            
            //Converting Kg to Pound with selected value from the picker on change of Segment Control:
            let initialValue =  round((Double(weightPickerValue.getSelectedItem()) * Constants.KG_TO_POUND_CONSTANT)).description;
            let changeValue =   NSString(string:initialValue).integerValue
            weightPickerValue.selectItem(changeValue);
        }
        weightPickerValue.reloadData();
    }
    

    
    //PickerView Delegate
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int){
        var label = weightValue;
        var lastdigit = ""
            setWeight(item)
            label = weightValue;
            if(weightSegment.selectedSegmentIndex == 0){
                lastdigit = "kg"
            }else{
                lastdigit = "pd"
            }
            //label = weightValue;
        label?.text = (pickerView.getValue1(item)).description + pickerView.seperator + (pickerView.getValue2(item)).description + pickerView.endIcon + lastdigit
        
    }
    
 
    //Method to Convert KG to Pounds and to save value to a variable
    func setWeight(_ index:Int){
        
        //IN KG
        weightVal = Double(weightPickerValue.getValue1(index))
        
        if(weightSegment.selectedSegmentIndex != 0){
            //IN POUNDS => KG
            weightVal = weightVal! * Constants.KG_TO_POUND_CONSTANT
        }

    }
    


    
}
