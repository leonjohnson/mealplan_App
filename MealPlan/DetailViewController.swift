import UIKit
import FacebookCore
/*
private extension Selector {
    static let hideKeyboard =
        #selector(DetailViewController.hideKeyboard(_:))
    //#selector(tap(_:))
}
 */
protocol MPViewControllerDelegate {
    // indicates that the given item has been deleted
    func editFoodItemAtIndexPath(_ indexPath: IndexPath, editType: String)
    func getThisWeek()->Week
}

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    
    
    @IBOutlet var foodNameLabel: UILabel!
    @IBOutlet var weightHolder: UIView!
    @IBOutlet var valServingType: UILabel!
    @IBOutlet var valServingSize: UITextField!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var addFoodButton: UIButton!
    @IBOutlet var deleteFoodButton: UIButton!
    
    @IBOutlet var nutritionTable: UITableView!
    
    var originalLikedFoods = NSMutableArray()
    var likedFoods = NSMutableArray()
    var revertToOriginal :Bool = true
    var newItemMode :Bool = false
    
    var delegate: MPViewControllerDelegate? // The object that acts as delegate for this cell.
    var foodItemIndexPath: IndexPath? // The item that this cell renders.
    
    //var hideAddButton: Bool? = nil
    
    var meal : Meal?
    
    var nutrientsToDisplay:[(name: String, value: String)] = []
    var detailItem: FoodItem! = FoodItem() {
        didSet {
            
            // Update the view.
            self.configureDataView()
            
        }
    }
    var originalDetailItemNumberOfServing: Double = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nutritionTable.allowsSelection = false
        self.nutritionTable.delegate = self
        
        
        if newItemMode == false {
            addFoodButton.isHidden = true
            addFoodButton.isEnabled = false
        }
        
        originalDetailItemNumberOfServing = detailItem.numberServing
        
        let list = DataHandler.getLikeFoods().foods
        for food in list {
            likedFoods.add(food.name)
            originalLikedFoods.add(food.name)
        }
        
        
        // Set the like image
        if likedFoods.contains((detailItem.food?.name)!){
            likeButton.setImage(UIImage(named: "likeImage")!, for: UIControlState())
            likeButton.tag = 0
        }
        else {
            likeButton.setImage(UIImage(named: "UnlikeImage")!, for: UIControlState())
            likeButton.tag = 1
        }
        
    
    
        
        //Done button View for Serving Size Text Field keyboard
        let barButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(DetailViewController.hideKeyboard(textfield:)))
        barButton.tintColor = UIColor.black
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        toolbar.items = [barButton]
        
        //Set up the serving size box items
        valServingSize.inputAccessoryView = toolbar
        valServingSize.borderStyle = .none
        valServingSize.keyboardType = UIKeyboardType.decimalPad
        
        valServingSize.attributedText = NSAttributedString(string: String(detailItem.numberServing), attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        //The number of serving
        valServingType.attributedText = NSAttributedString(string: (detailItem.food?.servingSize!.name)! , attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        

        //presentTransparentNavigationBar();
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
        // Do any additional setup after loading the view, typically from a nib.
        //self.configureView()
        
        //Like & Unlike Action & Default Image Setting & Button Tag.
        likeButton.addTarget(self, action: #selector(DetailViewController.likeAction(_:)), for: .touchUpInside)
        //likeButton.addTarget(self, action: "likeAction:", forControlEvents: .TouchUpInside)
        
        weightHolder.isHidden = false;
        weightHolder.layer.borderColor = Constants.MP_WHITE.cgColor
        weightHolder.layer.borderWidth = 0.5
        
        foodNameLabel.attributedText = NSAttributedString(string: (detailItem.food?.name)!, attributes: [NSFontAttributeName:Constants.DETAIL_PAGE_FOOD_NAME_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
 
        
        let servingSizeTextLabel =  self.view.viewWithTag(120) as? UILabel
        let numberOfServingsTextLabel =  self.view.viewWithTag(121) as? UILabel
        
        servingSizeTextLabel?.attributedText = NSAttributedString(string: "Serving size", attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        numberOfServingsTextLabel?.attributedText = NSAttributedString(string: "Number of servings", attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppEventsLogger.log("DetailViewController view will appear")
    }
    
    fileprivate func updateFoodItem(numOfServing:Double? = nil){
        let currentWeek = delegate?.getThisWeek()
        print("called with parameter of :\(numOfServing)")
        
        var numServing = 0.0
        if numOfServing == nil {
            numServing = Constants.roundToPlaces(Double(valServingSize.text!)!, decimalPlaces: 2)
        } else {
            numServing = originalDetailItemNumberOfServing
        }
        
        _ = mealContainsFood(foodItem: detailItem)
        

        
        if (newItemMode == false) { // existing food
            if(numServing > 0){
                DataHandler.updateFoodItem(detailItem, numberServing: numServing)
                DataHandler.updateCalorieConsumption(thisWeek: currentWeek!)
                
            } else {
                print("Error: Please add a positive number")
            }
        }
        else
        {
            // it's a new food item but not one that is in the meal already
            if(numServing > 0){
                DataHandler.updateFoodItem(detailItem, numberServing: numServing)
                DataHandler.addFoodItemToMeal(meal!, foodItem:detailItem)
                DataHandler.updateCalorieConsumption(thisWeek: currentWeek!)
            }else{
                print("Error: Please add a positive number")
                //Invalid value entered in the serving field
                return
            }
        }
    
    }

    @IBAction func onClickAdd(_ sender: AnyObject) {
        
        revertToOriginal = false
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        
        updateFoodItem()
        onBackClick(sender)
        AppEventsLogger.log("added food to meal plan")
        
    }
    
    
    
    
    @IBAction func onBackClick(_ sender: AnyObject) {
        
        if originalLikedFoods != likedFoods{
            DataHandler.updateLikeFoods(likedFoods)
        }
        
        if revertToOriginal == true{
            print("original serving size: \(originalDetailItemNumberOfServing)")
            updateFoodItem(numOfServing: originalDetailItemNumberOfServing)
        }
        
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        //self.navigationController!.popToRootViewController(animated: true);
    }
    
    
    
    
    
    
    
    func configureDataView(){
        // Update the user interface for the detail item.
        nutrientsToDisplay = []
        
        let calories : String = Int(((detailItem.food?.calories)! * (detailItem.numberServing))).description
        nutrientsToDisplay += [(name: "Calories", value: (calories) + " kcal")]

        if let fa = detailItem.food?.fats{
            nutrientsToDisplay += [(name: "Fats", value: String(Constants.roundToPlaces(fa * detailItem.numberServing, decimalPlaces: 2)) + " g")]
        }
        
        if let sa = detailItem.food?.sat_fats.value{
            nutrientsToDisplay += [(name: "Saturated fats", value: String(Constants.roundToPlaces(sa * detailItem.numberServing, decimalPlaces: 2)) + " g")]
        }
        
        
        if let ca = detailItem.food?.carbohydrates{
            nutrientsToDisplay += [(name: "Carbohydrates", value: String(Constants.roundToPlaces(ca * detailItem.numberServing, decimalPlaces: 2)) + " g")]
        }
        
        
        if let su = detailItem.food?.sugars.value{
            nutrientsToDisplay += [(name: "Sugars", value: String(Constants.roundToPlaces(su * detailItem.numberServing, decimalPlaces: 2)) + " g")]
        }
        
        if let fi = detailItem.food?.fibre.value{
            nutrientsToDisplay += [(name: "Fibre", value: String(Constants.roundToPlaces(fi * detailItem.numberServing, decimalPlaces: 2)) + " g")]
        }
        
        if let pr = detailItem.food?.proteins{
            nutrientsToDisplay += [(name: "Proteins", value: String(Constants.roundToPlaces(pr * detailItem.numberServing, decimalPlaces: 2)) + " g")]
        }
        
        if let salt = detailItem.food?.salt{
            nutrientsToDisplay += [(name: "Salt", value: String(Constants.roundToPlaces(salt * detailItem.numberServing, decimalPlaces: 2)) + " mg")]
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vheadView = UIView()
        //vheadView.backgroundColor = UIColor.whiteColor()
        
        
        let  headerCell = UILabel()
        headerCell.frame=CGRect(x: 15, y: 10, width: tableView.frame.width-30, height: 20)
        vheadView.addSubview(headerCell)
        headerCell.attributedText = NSAttributedString(string: "Nutritional information", attributes: [NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        tableView.tableHeaderView = vheadView;
        return vheadView
    }
    
    

    
    //Button action for like and dislike image.
    @IBAction func likeAction(_ sender: UIButton)
     {
        if sender.tag == 1 {
            sender.setImage(UIImage(named: "likeImage")!, for: UIControlState())
            sender.tag = 0
            likedFoods.add((detailItem.food)!)
        } else {
            sender.setImage(UIImage(named: "UnlikeImage")!, for: UIControlState())
            sender.tag = 1
            likedFoods.remove((detailItem.food)!)
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func presentTransparentNavigationBar() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.setNavigationBarHidden(false, animated:true)
    }
    
    
    
    // UITableView methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutrientsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let nutrientNameLabel =  cell.viewWithTag(110) as? UILabel
        let amountLabel =  cell.viewWithTag(111) as? UILabel
        
        nutrientNameLabel?.attributedText = NSAttributedString(string: nutrientsToDisplay[indexPath.row].name, attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        amountLabel?.attributedText = NSAttributedString(string: nutrientsToDisplay[indexPath.row].value, attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        
        //cell.detailTextLabel?.attributedText = NSAttributedString(string: nutrientsToDisplay[indexPath.row].name, attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        return cell

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return text.characters.count == 0 ? true : text.isDecimal()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView.text != "" || textView.text.characters.last == "." else {
            return
        }
        if newItemMode == true{
            addFoodButton.isEnabled = (textView.text == String(detailItem.numberServing) || textView.text.isEmpty) ? false : true
        }
        
        updateFoodItem(numOfServing: Double(textView.text))
        configureDataView()
        self.nutritionTable.reloadData()
    }
    
    

    func hideKeyboard(textfield:UITextField) {
        valServingSize.resignFirstResponder()
        
        
        
        //valServingSize.resignFirstResponder()
    }
    
    
    func mealContainsFood(foodItem:FoodItem) -> (Bool, FoodItem?){
        for fi in (meal?.foodItems)!{
            if fi.food == foodItem.food {
                return (true, fi)
            }
        }
        return (false, nil)
    }
    
    
    @IBAction func deleteIt(){
        onBackClick(UIButton())
        if delegate != nil{
            delegate!.editFoodItemAtIndexPath(foodItemIndexPath!, editType: Constants.DELETE)
        }
        print("delete it called in detail view")
    }
    
        
}

