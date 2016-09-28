//
//  Step1ViewController.swift
//  DailyMeals
//
//  Created by Jithu on 3/10/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import UIKit
import UnderKeyboard
import RealmSwift
extension NSDate {
    var age: Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: self, toDate: NSDate(), options: []).year + 1
    }
}

class Step1ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    //var fromController = NSString()

    
    // Numer of eat times to select from
    var eatTimes = [1, 2, 3, 4, 5, 6]
    
    // Number of weeks to select from
    var numberOfweeks   = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    
    //Gender Array
    var genderValue = [Constants.male, Constants.female]
    var selcetedGender = 2;
    
    //Goals Array
    var goalsValues = ["Gain Muscle", "Lose Fat", "Add more definition"]
    var selectedGoal:NSMutableArray = NSMutableArray();
   
    //For SettingsTab bar
    var settingsControl : Bool?
    
    @IBOutlet var genderview : UIView!
    @IBOutlet var goalsView : UIView!
    @IBOutlet var eatTimePicker : UIPickerView!
    @IBOutlet var activityLevelButton : UIButton!
    @IBOutlet var weeksPickerView : UIPickerView!
    @IBOutlet var ageNameView : UIView!
    @IBOutlet var nextButton : mpButton!
    @IBOutlet var heightWeightButton : UIButton!
    @IBOutlet var weeksLabel : UILabel!
    @IBOutlet var ageText : UITextField!
    @IBOutlet var nameText : UITextField!
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var genderTable : UITableView!
    @IBOutlet var goalsTable : UITableView!
    @IBOutlet var activeTable : UITableView!
    @IBOutlet var heightWeightTable : UITableView!
    @IBOutlet var closeButton : UIButton!
    
    @IBOutlet var areYouLabel : UILabel!
    @IBOutlet var howManyTimesLabel : UILabel!
    @IBOutlet var howActiveAreYouLabel : UILabel!
    @IBOutlet var whatAreYourGoalsLabel : UILabel!
    @IBOutlet var howManyWeeksLabel : UILabel!
    @IBOutlet var whatIsYourLabel : UILabel!
    
    @IBOutlet var introText : UITextView!
        
    //KeyBoard avoding LLibrary Functionality.
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    let underKeyboardLayoutConstraint = UnderKeyboardLayoutConstraint()
    let keyboardObserver = UnderKeyboardObserver()
    
    
    //variable created for constant class
    let bio  = Biographical()
    let user = User();
    
    let pickerDBVal = DataHandler.getActiveBiographical()
    let profileDBVal = DataHandler.getActiveUser()
    
    //Variables for saving Default values on load from settings control.
    var activeGenderValue:String! = ""
    var eatTimeValue:Int?
    var weekTimeValue:Int?
   // var muscleGoal:RealmOptional<Bool>
   
    
    override func viewDidLoad() {
        print("here 4")
        super.viewDidLoad()
        
        //Set Label fonts
        areYouLabel.font = Constants.GENERAL_LABEL
        howManyTimesLabel.font = Constants.GENERAL_LABEL
        howActiveAreYouLabel.font = Constants.GENERAL_LABEL
        whatAreYourGoalsLabel.font = Constants.GENERAL_LABEL
        howManyWeeksLabel.font = Constants.GENERAL_LABEL
        whatIsYourLabel.font = Constants.GENERAL_LABEL
        
        ageText.font = Constants.STANDARD_FONT
        ageText.textColor = UIColor.blackColor()
        
        let nameAtString = NSAttributedString(string: "Name", attributes: [NSFontAttributeName: Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.BLACK_COLOR])
        
        
        let ageAtString = NSAttributedString(string: "Age", attributes: [NSFontAttributeName: Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.BLACK_COLOR])
        
        
        nameText.attributedPlaceholder = nameAtString
        ageText.attributedPlaceholder = ageAtString
        

        //For Default Values in Picker.
        prefill()
        
        //To hide close button when app. loads normaly from Profile view.
        closeButton.hidden = true
        
        //To set values on load from Settings Page Controller.
        if (settingsControl != nil) {
            
            //Close Button whn app. loads from settings view.
            closeButton.hidden = false
            
            //For Name:
            nameText.text! = profileDBVal.name
            
            //For Gender:
            activeGenderValue = profileDBVal.gender
            selcetedGender = genderValue.indexOf(activeGenderValue)!
            
            
            //For eatTime & WeekTime Values
            eatTimeValue      = pickerDBVal.numberOfDailyMeals
            weekTimeValue     = pickerDBVal.howLong
            
            setUpDefaltValues()
            
            if((pickerDBVal.looseFat.value) == true){
                selectedGoal.addObject(goalsValues[0])
            }
            if(pickerDBVal.gainMuscle.value == true){
                selectedGoal.addObject(goalsValues[1])
            }
            if(pickerDBVal.addMoreDefinition.value == true){
                selectedGoal.addObject(goalsValues[2])
            }
            
            ageText.text = profileDBVal.birthdate.age.description;
            
            bio.weightMeasurement = pickerDBVal.weightMeasurement;
            bio.heightMeasurement = pickerDBVal.heightMeasurement;
            bio.weightUnit = pickerDBVal.weightUnit;
            bio.heightUnit = pickerDBVal.heightUnit;
            
            bio.activityLevelAtWork = pickerDBVal.activityLevelAtWork
            bio.numberOfResistanceSessionsEachWeek = pickerDBVal.numberOfResistanceSessionsEachWeek
            bio.numberOfCardioSessionsEachWeek = pickerDBVal.numberOfCardioSessionsEachWeek
            
        }
        
        
        //Done button View for NumberPad KeyBoard
        let barButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: ageText, action: #selector(UIResponder.resignFirstResponder))
        //let barButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: ageText, action: "resignFirstResponder")
        barButton.tintColor = UIColor.blackColor()
        let toolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        toolbar.items = [barButton]
        ageText.inputAccessoryView = toolbar
        //For making Keyboard with specific type.
        //ageText.keyboardType = UIKeyboardType.DecimalPad
        
        
        //UnderKeyBoard Library functionality
        underKeyboardLayoutConstraint.setup(bottomLayoutConstraint, view: view,
            bottomLayoutGuide: bottomLayoutGuide)
        keyboardObserver.start()
        // Called before the keyboard is animated
        keyboardObserver.willAnimateKeyboard = { height in
            self.bottomLayoutConstraint.constant = height
        }
        // Called inside the UIView.animateWithDuration animations block
        keyboardObserver.animateKeyboard = { height in
            self.scrollView.layoutIfNeeded()
        }
        
        
        //To set Border color for GenderView.
        //genderview?.layer.borderColor = UIColor .lightGrayColor().CGColor
        //genderview?.layer.borderWidth = 1
        //To set Border color for Goals View.
        //goalsView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        //goalsView?.layer.borderWidth = 1
        //To set Border color for Acitivity Level Button.
        activeTable.layer.masksToBounds = true
        activeTable.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
        activeTable.layer.borderWidth = 1.0
        //To set Border color for ageNameView
        //ageNameView?.layer.borderColor = UIColor .lightGrayColor().CGColor
        //ageNameView?.layer.borderWidth = 1
        
        
        //Attributing WeeksLabel style fro two font
        let attrsA = [NSFontAttributeName: Constants.WEEKS_LABEL_FONT, NSForegroundColorAttributeName:Constants.MP_GREY]
        let a = NSMutableAttributedString(string:Constants.WEEK_STRING, attributes:attrsA)
        let attrsB =  [NSFontAttributeName: Constants.WEEKS_LABEL_FONT_BOLD, NSForegroundColorAttributeName: Constants.MP_GREY]
        let b = NSAttributedString(string:Constants.WEEK_RESULT_STRING, attributes:attrsB)
        
        a.appendAttributedString(b)
        //weeksLabel.attributedText = a
        
        
        //Delegate & Datasource calls for Picker views
        self.eatTimePicker.dataSource = self
        self.eatTimePicker.delegate = self
        self.weeksPickerView.dataSource = self
        self.weeksPickerView.delegate = self
        
        //Delagate calls for UITextFileds
        ageText.delegate = self
        nameText.delegate = self
        
        // Do any additional setup after loading the view.
        introText.contentInset = UIEdgeInsetsMake(-4,-3,0,0);
        goalsTable.setContentOffset(CGPoint(x: 0, y: 5), animated: false)
        
    }
    
    //For saving Default Selected index values from the picker as Values:
    func prefill(){
        eatTimeValue      = eatTimes[0]
        weekTimeValue     = numberOfweeks [0]
    }

    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func BackAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //Method for showing values on load from settings page.
    func setUpDefaltValues(){
        if(eatTimes.contains(eatTimeValue!)){
        let index  = eatTimes.indexOf(eatTimeValue!)!;
        eatTimePicker.selectRow(index, inComponent: 0, animated: true)
        }
        
        if (numberOfweeks.contains(weekTimeValue!)){
            let index1 = numberOfweeks.indexOf(weekTimeValue!)!;
            weeksPickerView.selectRow(index1, inComponent: 0, animated: true)
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //GenderTable Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == genderTable){
            return genderValue.count
        }else if (tableView == goalsTable){
            return goalsValues.count
        }else{
            return 1;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == genderTable){
        let item = genderValue[indexPath.row];
        let cell = tableView.dequeueReusableCellWithIdentifier("genderCell", forIndexPath: indexPath)
        cell.textLabel?.text = item;
        cell.textLabel?.font = Constants.STANDARD_FONT
        genderTable.contentInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        
        
        if (selcetedGender == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
        }else if (tableView == goalsTable){
            let item = goalsValues[indexPath.row];
            let cell = tableView.dequeueReusableCellWithIdentifier("goalsCell", forIndexPath: indexPath)
            cell.textLabel?.text = item;
            cell.textLabel?.font = Constants.STANDARD_FONT
            
            if(selectedGoal.containsObject(item)){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell

        }else if (tableView == activeTable){
            let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Activity levels"
            cell.textLabel?.font = Constants.STANDARD_FONT
            return cell
        }else{
            tableView.contentInset = UIEdgeInsetsMake(0, -10, 0, 0);
            let cell = tableView.dequeueReusableCellWithIdentifier("heightWeightCell", forIndexPath: indexPath)
                cell.textLabel?.text = "Height and weight"
            cell.textLabel?.font = Constants.STANDARD_FONT
                return cell
        }
    
    }
    
    
    //DeSelecting Multiple Cells
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (tableView == genderTable){
            selcetedGender = indexPath.row;
        }else{
             let item = goalsValues[indexPath.row];
            if(selectedGoal.containsObject(item)){
                selectedGoal.removeObject(item)
            }else{
                selectedGoal.addObject(item)
            }
        }
        
        tableView.reloadData();
    }
        
    //UIPickerView Delegates and DataSource Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == eatTimePicker){
            return eatTimes.count
        }else{
            return numberOfweeks.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == eatTimePicker){
            return eatTimes[row].description
        }else {
            return numberOfweeks[row].description
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (pickerView == eatTimePicker){
            
            eatTimeValue = eatTimes[row]
            //bio.numberOfDailyMeals = eatTimeValue!
        }
        else{
            
            weekTimeValue = numberOfweeks[row]
            //bio.howLong = weekTimeValue!
        }
    }
    
    
    //TextField Delegates
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //IBAction for NextButton Clicked in Step1 VC. Saving all datas into an ProfileClass.
    @IBAction func nextButtonClicked (sender : AnyObject){
        
      let age =   Double(ageText.text!)
        if(age > 0){
            
            let  years : Double = age! * 365 * 24 * 60 * 60;
            user.birthdate   = NSDate(timeIntervalSinceNow: Double(years * -1));
            
        }
        user.name  = nameText.text!
        
        let trimmed =  user.name.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet())
    
        
       
        //Alert for Name if char. length is less than 2 or empty.
        if (trimmed.characters.count < 2 || nameText.text == ""){
            // create the alert
            let alert = UIAlertController(title: "", message: "Name is not valid", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        //Alert for Name if having special chara. expect listed below.
            let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9. ].*", options: NSRegularExpressionOptions())
            if regex.firstMatchInString(trimmed, options: NSMatchingOptions(), range:NSMakeRange(0, trimmed.characters.count)) != nil {
               // print("could not handle special characters")
                
            // create the alert
            let alert = UIAlertController(title: "", message: "Name is not valid", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        
        //Alert for Age.
        if(ageText.text! < "1"){
            
            //Scroll to relevant area
            //No need to for age as the user has just pressed the button that is besides the age field
            
            // create the alert
            let alert = UIAlertController(title: "", message: "Age should not be empty or zero", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        //Alert for Gender
        if(selcetedGender == 2){
            
            //Scroll to relevant area
            //No need to for age as the user has just pressed the button that is besides the age field
            
            // create the alert
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            let alert = UIAlertController(title: "", message: "Select gender value", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }else{
            user.gender = genderValue[selcetedGender]
        }
        
        
        //Alert for Work Active
        if(bio.activityLevelAtWork == ""){
            
            //Scroll to relevant area
            scrollView.setContentOffset(CGPoint(x: 0, y: 463), animated: true)
            
            // create the alert
            let alert = UIAlertController(title: "", message: "Select work active value", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        //Alert for weight Value
        if(bio.weightMeasurement == 0.0){
            // create the alert
            let alert = UIAlertController(title: "", message: "Select Height&Weight values", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
       
        //Saving to DB Class:
        bio.looseFat.value   =  (selectedGoal.containsObject(goalsValues[0]))
        bio.gainMuscle.value =   (selectedGoal.containsObject(goalsValues[1]))
        bio.addMoreDefinition.value = (selectedGoal.containsObject(goalsValues[2]))
        
        bio.numberOfDailyMeals = eatTimeValue!
        bio.howLong = weekTimeValue!
        
        //All the datas should be updated to Profile class
        DataHandler.updateUser(user);
        DataHandler.updateStep1(bio);
        
        //if from Settings Tab bar View.
        if ((settingsControl) != nil){
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            self.performSegueWithIdentifier("step1Identifier", sender: nil)
        }

    }
    
    
    
    
    //Method for Navigating to Step1 sub classes based on Segue Identifier.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if( segue.identifier  == "ActivityLevelIdentifier" ){
            let destination = segue.destinationViewController as? ActivityLevelViewController;
            destination?.parentView = self;
        }
        else if (segue.identifier == "HeightClassIdentifier"){
            let heightDestination = segue.destinationViewController as? Height_WeightListViewController
            heightDestination?.parentView = self
        }
    }
    
    
    
}
