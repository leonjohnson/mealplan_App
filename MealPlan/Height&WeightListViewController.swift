//
//  Height&WeightListViewController.swift
//  DailyMeals
//
//  Created by Jithu on 3/16/16.
//  Copyright © 2016 Meals. All rights reserved.
//
//TO DO COMMENDTS (Add proper comments for all method)
import UIKit

class Height_WeightListViewController: UIViewController,AKPickerViewDelegate {
    
        
    @IBOutlet var backButton : UIButton!
    @IBOutlet var weightValue : UILabel!
    @IBOutlet var heightValue : UILabel!
    // @IBOutlet var weistVale : UILabel!
    @IBOutlet var doneButton : UIButton!
    
    @IBOutlet var weightSegment: UISegmentedControl!
    @IBOutlet var heightSegment: UISegmentedControl!
    // @IBOutlet var waistSegment: UISegmentedControl!
    
    @IBOutlet var weightPickerValue : AKPickerView!
    @IBOutlet var heightPickerValue : AKPickerView!
    // @IBOutlet var wesitPickerValue :  AKPickerView!
    
    @IBOutlet var scrollView : UIScrollView!
    
    @IBOutlet var weightLabel : UILabel!
    @IBOutlet var heightLabel : UILabel!
    
    var parentView:Step1ViewController?
    
    //Default Values for Pickers
    var weightVal:Double?
    var heightVal:Double?
    
