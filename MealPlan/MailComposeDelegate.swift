import UIKit
import MessageUI
import FacebookCore

class MailComposeDelegate: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            AppEventsLogger.log("cancelled sending email")
        case .saved:
            AppEventsLogger.log("saving email for later")
        case .sent:
            AppEventsLogger.log("email sent")
        case .failed:
            AppEventsLogger.log("error sending mail: \(error?.localizedDescription)")
        }
        controller.dismiss(animated: true)
    }

}
