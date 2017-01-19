import UIKit
import FacebookCore

class CaloriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet var caloriesListTable : UITableView!
    @IBOutlet var namelabel : UILabel!
    @IBOutlet var caloriesCountLabel : UILabel!
    @IBOutlet var closeButton : UIButton!
    @IBOutlet var percentToggle: UISegmentedControl!
    
    var thisWeek:Week?
    var nextWeek:Week?
    var settingsControl : Bool? //For SettingsTab bar
    
    var showPercentOnly: Bool?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        caloriesListTable.allowsSelection = false
        caloriesListTable.rowHeight = Constants.TABLE_ROW_HEIGHT
        let futureWeeks = SetUpMealPlan.getThisWeekAndNext()
        thisWeek = futureWeeks[0]
        assert(futureWeeks[1] != Week(), "Invalid futureWeek")
        nextWeek = futureWeeks[1]
        showPercentOnly = true
        
        /*
         
         Check if the week exists. If not, create a week, set calories, and set its meals.
         If the week does exist, retrieve it.

         */
        
        caloriesListTable.delegate = self
        
        let attributes = [NSFontAttributeName:Constants.STANDARD_FONT]
        let newAttributes = [NSFontAttributeName:Constants.GENERAL_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE]
        percentToggle.setTitleTextAttributes(attributes, for: UIControlState())
        percentToggle.setTitleTextAttributes(newAttributes, for: .selected)
        percentToggle.selectedSegmentIndex = 1
        changeUnitOfMacroMeasurement(percentToggle)
        
        //navigationItem.rightBarButtonItem?.isEnabled = false

        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        caloriesListTable.reloadData()
        reloadCaloriesView()
        
        //To display Regestered Users name on Meal Plan's page
        namelabel.attributedText = NSAttributedString(string:DataHandler.getActiveUser().name.capitalized + ", you need ", attributes:[NSFontAttributeName:Constants.GENERAL_LABEL, NSForegroundColorAttributeName:Constants.MP_BLUE])
        super.viewWillAppear(true)
        AppEventsLogger.log("CaloriesViewController viewed")
    }
    
    func reloadCaloriesView(){
        //Format the number:
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let largeNumber = NSNumber(value: (thisWeek?.calorieAllowance)!) as NSNumber
        let string = numberFormatter.string(from: largeNumber)
        caloriesCountLabel.attributedText = NSMutableAttributedString(string:string! + " calories", attributes:[NSFontAttributeName:Constants.GENERAL_LABEL, NSForegroundColorAttributeName:Constants.MP_BLUE])
    }

    //MARK - Table Delagte & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let p = (thisWeek?.macroAllocation[0].value)! * 4 / Double((thisWeek?.calorieAllowance)!)
        var pPercent = Int(p * 100)
        
        let c = (thisWeek?.macroAllocation[1].value)! * 4 / Double((thisWeek?.calorieAllowance)!)
        let cPercent = Int(c * 100)
        
        let f = (thisWeek?.macroAllocation[2].value)! * 9 / Double((thisWeek?.calorieAllowance)!)
        let fPercent = Int(f * 100)
        
        print("p: \(pPercent), c: \(cPercent), f: \(fPercent)")
        
        let difference = 100 - (pPercent + cPercent + fPercent)
        pPercent = difference > 0 ? pPercent + difference : pPercent
        
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as? CaloriesTableViewCell
        if(cell == nil){
            /**
             Dynamic cell creation .
             It Should be changed base on the future scenario
             */
            let macroAttributes = [NSFontAttributeName: Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_BLACK]
            let numberAttributes = [NSFontAttributeName: Constants.STANDARD_FONT_BOLD, NSForegroundColorAttributeName:Constants.MP_BLACK]
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle,reuseIdentifier:"CellIdentifier")
            
            var macroName = ""
            var macroValue = ""
            let macroPercent:Int?
            
            
            switch indexPath.row {
            case 0:
                macroName = (thisWeek?.macroAllocation[1].name)!//proteins
                macroValue = String(Int((thisWeek?.macroAllocation[1].value)!))+"g"
                macroPercent = cPercent
            case 1:
                macroName = (thisWeek?.macroAllocation[0].name)! //carbs
                macroValue = String(Int((thisWeek?.macroAllocation[0].value)!))+"g"
                macroPercent = pPercent
            case 2:
                macroName = (thisWeek?.macroAllocation[2].name)!//fats
                macroValue = String(Int((thisWeek?.macroAllocation[2].value)!))+"g"
                macroPercent = fPercent
            default:
                macroName = "Fats"
                let a = (thisWeek?.macroAllocation[0].value)! * 9 / Double((thisWeek?.calorieAllowance)!)
                macroPercent = Int(a * 100)
            }
            //Dynamic descriptionLabel
            let  descriptionLabel = UILabel()
            descriptionLabel.frame=CGRect(x: 15, y: 18, width: tableView.frame.width-150, height: 20)
            descriptionLabel.attributedText = NSMutableAttributedString(string:macroName, attributes:macroAttributes)
            cell.addSubview(descriptionLabel)
            
            //Dynamic gramValueLabel
            let gramValueLabel = UILabel()
            gramValueLabel.frame=CGRect( x: tableView.frame.width-150, y: 18, width: 50, height: 20)
            gramValueLabel.attributedText = NSMutableAttributedString(string:String(macroValue), attributes:numberAttributes)
            cell.addSubview(gramValueLabel)
            gramValueLabel.isHidden = showPercentOnly!
            
            //Dynamic percentageValueLabel
            let percentageValueLabel = UILabel()
            //percentageValueLabel.frame=CGRectMake(tableView.frame.width-75,18,50, 20)
            percentageValueLabel.frame = CGRect( x: tableView.frame.width-150, y: 18, width: 50, height: 20)
            percentageValueLabel.attributedText = NSMutableAttributedString(string:String(macroPercent!)+"%", attributes:numberAttributes)
            cell.addSubview(percentageValueLabel)
            percentageValueLabel.isHidden = !(showPercentOnly!)

        }
        return cell
        
    }

    
    @IBAction func changeUnitOfMacroMeasurement(_ segmentedControl:UISegmentedControl){
        showPercentOnly = segmentedControl.selectedSegmentIndex == 0 ? true : false
        caloriesListTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ChangeMacros
        controller.thisWeek = thisWeek!
        //controller.navigationItem.rightBarButtonItem?.titleTextAttributes(for: .normal) = [NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE]
    }

    
}
