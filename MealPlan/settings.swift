import UIKit
import MessageUI
class settings: UIViewController, UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet var settingsTable : UITableView!
    @IBOutlet var settingsLabel : UILabel!
    
    let bio  = Biographical()
    let settingstableImages = ["AboutUs", "ContactUs"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsLabel.attributedText = NSAttributedString(string: "Settings", attributes: [NSFontAttributeName:Constants.DETAIL_PAGE_FOOD_NAME_LABEL, NSForegroundColorAttributeName:Constants.MP_GREY])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //TABLEVIEW DELEGATE & DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
        
        
        if (indexPath.section == 0){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCellIdentifier", for: indexPath)

            //ImageSet from variable for each case:
            let imageName = UIImage(named: settingstableImages[indexPath.row])
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
        else{
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
            cell.textLabel?.textAlignment = NSTextAlignment.center
            cell.textLabel?.text = "How is your meal plan going?"
            return cell
        }
    }
    
    //Navigation to specific ViewControllers based on Cell Click.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
       
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if (indexPath.section == 0){
            
        switch indexPath.row {
        case 0:
            let destination = storyboard.instantiateViewController(withIdentifier: "aboutUsStoryBoardID") as! AboutUsViewController
            destination.settingsControl = true
            //destination.fromController = "step1Settings"
            navigationController?.pushViewController(destination, animated: true)
            break;
        case 1:
            sendMail()
            break;
        default:
            break
            }
        }
        else{
            let storyboard = UIStoryboard(name: "Feedback", bundle: Bundle.main)
            let destination = storyboard.instantiateInitialViewController() as! LastWeekViewController
            destination.settingsControl = true
            navigationController?.pushViewController(destination, animated: true)

        }
 */
        self.settingsTable.deselectRow(at: indexPath, animated: true)


    }
    func sendMail(){
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }else{
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self

            // Configure the fields of the interface.
            composeVC.setToRecipients(["address@example.com"])
            composeVC.setSubject("Hello! Have look")
            composeVC.setMessageBody("Hello from Meals Plan!", isHTML: false)

            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    

    private func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismiss(animated: true, completion: nil)    }



}
