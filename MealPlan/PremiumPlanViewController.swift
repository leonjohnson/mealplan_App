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
        planFeatuersTable.separatorStyle = UITableViewCellSeparatorStyle.none


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
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if (indexPath.section == 0){
            return 250
        }else{
            return 100
        }
    }
   

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCellIdentifier") as? PayemtControllerImageTableViewCell
            cell?.imageCell.image = UIImage(named: "Intro2")
            return cell!
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "addsCellIdentifier") as? PayemtAddsTableViewCell
            cell?.addsImage.image = UIImage(named: "addsImage")
            return cell!
        }
        
        
    }
    
    
    //      Border for TableView cells
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.backgroundColor = UIColor.clear
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
    }

    
    
    @IBAction func backAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }


}
