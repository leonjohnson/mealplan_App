import UIKit

class ChangeMacros: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var caloriesField: UITextField! // where the calorie number is displayed
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var macroPicker: UIPickerView!
    @IBOutlet weak var warningField: UITextView!
    
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinsLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    
    var thisWeek:Week = Week()
    var proteinArray : [Int] = []
    var carbArray : [Int] = []
    var fatsArray : [Int] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lowerProteinRange = Int((thisWeek.macroAllocation.first?.value)! - 50)
        let upperProteinRange = Int((thisWeek.macroAllocation.first?.value)! + 50)
        proteinArray = Array(lowerProteinRange...upperProteinRange)
        
        let lowerCarbRange = Int((thisWeek.macroAllocation[1].value) - 50)
        let upperCarbRange = Int((thisWeek.macroAllocation[1].value) + 50)
        carbArray = Array(lowerCarbRange...upperCarbRange)
        
        let lowerFatRange = Int((thisWeek.macroAllocation[2].value) - 25)
        let upperFatRange = Int((thisWeek.macroAllocation[2].value) + 25)
        fatsArray = Array(lowerFatRange...upperFatRange)
        
        caloriesField.text = String(describing: thisWeek.calorieAllowance)
        macroPicker.selectRow(50, inComponent: 0, animated: false)
        macroPicker.selectRow(50, inComponent: 1, animated: false)
        macroPicker.selectRow(25, inComponent: 2, animated: false)
        
        segmentedControl.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeScreen(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNewMacros(){
        let proteinValueSelected = proteinArray[macroPicker.selectedRow(inComponent: 0)]
        let carbsValueSelected = carbArray[macroPicker.selectedRow(inComponent: 1)]
        let fatsValueSelected = fatsArray[macroPicker.selectedRow(inComponent: 2)]

        let protein = Macronutrient()
        protein.name = Constants.PROTEINS
        protein.value = Double(proteinValueSelected)
        
        let carbs = Macronutrient()
        carbs.name = Constants.CARBOHYDRATES
        carbs.value = Double(carbsValueSelected)
        
        let fats = Macronutrient()
        fats.name = Constants.FATS
        fats.value = Double(fatsValueSelected) 
        
        DataHandler.updateMacrosAndCalories(thisWeek, calories: Int(caloriesField.text!)!, macros: [protein, carbs, fats])
        SetUpMealPlan.updateFutureWeeksWithNewMealPlans()// find all future weeks and reset their meal plan
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return proteinArray.count
        case 1:
            return carbArray.count
        case 2:
            return fatsArray.count
        default:
            return 0
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        switch component {
        case 0:
            return NSAttributedString.init(string: String(proteinArray[row]), attributes: nil)
        case 1:
            return NSAttributedString.init(string: String(carbArray[row]), attributes: nil)
        case 2:
            return NSAttributedString.init(string: String(fatsArray[row]), attributes: nil)
        default:
            break
        }
        return NSAttributedString()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let proteinValueSelected = proteinArray[pickerView.selectedRow(inComponent: 0)] * 4
        let carbsValueSelected = carbArray[pickerView.selectedRow(inComponent: 1)] * 4
        let fatsValueSelected = fatsArray[pickerView.selectedRow(inComponent: 2)] * 9
        caloriesField.text = String(proteinValueSelected + carbsValueSelected + fatsValueSelected)
        
    }

}
