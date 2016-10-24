//
//  MultiTag.swift
//  DailyMeals
//
//  Created by Mzalih on 06/04/16.
//  Copyright © 2016 Meals. All rights reserved.
//
import UIKit
class MultiTag: UITableView,UITableViewDataSource,UITableViewDelegate {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    @IBOutlet weak var parent:UIViewController?
    
    @IBInspectable var addFirstItem:String  = "Add definition"
    @IBInspectable var addMoreItem:String   = "Add more definition"
    @IBInspectable var cancelText:String    = "Cancel"
    @IBInspectable var okText:String        = "Ok"
    @IBInspectable var allowDelete:Bool     = true
    
    let addedItems = NSMutableArray();
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.delegate = self;
        self.dataSource = self;
        self.allowsMultipleSelection = false
        self.allowsMultipleSelectionDuringEditing = false
        registerClass(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return addedItems.count + 1;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell")
        var title:String = ""
        if(addedItems.count == 0){
            title = addFirstItem;
        }
        else if(indexPath.row == addedItems.count ){
            title = addMoreItem;
            
        }
        else{
            title = (addedItems.objectAtIndex(indexPath.row) as? String)!
        }
        cell!.textLabel?.text = title
        return cell!;
    }
    // clicked on ac  cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.row == addedItems.count ){
            //Show alert
            addMore()
        }
        
    }
    
    
    //TO DO COMMENDTS
    // add more alert and handler
    
    func addMore() {
        let alert = UIAlertController(title: addMoreItem, message:nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: cancelText, style: UIAlertActionStyle.Default, handler: nil))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = self.addMoreItem
            textField.secureTextEntry = false
        })
        alert.addAction(UIAlertAction(title: okText, style: .Default, handler:{ (alertAction:UIAlertAction!) in
            let textSelected = (alert.textFields![0] as UITextField).text
            self.addedItems.addObject(textSelected!)
            self.reloadData();
            
        }))
        if(parent != nil){
            parent!.presentViewController(alert, animated: true, completion: nil)
        }else{
           // print("Parent View Controller not connected")
        }
        
    }
    // Override to support conditional editing of the table view.
    // This only needs to be implemented if you are going to be returning NO
    // for some items. By default, all items are editable.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return YES if you want the specified item to be editable.
        if(indexPath.row == addedItems.count ){
            return false
        }
        return self.allowDelete
    }
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            //add code here for when you hit delete
            if (addedItems.count > indexPath.row){
                addedItems.removeObjectAtIndex(indexPath.row)
            }
            self.reloadData();
        }
    }
    
}
