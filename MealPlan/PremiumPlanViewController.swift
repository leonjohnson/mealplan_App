//
//  PremiumPlanViewController.swift
//  DailyMeals
//
//  Created by Jithu on 3/18/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import UIKit

class PremiumPlanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var planFeatuersTable : UITableView!
    @IBOutlet var backButton : UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //planFeatuersTable.delegate = self
        
//      Seprator lines None for TableView cells
        planFeatuersTable.separatorStyle = UITableViewCellSeparatorStyle.None


        // Do any additional setup after loading the view.
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
    
    //TABLEVIEW DELEGATE & DATASOURCE
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        if (indexPath.section == 0){
            return 250
        }else{
            return 100
        }
    }
   

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            
            let cell = tableView.dequeueReusableCellWithIdentifier("imageCellIdentifier") as? PayemtControllerImageTableViewCell
            cell?.imageCell.image = UIImage(named: "Intro2")
            return cell!
        }
        else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("addsCellIdentifier") as? PayemtAddsTableViewCell
            cell?.addsImage.image = UIImage(named: "addsImage")
            return cell!
        }
        
        
    }
    
    
    //      Border for TableView cells
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height))
        
        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
    }

    
    
    @IBAction func backAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }


}