    var weightValActual:Double?
    var heightValActual:Double?
    //var waistVal:Double?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        weightPickerValue.delegate = self;
        heightPickerValue.delegate = self;
        //wesitPickerValue.delegate = self;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height)
        scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        
        //Assiginig values to variable
        if (parentView?.bio.weightMeasurement != 0.0){
            
            weightValActual       = parentView?.bio.weightMeasurement
            heightValActual = parentView?.bio.heightMeasurement
            
            let unit = parentView?.bio.weightUnit;
            if(unit!.containsString("kg")){
                weightSegment.selectedSegmentIndex  = 0;
            }else{
                weightSegment.selectedSegmentIndex  = 1;
            }
            
            let unitheight = parentView?.bio.heightUnit;
            
            if(unitheight!.containsString("inch")){
                heightSegment.selectedSegmentIndex  = 0;
            }else{
                heightSegment.selectedSegmentIndex  = 1;
            }
            
            setUpHeightPicker()
            
            weightPickerValue.selectItem (Int(weightValActual!))
            heightPickerValue.selectItem(Int(heightValActual!))
            
            
        }else{
            
            //Default Weight in kg & Height in Inch
            weightPickerValue.selectItem(70);
            heightPickerValue.selectItem(60)
            
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    //Segment Control Click functionalities
    @IBAction func valueChanged(sender: UISegmentedControl) {
        switch (sender){
        case weightSegment:
            updateWeightMode ()
            break;
        case heightSegment:
            updateHeightMode ()
            break;
            //        case waistSegment:
            //            updateWaistMode()
        //            break;
        default:
            
            break;
        }
    }
    
    //Method for changeing Kg To Lbs on change of Segment Control
    func updateWeightMode (){
        
        if(weightSegment.selectedSegmentIndex == 0){
            weightPickerValue.newEndPoint = Constants.MAX_KWEIGHT
            
            //Conerting  Pound to Kg with selected value from the picker on chnage of Segment Controll
            let initialValue =  round((Double(weightPickerValue.getSelectedItem()) * Constants.POUND_TO_KG_CONSTANT)).description;
            let changeValue =   NSString(string:initialValue).integerValue
            weightPickerValue.selectItem(changeValue);
        }else{
            //Calculation of Selected Kg Value to Pounds on chnage of Segment Controll
            weightPickerValue.newEndPoint = Int(Double(Constants.MAX_KWEIGHT) * Constants.KG_TO_POUND_CONSTANT)
            
            //Conerting Kg to Pound with selected value from the picker on chnage of Segment Controll
            let initialValue =  round((Double(weightPickerValue.getSelectedItem()) * Constants.KG_TO_POUND_CONSTANT)).description;
            let changeValue =   NSString(string:initialValue).integerValue
            weightPickerValue.selectItem(changeValue);
        }
        weightPickerValue.reloadData();
    }
    
    
    //Method for changeing Inches To Cm on change of Segment Control
    func updateHeightMode (){
        var changeValue = 0;
        if(heightSegment.selectedSegmentIndex == 0){
            
            heightPickerValue.newEndPoint = Int(round((Double(Constants.MAX_HEIGHT) * Constants.INCH_CONSTANT)))
            //Conerting Cm to Inch with selected value from the picker on change of Segment Controll
            let initialValue =  round((Double(heightPickerValue.getSelectedItem()) * Constants.INCH_CONSTANT)).description;
             changeValue =   NSString(string:initialValue).integerValue
        }else{
            heightPickerValue.newEndPoint = Constants.MAX_HEIGHT
            //Conerting  Inch to Cm with selected value from the picker on change of Segment Controll
            let initialValue =  round((Double(heightPickerValue.getSelectedItem()) * Constants.INCH_TO_CM_CONSTANT)).description;
             changeValue =   NSString(string:initialValue).integerValue
        }
        setUpHeightPicker();
        heightPickerValue.selectItem(changeValue);
    }
    
    func setUpHeightPicker(){
        if(heightSegment.selectedSegmentIndex == 0){
            
            heightPickerValue.newSeperator = "\""
            heightPickerValue.endIcon = "\'"
            heightPickerValue.newDevider = 12;
            
        }else{
            
            heightPickerValue.newSeperator = "."
            heightPickerValue.endIcon = ""
            heightPickerValue.newDevider = 1;
            
        }
        heightPickerValue.reloadData();
    }
    
    
    //    //Method for changeing Inches To Cm on change of Segment Control
    //    func updateWaistMode (){
    //        if(waistSegment.selectedSegmentIndex == 0){
    //            wesitPickerValue.newEndPoint = Int(Double(Height_WeightListViewController.MAX_HEIGHT) * Height_WeightListViewController.INCH_CONSTANT)
    //            wesitPickerValue.newSeperator = "\""
    //            wesitPickerValue.endIcon = "\'"
    //            wesitPickerValue.newDevider = 12;
    //        }else{
    //            wesitPickerValue.newEndPoint = Height_WeightListViewController.MAX_HEIGHT
    //            wesitPickerValue.newSeperator = "."
    //            wesitPickerValue.endIcon = ""
    //            wesitPickerValue.newDevider = 1;
    //        }
    //        wesitPickerValue.reloadData();
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //PickerView Delegate
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int){
        var label = weightValue;
        var lastdigit = ""
        switch (pickerView){
            
        case weightPickerValue :
            setWeight(item)
            label = weightValue;
            if(weightSegment.selectedSegmentIndex == 0){
                lastdigit = "kg"
            }else{
                lastdigit = "pd"
            }
            break;
        case heightPickerValue :
            setHeight(item)
            label = heightValue;
            if(heightSegment.selectedSegmentIndex == 0){
                lastdigit = ""
            }else{
                lastdigit = "cm"
            }
            break;
            //        case wesitPickerValue :
            //            setWaist(item)
            //            label = weistVale;
            //            if(waistSegment.selectedSegmentIndex == 0){
            //                lastdigit = ""
            //            }else{
            //                lastdigit = "cm"
            //            }
        //            break;
        default :
            //label = weightValue;
            break;
        }
        label.text = (pickerView.getValue1(item)).description + pickerView.seperator + (pickerView.getValue2(item)).description + pickerView.endIcon + lastdigit
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    //Method to Convert KG to Pounds and to save value to a variable
    func setWeight(index:Int){
        
        //IN KG
        weightVal = Double(weightPickerValue.getValue1(index))
        weightValActual = Double(weightPickerValue.getSelectedItem())
        
        if(weightSegment.selectedSegmentIndex != 0){
            //IN POUNDS => KG
            weightVal = weightVal! * Constants.KG_TO_POUND_CONSTANT
        }
    }
    
    //Method to Convert CM to Inches and to save value to a variable
    func setHeight(index:Int){
        
        //IN CM
        heightVal = Double(heightPickerValue.getValue1(index))
        
        heightValActual = Double(heightPickerValue.getSelectedItem())
        
        if(heightSegment.selectedSegmentIndex == 0){
            //IN FEET = > CM
            heightVal = heightVal! * Constants.FEET_TO_CM_CONSTANT
            
            //print(heightVal)
            
            //IN INCH = > CM
            let inch = Double(heightPickerValue.getValue2(index))
            heightVal = heightVal! + (inch * Constants.INCH_TO_CM_CONSTANT)
            
            //print(heightVal)
            
        }
        
    }
    
    //    //Method to Convert CM to Inches and to save value to a variable
    //    func setWaist(index:Int){
    //
    //        //IN CM
    //        waistVal = Double(wesitPickerValue.getValue1(index))
    //
    //        if(waistSegment.selectedSegmentIndex == 0){
    //            //IN FEET = > CM
    //            waistVal = waistVal! * Height_WeightListViewController.FEET_TO_CM_CONSTANT
    //            //IN INCH = > CM
    //            let inch = Double(wesitPickerValue.getValue2(index))
    //            waistVal = waistVal! + (inch * Height_WeightListViewController.INCH_TO_CM_CONSTANT)
    //        }
    //
    //    }
    
    //Method for adding values and Providing Alerts
    @IBAction func doneButtonClicked(sender : AnyObject) {
        
        parentView?.bio.weightMeasurement  = weightValActual!
        parentView?.bio.weightUnit   =  (weightSegment.selectedSegmentIndex == 0 ? "kg" : "lbs");
        parentView?.bio.heightMeasurement  = heightValActual!
        parentView?.bio.heightUnit   =  (heightSegment.selectedSegmentIndex == 0 ? "inch" : "cm");
        
        //parentView?.bio.waistMeasurement   = waistVal!
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func BackAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
