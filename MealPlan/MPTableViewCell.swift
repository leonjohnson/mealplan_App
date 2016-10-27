//
//  MPTableViewCell.swift
//  MealPlan
//
//  Created by Leon Johnson on 25/10/2016.
//  Copyright © 2016 Meals. All rights reserved.
//

import UIKit

protocol MPTableViewCellDelegate {
    // indicates that the given item has been deleted
    func editFoodItemAtIndexPath(_ indexPath: IndexPath, editType: String)
}

class MPTableViewCell: UITableViewCell {
    
    @IBOutlet var foodNameLabel : UILabel!
    @IBOutlet var foodQuantityLabel : UILabel!
    @IBOutlet var foodCaloryLabel : UILabel!
    @IBOutlet var mealArrowImage : UIImageView!
    
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    var completeOnDragRelease = false
    
    var delegate: MPTableViewCellDelegate? // The object that acts as delegate for this cell.
    var foodItemIndexPath: IndexPath? // The item that this cell renders.

 
    override func awakeFromNib() {
        // add a pan recognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(MPTableViewCell.handlePan(_:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        print("Added gesture")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK: - horizontal pan gesture methods
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            completeOnDragRelease = frame.origin.x > frame.size.width / 2.0
        }
        // 3
        if recognizer.state == .ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            if !deleteOnDragRelease {
                // if the item is not being deleted, snap back to the original location
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            }
            
            if deleteOnDragRelease {
                if delegate != nil && foodItemIndexPath != nil {
                    // notify the delegate that this item should be deleted
                    delegate!.editFoodItemAtIndexPath(foodItemIndexPath!, editType: Constants.DELETE)
                }
            }
            else if completeOnDragRelease {
                if foodItemIndexPath != nil {
                    delegate!.editFoodItemAtIndexPath(foodItemIndexPath!, editType: Constants.EDIT)
                }
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            } else {
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            }
        }
    }
    
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    
    

}
