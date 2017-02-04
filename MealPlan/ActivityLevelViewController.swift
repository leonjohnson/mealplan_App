//
//  ActivityLevelViewController.swift
//  DailyMeals
//
//  Created by Jithu on 3/16/16.
//  Copyright © 2016 Meals. All rights reserved.
//
//TO DO COMMENDTS (Add proper comments for all method)
import UIKit


class ActivityLevelViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var activeview : UIView!
    
    @IBOutlet var traningPicker : UIPickerView!
    @IBOutlet var cardioPicker : UIPickerView!
    
    @IBOutlet var backButton : UIButton!
    @IBOutlet var sedentaryButton : UIButton!
    @IBOutlet var lightlyButton : UIButton!
    @IBOutlet var moderatelyButton : UIButton!
    @IBOutlet var veryactiveButton : UIButton!
    @IBOutlet var doneButton : UIButton!
    
    @IBOutlet var sedentaryImage : UIImageView!
    @IBOutlet var lightlyImage : UIImageView!
    @IBOutlet var moderatelyImage : UIImageView!
    @IBOutlet var veryactiveImage : UIImageView!
    
    @IBOutlet var howActiveLabel : UILabel!
    @IBOutlet var weightsLabel : UILabel!
    @IBOutlet var cardioLabel : UILabel!
    
    @IBOutlet var scrollView : UIScrollView!
    
    var parentView:Step1ViewController?
    var settingsView:settings?
    
    //PickerValues
    var traningpickerData = [0, 1, 2, 3, 4, 5, 6, 7]
    var cardioPickerData =  [0, 1, 2, 3, 4, 5, 6, 7]
    
    //Active Work Values
    var activeWorkEgValues = ["e.g. Desk job, Driver", "e.g. Retail assistant, Teacher", "e.g. Waiter, Postman", "e.g. Manual laborer, Dancer"]
    var selectedWorkValue = 4
    
    
    var workActiveValue:String! = ""
    var traningSessionsValue:Int?
    var cardioSessionValue:Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        howActiveLabel.font = Constants.GENERAL_LABEL
        weightsLabel.font = Constants.GENERAL_LABEL
        cardioLabel.font = Constants.GENERAL_LABEL
        
        //To set Border color for activeview
        //activeview?.layer.borderColor = UIColor .lightGrayColor().CGColor
        //activeview?.layer.borderWidth = 1
        
        //Delegate & Datasource calls for Picker views
        self.traningPicker.dataSource = self
        self.traningPicker.delegate = self
        self.cardioPicker.dataSource = self
        self.cardioPicker.delegate = self
        
        
        // Do any additional setup after loading the view.
        //Loading selected values from DB:
        prefill()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
    }
    
    func prefill(){
        traningSessionsValue    = parentView?.bio.numberOfResistanceSessionsEachWeek
        cardioSessionValue      = parentView?.bio.numberOfCardioSessionsEachWeek
        
        setUpDefaltView();
        
        if(parentView?.bio.activityLevelAtWork != nil && Constants.activityLevelsAtWork.contains((parentView?.bio.activityLevelAtWork)!)){
            selectedWorkValue = Constants.activityLevelsAtWork.index(of: (parentView?.bio.activityLevelAtWork)!)!;
        }
    }
    
    //For loading selected values on picker:
    func setUpDefaltView(){
        traningPicker.selectRow(traningpickerData.index(of: traningSessionsValue!)!, inComponent: 0, animated: true)
        cardioPicker.selectRow(cardioPickerData.index(of: cardioSessionValue!)!, inComponent: 0, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //WorkActive Table Delagates.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.activityLevelsAtWork.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = Constants.activityLevelsAtWork[indexPath.row];
        let item1 = activeWorkEgValues[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.font = Constants.STANDARD_FONT
        cell.textLabel?.text = item;
        cell.detailTextLabel?.text = item1
        if (selectedWorkValue == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWorkValue = indexPath.row;
        tableView.reloadData();
    }
 
    
    //UIPickerView Delegates and DataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == traningPicker){
            return traningpickerData.count
        }else{
            return cardioPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == traningPicker){
            return traningpickerData[row].description
        }else {
            return cardioPickerData [row].description
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (pickerView == traningPicker){
            
            traningSessionsValue  = traningpickerData[row]
            
        }else{
            cardioSessionValue = cardioPickerData [row]
        }
    }
    
    //Method for Saving Values to Bio Class.
    @IBAction func doneButtonClicked (_ sender : AnyObject){
        
        //Adding values to constant Class
        parentView?.bio.numberOfResistanceSessionsEachWeek = traningSessionsValue!
        parentView?.bio.numberOfCardioSessionsEachWeek = cardioSessionValue!
        parentView?.bio.hoursOfActivity = Double(traningSessionsValue! + cardioSessionValue!)
        
        //Alert for Work Active
        if(selectedWorkValue == 4){
            // create the alert
            let alert = UIAlertController(title: "", message: "Select work active value", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }else{
            
            //Adding values to constant Class
            parentView?.bio.activityLevelAtWork = Constants.activityLevelsAtWork[selectedWorkValue]

        }
        
        parentView?.scrollToNextQuestion = true
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    //Method for Navigating back to previous ViewController.
    @IBAction func BackAction(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}
