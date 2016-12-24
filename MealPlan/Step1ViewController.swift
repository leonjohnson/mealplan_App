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

extension Date {
    var age: Int {
        return (Calendar.current as NSCalendar).components(.year, from: self, to: Date(), options: []).year! + 1
    }
}

class Step1ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    //var fromController = NSString()

    
    // Numer of eat times to select from
    var eatTimes = [2, 3, 4, 5, 6]
    
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
    
    //Scroll to relevant place
    var scrollToNextQuestion : Bool?
    
    @IBOutlet var genderview : UIView!
    @IBOutlet var goalsView : UIView!
    @IBOutlet var eatTimePicker : UIPickerView!
    @IBOutlet var activityLevelButton : UIButton!
    @IBOutlet var weeksPickerView : UIPickerView!
    @IBOutlet var ageNameView : UIView!
    @IBOutlet var nextButton : MPButton!
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
        super.viewDidLoad()
        
        //Set Label fonts
        areYouLabel.font = Constants.GENERAL_LABEL
        howManyTimesLabel.font = Constants.GENERAL_LABEL
        howActiveAreYouLabel.font = Constants.GENERAL_LABEL
        whatAreYourGoalsLabel.font = Constants.GENERAL_LABEL
        howManyWeeksLabel.font = Constants.GENERAL_LABEL
        whatIsYourLabel.font = Constants.GENERAL_LABEL
        
        ageText.font = Constants.STANDARD_FONT
        ageText.textColor = UIColor.black
        
        let nameAtString = NSAttributedString(string: "Name", attributes: [NSFontAttributeName: Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.BLACK_COLOR])
        
        
        let ageAtString = NSAttributedString(string: "Age", attributes: [NSFontAttributeName: Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.BLACK_COLOR])
        
        nameText.autocorrectionType = .no
        nameText.attributedPlaceholder = nameAtString
        ageText.attributedPlaceholder = ageAtString
        

        //For Default Values in Picker.
        prefill()
        
        //To hide close button when app. loads normaly from Profile view.
        closeButton.isHidden = true
        
        //To set values on load from Settings Page Controller.
        if (settingsControl != nil) {
            
            //Close Button whn app. loads from settings view.
            closeButton.isHidden = false
            
            //For Name:
            nameText.text! = profileDBVal.name
            
            //For Gender:
            activeGenderValue = profileDBVal.gender
            selcetedGender = genderValue.index(of: activeGenderValue)!
            
            
            //For eatTime & WeekTime Values
            eatTimeValue      = pickerDBVal.numberOfDailyMeals
            weekTimeValue     = pickerDBVal.howLong
            
            setUpDefaltValues()
            
            if((pickerDBVal.looseFat.value) == true){
                selectedGoal.add(goalsValues[0])
            }
            if(pickerDBVal.gainMuscle.value == true){
                selectedGoal.add(goalsValues[1])
            }
            if(pickerDBVal.addMoreDefinition.value == true){
                selectedGoal.add(goalsValues[2])
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
        let barButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: ageText, action: #selector(UIResponder.resignFirstResponder))
        //let barButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: ageText, action: "resignFirstResponder")
        barButton.tintColor = UIColor.black
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
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
        activeTable.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        activeTable.layer.borderWidth = 1.0
        //To set Border color for ageNameView
        //ageNameView?.layer.borderColor = UIColor .lightGrayColor().CGColor
        //ageNameView?.layer.borderWidth = 1
        
        
        //Attributing WeeksLabel style fro two font
        let attrsA = [NSFontAttributeName: Constants.WEEKS_LABEL_FONT, NSForegroundColorAttributeName:Constants.MP_GREY]
        let a = NSMutableAttributedString(string:Constants.WEEK_STRING, attributes:attrsA)
        let attrsB =  [NSFontAttributeName: Constants.WEEKS_LABEL_FONT_BOLD, NSForegroundColorAttributeName: Constants.MP_GREY]
        let b = NSAttributedString(string:Constants.WEEK_RESULT_STRING, attributes:attrsB)
        
        a.append(b)
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
    
    override func viewWillAppear(_ animated: Bool) {
        if scrollToNextQuestion == true{
            //Scroll to relevant area
            scrollView.setContentOffset(CGPoint(x: 0, y: 600), animated: true)
            scrollToNextQuestion = false
        }
    }
    
    //For saving Default Selected index values from the picker as Values:
    func prefill(){
        eatTimeValue      = eatTimes[2]
        weekTimeValue     = numberOfweeks [4]
    }

    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func BackAction(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Method for showing values on load from settings page.
    func setUpDefaltValues(){
        if(eatTimes.contains(eatTimeValue!)){
        let index  = eatTimes.index(of: eatTimeValue!)!;
        eatTimePicker.selectRow(index, inComponent: 0, animated: true)
        }
        
        if (numberOfweeks.contains(weekTimeValue!)){
            let index1 = numberOfweeks.index(of: weekTimeValue!)!;
            weeksPickerView.selectRow(index1, inComponent: 0, animated: true)
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //GenderTable Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == genderTable){
            return genderValue.count
        }else if (tableView == goalsTable){
            return goalsValues.count
        }else{
            return 1;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == genderTable){
        let item = genderValue[indexPath.row];
        let cell = tableView.dequeueReusableCell(withIdentifier: "genderCell", for: indexPath)
        cell.textLabel?.text = item;
        cell.textLabel?.font = Constants.STANDARD_FONT
        genderTable.contentInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        
        
        if (selcetedGender == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
        }else if (tableView == goalsTable){
            let item = goalsValues[indexPath.row];
            let cell = tableView.dequeueReusableCell(withIdentifier: "goalsCell", for: indexPath)
            cell.textLabel?.text = item;
            cell.textLabel?.font = Constants.STANDARD_FONT
            
            if(selectedGoal.contains(item)){
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            return cell

        }else if (tableView == activeTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
            cell.textLabel?.text = "Activity levels"
            cell.textLabel?.font = Constants.STANDARD_FONT
            return cell
        }else{
            tableView.contentInset = UIEdgeInsetsMake(0, -10, 0, 0);
            let cell = tableView.dequeueReusableCell(withIdentifier: "heightWeightCell", for: indexPath)
                cell.textLabel?.text = "Height and weight"
            cell.textLabel?.font = Constants.STANDARD_FONT
                return cell
        }
    
    }
    
    
    //DeSelecting Multiple Cells
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView == genderTable){
            selcetedGender = indexPath.row;
        }else{
             let item = goalsValues[indexPath.row];
            if(selectedGoal.contains(item)){
                selectedGoal.remove(item)
            }else{
                selectedGoal.add(item)
            }
        }
        
        tableView.reloadData();
    }
        
    //UIPickerView Delegates and DataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == eatTimePicker){
            return eatTimes.count
        }else{
            return numberOfweeks.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == eatTimePicker){
            return eatTimes[row].description
        }else {
            return numberOfweeks[row].description
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //IBAction for NextButton Clicked in Step1 VC. Saving all datas into an ProfileClass.
    @IBAction func nextButtonClicked (_ sender : AnyObject){
        
      let age =   Double(ageText.text!)
        if(age > 0){
            
            let  years : Double = age! * 365 * 24 * 60 * 60;
            user.birthdate   = Date(timeIntervalSinceNow: Double(years * -1));
            
        }
        user.name  = nameText.text!
        
        let trimmed =  user.name.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines)
    
        
       
        //Alert for Name if char. length is less than 2 or empty.
        if (trimmed.characters.count < 2 || nameText.text == ""){
            // create the alert
            let alert = UIAlertController(title: "", message: "Name is not valid", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        //Alert for Name if having special chara. expect listed below.
            let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9. ].*", options: NSRegularExpression.Options())
            if regex.firstMatch(in: trimmed, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, trimmed.characters.count)) != nil {
               // print("could not handle special characters")
                
            // create the alert
            let alert = UIAlertController(title: "", message: "Name is not valid", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        //Alert for Age.
        if(ageText.text! < "1"){
            
            //Scroll to relevant area
            //No need to for age as the user has just pressed the button that is besides the age field
            
            // create the alert
            let alert = UIAlertController(title: "", message: "Please enter your age", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //Alert for Gender
        if(selcetedGender == 2){
            
            //Scroll to relevant area
            //No need to for age as the user has just pressed the button that is besides the age field
            
            // create the alert
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            let alert = UIAlertController(title: "", message: "Select a value for your gender", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }else{
            user.gender = genderValue[selcetedGender]
        }
        
        
        //Alert for Work Active
        if(bio.activityLevelAtWork == nil){
            
            //Scroll to relevant area
            scrollView.setContentOffset(CGPoint(x: 0, y: 463), animated: true)
            
            // create the alert
            let alert = UIAlertController(title: "", message: "Please select values for 'Activity levels'", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //Alert for weight Value
        if(bio.weightMeasurement == 0.0){
            // create the alert
            let alert = UIAlertController(title: "", message: "Please select values for your height and weight", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        
       
        //Saving to DB Class:
        bio.looseFat.value   =  (selectedGoal.contains(goalsValues[0]))
        bio.gainMuscle.value =   (selectedGoal.contains(goalsValues[1]))
        bio.addMoreDefinition.value = (selectedGoal.contains(goalsValues[2]))
        
        bio.numberOfDailyMeals = eatTimeValue!
        bio.howLong = weekTimeValue!
        
        //All the datas should be updated to Profile class
        DataHandler.updateUser(user);
        DataHandler.updateStep1(bio);
        
        //if from Settings Tab bar View.
        if ((settingsControl) != nil){
            _ = self.navigationController?.popViewController(animated: true)
        }else{
            self.performSegue(withIdentifier: "step1Identifier", sender: nil)
        }

    }
    
    
    
    
    //Method for Navigating to Step1 sub classes based on Segue Identifier.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if( segue.identifier  == "ActivityLevelIdentifier" ){
            let destination = segue.destination as? ActivityLevelViewController;
            destination?.parentView = self;
        }
        else if (segue.identifier == "HeightClassIdentifier"){
            let heightDestination = segue.destination as? Height_WeightListViewController
            heightDestination?.parentView = self
            ageText.resignFirstResponder()
            nameText.resignFirstResponder()
        }
    }
    
    
    
}
