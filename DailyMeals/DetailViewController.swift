//
//  DetailViewController.swift
//  DailyMeals
//
//  Created by Mzalih on 18/11/15.
//  Copyright © 2015 Meals. All rights reserved.
//
//TO DO COMMENDTS (Add proper comments for all method)
import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var foodNameLabel: UILabel!
    @IBOutlet var weightHolder: UIView!
    @IBOutlet var valSize: UILabel!
    @IBOutlet var valServing: UITextField!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var addFoodButton: UIButton!
    
    @IBOutlet var nutritionTable: UITableView!
    
    var originalLikedFoods = NSMutableArray()
    var likedFoods = NSMutableArray()
    
    //var hideAddButton: Bool? = nil
    
    var meal : Meal?
    
    var masterView:ListViewController!
    var nutrientsToDisplay:[(name: String, value: String)] = []
    var detailItem: FoodItem? {
        didSet {
            
            // Update the view.
            self.configureView()
        }
    }
    
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let list = DataHandler.getLikeFoods().foods
        
        for food in list {
            likedFoods.addObject(food.name)
            originalLikedFoods.addObject(food.name)
        }
        
        
        // Set the like image
        if likedFoods.containsObject((detailItem?.food?.name)!)
        {
            likeButton.setImage(UIImage(named: "likeImage")!, forState: .Normal)
            likeButton.tag = 0
        }
        else
        {
            likeButton.setImage(UIImage(named: "UnlikeImage")!, forState: .Normal)
            likeButton.tag = 1
        }
        
    
    
        //let arrayOfObjects = Array(DataHandler.getDisLikedFoods().food);
        
        //Done button View for Serving Size Text Field keyboard
        let barButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: valServing, action: #selector(UIResponder.resignFirstResponder))
        //let barButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: valServing, action: "resignFirstResponder")
        barButton.tintColor = UIColor.blackColor()
        let toolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        toolbar.items = [barButton]
        valServing.inputAccessoryView = toolbar
        valServing.borderStyle = .None
        
        valServing.attributedText = NSAttributedString(string: (detailItem?.numberServing.description)!, attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        valSize.attributedText = NSAttributedString(string: (detailItem?.food?.servingSize!.name)!, attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        

        //presentTransparentNavigationBar();
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
        // Do any additional setup after loading the view, typically from a nib.
        //self.configureView()
        
        //Like & Unlike Action & Default Image Setting & Button Tag.
        likeButton.addTarget(self, action: #selector(DetailViewController.likeAction(_:)), forControlEvents: .TouchUpInside)
        //likeButton.addTarget(self, action: "likeAction:", forControlEvents: .TouchUpInside)
        
        weightHolder.hidden = false;
        weightHolder.layer.borderColor = Constants.MP_GREY.CGColor
        weightHolder.layer.borderWidth = 0.5
        
        foodNameLabel.attributedText = NSAttributedString(string: (detailItem?.food?.name)!, attributes: [NSFontAttributeName:Constants.DETAIL_PAGE_FOOD_NAME_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
 
        
        let servingSizeTextLabel =  self.view.viewWithTag(120) as? UILabel
        let numberOfServingsTextLabel =  self.view.viewWithTag(121) as? UILabel
        
        servingSizeTextLabel?.attributedText = NSAttributedString(string: "Serving size", attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        numberOfServingsTextLabel?.attributedText = NSAttributedString(string: "Number of servings", attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        print("self : \(detailItem?.food?.oftenEatenWith.count)")

        
    }
    
    
    
    @IBAction func onClickAdd(sender: AnyObject) {
        if(self.detailItem == nil)
        {
            onBackClick(sender);
            return
        }
        
        
        if (meal?.foodItems.contains(detailItem!))! { // existing food
            DataHandler.updateFoodItem(detailItem!, numberServing: Double(valServing.text!)!)
        }
        else
        {
            // it's a new food item
            let num = Double(valServing.text!)
            if(num != nil && num > 0){
                
                DataHandler.updateFoodItem(detailItem!, numberServing: Double(valServing.text!)!)
                DataHandler.addFoodItemToMeal(meal!, foodItem:detailItem!);
                onBackClick(sender);
            }else{
                //Invalid value entered in the serving field
                return
            }
        }
    }
    
    
    
    
    @IBAction func onBackClick(sender: AnyObject) {
        
        if originalLikedFoods != likedFoods
        {
            DataHandler.updateLikeFoods(likedFoods)
        }
        self.navigationController!.popToRootViewControllerAnimated(true);
    }
    
    
    
    
    
    
    
    func configureView()
    {
        // Update the user interface for the detail item.
        
        nutrientsToDisplay += [(name: "Calories", value: (Int((detailItem?.food?.calories)!).description) + " kcal")]
        nutrientsToDisplay += [(name: "Fats", value: (detailItem?.food?.fats.description)! + " g")]
        nutrientsToDisplay += [(name: "Saturated fats", value: (detailItem?.food?.sat_fats.value!.description)! + " g")]
        nutrientsToDisplay += [(name: "Carbohydrates", value: (detailItem?.food?.carbohydrates.description)! + " g")]
        nutrientsToDisplay += [(name: "Sugars", value: (detailItem?.food?.sugars.value!.description)! + " g")]
        nutrientsToDisplay += [(name: "Fibre", value: (detailItem?.food?.fibre.value!.description)! + " g")]
        nutrientsToDisplay += [(name: "Proteins", value: (detailItem?.food?.proteins.description)! + " g")]
        nutrientsToDisplay += [(name: "Salt", value: (detailItem?.food?.salt.description)! + " mg")]
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vheadView = UIView()
        //vheadView.backgroundColor = UIColor.whiteColor()
        
        
        let  headerCell = UILabel()
        headerCell.frame=CGRectMake(15, 10, tableView.frame.width-30, 20)
        vheadView.addSubview(headerCell)
        headerCell.attributedText = NSAttributedString(string: "Nutritional information", attributes: [NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        tableView.tableHeaderView = vheadView;
        return vheadView
    }
    
    

    
    //Button action for like and dislike image.
    @IBAction func likeAction(sender: UIButton)
     {
        if sender.tag == 1 {
            sender.setImage(UIImage(named: "likeImage")!, forState: .Normal)
            sender.tag = 0
            likedFoods.addObject((detailItem?.food)!)
        } else {
            sender.setImage(UIImage(named: "UnlikeImage")!, forState: .Normal)
            sender.tag = 1
            likedFoods.removeObject((detailItem?.food)!)
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func presentTransparentNavigationBar() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.setNavigationBarHidden(false, animated:true)
    }
    
    
    
    // UITableView methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutrientsToDisplay.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 34
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let nutrientNameLabel =  cell.viewWithTag(110) as? UILabel
        let amountLabel =  cell.viewWithTag(111) as? UILabel
        
        nutrientNameLabel?.attributedText = NSAttributedString(string: nutrientsToDisplay[indexPath.row].name, attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        amountLabel?.attributedText = NSAttributedString(string: nutrientsToDisplay[indexPath.row].value, attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        
        //cell.detailTextLabel?.attributedText = NSAttributedString(string: nutrientsToDisplay[indexPath.row].name, attributes: [NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        return cell

    }
    
    
    
}

