//
//  DragToTable.swift
//  DailyMeals
//
//  Created by Mzalih on 07/04/16.
//  Copyright © 2016 Meals. All rights reserved.
//
import UIKit

class DragToTable:NSObject {
    
    private static let sharedInstance:DragToTable = DragToTable()
    
    
    var movingV: UIView!
    var holderView: UIView!
    var tableView: UITableView!
    var longpress:UILongPressGestureRecognizer!
    var listner:((indexPath:NSIndexPath)->Void)!
    
    
    
    static func activate(movingView:UIView,table : UITableView, view:UIView,listen:(indexPath:NSIndexPath)->Void)->DragToTable{
        let dragger  = DragToTable.sharedInstance
        dragger.activate(movingView, table: table, view: view,listen: listen);
        return dragger
    }
    
    func activate(movingView:UIView,table : UITableView, view:UIView,listen:(indexPath:NSIndexPath)->Void){
        movingV = movingView
        tableView = table
        holderView = view
        listner = listen
        
        //CAHNGE DEPRECATION WARNING
         // longpress  = UILongPressGestureRecognizer(target: DragToTable.sharedInstance, action: "longPressGestureRecognized:")
        longpress  = UILongPressGestureRecognizer(target: DragToTable.sharedInstance, action: #selector(DragToTable.longPressGestureRecognized(_:)))
        if((movingV) != nil){
            movingV.addGestureRecognizer(longpress!)
            
            
        }
        
    }
    internal func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.locationInView(holderView)
        let locationInTableView = longPress.locationInView(tableView)
        
        let indexPath = tableView.indexPathForRowAtPoint(locationInTableView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        
        switch state {
            
        case UIGestureRecognizerState.Began:
            Path.initialIndexPath = NSIndexPath(forItem: 0, inSection: 0);
            if(indexPath != nil){
                Path.initialIndexPath = indexPath
            }
            My.cellSnapshot  = snapshotOfCell(movingV)
            var center = movingV.center
            My.cellSnapshot!.center = center
            My.cellSnapshot!.alpha = 0.0
            holderView.addSubview(My.cellSnapshot!)
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                center.y = locationInView.y
                My.cellIsAnimating = true
                My.cellSnapshot!.center = center
                My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                My.cellSnapshot!.alpha = 0.98
                // myview.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animateWithDuration(0.25, animations: { () -> Void in
                                //MOVED
                                
                            })
                        } else {
                            
                        }
                    }
            })
            
            
        case UIGestureRecognizerState.Changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
            }
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                //    itemsArray.insert(itemsArray.removeAtIndex(Path.initialIndexPath!.row), atIndex: indexPath!.row)
                // tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                
                Path.initialIndexPath = indexPath
            }
        default:
            
            if My.cellIsAnimating {
                My.cellNeedToShow = true
            } else {
                
            }
            if (indexPath != nil) {
                if((listner) != nil){
                    listner(indexPath: indexPath!);
                }
                //  itemsArray.insert("New Item", atIndex: indexPath!.row+1)
                self.tableView.reloadData()
                
            }
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                My.cellSnapshot!.transform = CGAffineTransformIdentity
                My.cellSnapshot!.alpha = 0.00
                
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
            })
        }
        
    }
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
}