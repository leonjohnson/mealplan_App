//
//  settings.swift
//  DailyMeals
//
//  Created by Jithu on 5/26/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import UIKit

class settings: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var settingsTable : UITableView!
    
    //variable created for constant class
    let bio  = Biographical()
    
    let settingstableImages = ["Profile", "Diet", "LikeFood", "DislikeFood", "AboutUs", "ContactUs"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if (section == 0){
            return 6;
        }else{
            return 1
        }
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0){
            
            let cell = tableView.dequeueReusableCellWithIdentifier("profileCellIdentifier", forIndexPath: indexPath)

            //ImageSet from variable for each case:
            let imageName = UIImage(named: settingstableImages[indexPath.row])
            //Text value alligned to left
            cell.textLabel?.textAlignment = NSTextAlignment.Left

            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Your details"
                cell.imageView?.image = imageName
            case 1:
                cell.textLabel?.text = "Your dietary"
                cell.imageView?.image = imageName
            case 2:
                cell.textLabel?.text = "Food you like"
                cell.imageView?.image = imageName
            case 3:
                cell.textLabel?.text = "Food you dislike"
                cell.imageView?.image = imageName
            case 4:
                cell.textLabel?.text = "About us"
                cell.imageView?.image = imageName
            case 5:
                cell.textLabel?.text = "Contact us"
                cell.imageView?.image = imageName
            default:
                break
            }
            return cell
        }
        else{
           
            let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath)
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.textLabel?.text = "How is your meal plan going?"
            return cell
        }
    }
    
    //Navigation to specific ViewControllers based on Cell Click.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
       
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        if (indexPath.section == 0){
            
        switch indexPath.row {
        case 0:
            let destination = storyboard.instantiateViewControllerWithIdentifier("step1StoryBoardID") as! Step1ViewController
            destination.settingsControl = true
            //destination.fromController = "step1Settings"
            navigationController?.pushViewController(destination, animated: true)
        case 1:
            let destination = storyboard.instantiateViewControllerWithIdentifier("step2StoryBoardID") as! Step2ViewController
            destination.settingsControl = true
            //destination.fromController = "step2Settings"
            navigationController?.pushViewController(destination, animated: true)
        case 2:
            let destination = storyboard.instantiateViewControllerWithIdentifier("step3StoryBoardID") as! Step3ViewController
            destination.settingsControl = true
            //destination.fromController = "step3Settings"
            navigationController?.pushViewController(destination, animated: true)
        case 3:
            let destination = storyboard.instantiateViewControllerWithIdentifier("step4StoryBoardID") as! Step4ViewController
            destination.settingsControl = true
            //destination.fromController = "step4Settings"
            navigationController?.pushViewController(destination, animated: true)
        case 4:
            let destination = storyboard.instantiateViewControllerWithIdentifier("aboutUsStoryBoardID") as! AboutUsViewController
            destination.settingsControl = true
            //destination.fromController = "step1Settings"
            navigationController?.pushViewController(destination, animated: true)
        case 5:
            let destination = storyboard.instantiateViewControllerWithIdentifier("contactUsStoryBoardID") as! ContactUsViewController
            destination.settingsControl = true
            //destination.fromController = "step1Settings"
            navigationController?.pushViewController(destination, animated: true)
        default:
            break
        }
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let destination = storyboard.instantiateViewControllerWithIdentifier("feedback") as! LastWeekViewController
            destination.settingsControl = true
            navigationController?.pushViewController(destination, animated: true)

        }


    }
    



}
