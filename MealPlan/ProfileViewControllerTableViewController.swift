//
//  ProfileViewControllerTableViewController.swift
//  MealPlan
//
//  Created by toobler on 28/02/17.
//  Copyright © 2017 Meals. All rights reserved.
//

import UIKit

class ProfileViewControllerTableViewController: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!

    var user:User? ; //DataHandler.getActiveUser() ;
    var bio:Biographical? ; //DataHandler.getActiveBiographical();
    var age:Int = 0;

    func loadData(){
         user = DataHandler.getActiveUser();
         bio = DataHandler.getActiveBiographical();
         age = DataHandler.getAge();
        nameLabel.text = "Name  : " + (user?.first_name)! + (user?.last_name)! ;
        genderLabel.text = user?.gender.capitalized
        self.tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()



        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(user != nil){
            return 2
        } else {
            return 0;
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
        return 8
        }
        else{
        return 3;
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var  cell:UITableViewCell ;
        if(indexPath .section == 0){
            cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        // Configure the cell...

            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Gender"
                cell.detailTextLabel?.text = (user?.gender.capitalized)
                break
            case 1:
                cell.textLabel?.text = "Hours of Cardio"
                cell.detailTextLabel?.text = (bio?.numberOfCardioSessionsEachWeek.description)
                 break
            case 2:
                cell.textLabel?.text = "Hours of Weights/Sports"
                cell.detailTextLabel?.text = (bio?.hoursOfActivity.description)
                 break
            case 3:
                  cell.textLabel?.text = "Weight"
                cell.detailTextLabel?.text = ((bio?.weightMeasurement.description)! + " " + (bio?.weightUnit)!)
                 break
            case 4:
                 cell.textLabel?.text = "Height"
                cell.detailTextLabel?.text = ((bio?.heightMeasurement.description)! + " " +  (bio?.heightUnit)!)
                 break
            case 5:
                 cell.textLabel?.text = "Age"
                cell.detailTextLabel?.text =  String(age)
                 break
            case 6:
                 cell.textLabel?.text = "Weeks Remain"
                cell.detailTextLabel?.text =  bio?.mealplanDuration.description
                 break
            case 7:
                 cell.textLabel?.text = "Activity levels at Work"
                 cell.detailTextLabel?.text = (bio?.activityLevelAtWork)
                 break
            default: break

            }
    }else{
            if(indexPath.row == 0){
            cell = tableView.dequeueReusableCell(withIdentifier: "cellId1", for: indexPath)
                 cell.textLabel?.text = "Objectives"
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "cellId2", for: indexPath)
                var  accessory = false;
                if(indexPath.row == 1){
                    cell.textLabel?.text = "Lose Weight"
                    if(bio?.loseFat.value)!{
                        accessory = true;
                    }
                }else{
                    cell.textLabel?.text = "Gain Muscles"
                    if(bio?.gainMuscle.value)!{
                        accessory = true;
                    }
                }
                    cell.accessoryView?.isHidden = accessory
            }
    }

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let dest:Step1ViewController = segue.destination as! Step1ViewController;
        dest.settingsControl = true;

        
    }


}
