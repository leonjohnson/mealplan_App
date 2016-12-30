/*!
 @header     ContactUsViewController
 @abstract   The ContactUsViewController class provides an interface for the user to send an email to us.
 @discussion MFMailComposeViewController is used for implementing a simple interface for users to enter
 and send email.
 */

import UIKit
import MessageUI

class ContactUsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var settingsControl : Bool?
    var fromController = NSString()
    @IBOutlet var titleDistanceConstraint: NSLayoutConstraint!
    @IBOutlet var textviewborder : UIView!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var feedBackText : UITextView!
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["feedback@mealplanapp.com"])
            mail.setSubject("Feedback")
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error?.localizedDescription)")
        }
        controller.dismiss(animated: true)
    }
    


}
