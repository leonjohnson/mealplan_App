/*!
 @header     settings
 @abstract   The settings class provides an interface for the user to send an email to us.
 @discussion MFMailComposeViewController is used for implementing a simple interface for users to enter
 and send email.
 */


import UIKit
import MessageUI
import FacebookCore

class settings: UIViewController, UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet var settingsTable : UITableView!
    @IBOutlet var settingsLabel : UILabel!
    let imagesForSettings = ["AboutUs", "ContactUs"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsLabel.attributedText = NSAttributedString(string: "Settings", attributes: [NSFontAttributeName:Constants.STANDARD_FONT_BOLD, NSForegroundColorAttributeName:Constants.MP_BLACK])
        AppEventsLogger.log("more page")
        
        
    }

    
    //TABLEVIEW DELEGATE & DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (section == 0){
            return 2
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TABLE_ROW_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCellIdentifier", for: indexPath)
        //ImageSet from variable for each case:
        let imageName = UIImage(named: imagesForSettings[indexPath.row])
        //Text value alligned to left
        cell.textLabel?.textAlignment = NSTextAlignment.left
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "About us"
            cell.imageView?.image = imageName
        case 1:
            cell.textLabel?.text = "Contact us"
            cell.imageView?.image = imageName
        default:
            break
        }
        return cell
    }
    
    //Navigation to specific ViewControllers based on Cell Click.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == 0 {
            let url = URL(string:Constants.ABOUT_US_URL)!
            //let request = NSURLRequest(url: url) as URLRequest
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        if indexPath.row == 1{
            sendEmail()
        }
        self.settingsTable.deselectRow(at: indexPath, animated: true)
    }

    
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
            AppEventsLogger.log("cancelled sending email")
        case .saved:
            AppEventsLogger.log("saving email for later")
        case .sent:
            AppEventsLogger.log("email sent!")
        case .failed:
            AppEventsLogger.log("error sending mail: \(error?.localizedDescription)")
        }
        controller.dismiss(animated: true)
    }



}
