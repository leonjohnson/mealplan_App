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
        register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return addedItems.count + 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")
        var title:String = ""
        if(addedItems.count == 0){
            title = addFirstItem;
        }
        else if(indexPath.row == addedItems.count ){
            title = addMoreItem;
            
        }
        else{
            title = (addedItems.object(at: indexPath.row) as? String)!
        }
        cell!.textLabel?.text = title
        return cell!;
    }
    // clicked on ac  cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        deselectRow(at: indexPath, animated: true)
        if(indexPath.row == addedItems.count ){
            //Show alert
            addMore()
        }
        
    }
    
    
    //TO DO COMMENDTS
    // add more alert and handler
    
    func addMore() {
        let alert = UIAlertController(title: addMoreItem, message:nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: cancelText, style: UIAlertActionStyle.default, handler: nil))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = self.addMoreItem
            textField.isSecureTextEntry = false
        })
        alert.addAction(UIAlertAction(title: okText, style: .default, handler:{ (alertAction:UIAlertAction!) in
            let textSelected = (alert.textFields![0] as UITextField).text
            self.addedItems.add(textSelected!)
            self.reloadData();
            
        }))
        if(parent != nil){
            parent!.present(alert, animated: true, completion: nil)
        }else{
           // print("Parent View Controller not connected")
        }
        
    }
    // Override to support conditional editing of the table view.
    // This only needs to be implemented if you are going to be returning NO
    // for some items. By default, all items are editable.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return YES if you want the specified item to be editable.
        if(indexPath.row == addedItems.count ){
            return false
        }
        return self.allowDelete
    }
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            //add code here for when you hit delete
            if (addedItems.count > indexPath.row){
                addedItems.removeObject(at: indexPath.row)
            }
            self.reloadData();
        }
    }
    
}
