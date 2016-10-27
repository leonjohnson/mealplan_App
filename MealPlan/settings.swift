import UIKit

class settings: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var settingsTable : UITableView!
    @IBOutlet var settingsLabel : UILabel!
    
    let bio  = Biographical()
    let settingstableImages = ["Profile", "Diet", "LikeFood", "DislikeFood", "AboutUs", "ContactUs"]
    
    
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
            return 6;
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
                cell.textLabel?.text = "Your details"
                cell.imageView?.image = imageName
            case 1:
                cell.textLabel?.text = "Your diet"
                cell.imageView?.image = imageName
            case 2:
                cell.textLabel?.text = "Food you like"
                cell.imageView?.image = imageName
            case 3:
                cell.textLabel?.text = "Food you dislike"
                cell.imageView?.image = imageName
            case 4:
                cell.textLabel?.text = "About us"
                cell.imageView?.image = imageName
            case 5:
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
       
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if (indexPath.section == 0){
            
        switch indexPath.row {
        case 0:
            let destination = storyboard.instantiateViewController(withIdentifier: "step1StoryBoardID") as! Step1ViewController
            destination.settingsControl = true
            //destination.fromController = "step1Settings"
            navigationController?.pushViewController(destination, animated: true)
        case 1:
            let destination = storyboard.instantiateViewController(withIdentifier: "step2StoryBoardID") as! Step2ViewController
            destination.settingsControl = true
            //destination.fromController = "step2Settings"
            navigationController?.pushViewController(destination, animated: true)
        case 2:
            let destination = storyboard.instantiateViewController(withIdentifier: "step3StoryBoardID") as! Step3ViewController
            destination.settingsControl = true
            //destination.fromController = "step3Settings"
            navigationController?.pushViewController(destination, animated: true)
        case 3:
            let destination = storyboard.instantiateViewController(withIdentifier: "step4StoryBoardID") as! Step4ViewController
            destination.settingsControl = true
            //destination.fromController = "step4Settings"
            navigationController?.pushViewController(destination, animated: true)
        case 4:
            let destination = storyboard.instantiateViewController(withIdentifier: "aboutUsStoryBoardID") as! AboutUsViewController
            destination.settingsControl = true
            //destination.fromController = "step1Settings"
            navigationController?.pushViewController(destination, animated: true)
        case 5:
            let destination = storyboard.instantiateViewController(withIdentifier: "contactUsStoryBoardID") as! ContactUsViewController
            destination.settingsControl = true
            //destination.fromController = "step1Settings"
            navigationController?.pushViewController(destination, animated: true)
        default:
            break
        }
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "feedback") as! LastWeekViewController
            destination.settingsControl = true
            navigationController?.pushViewController(destination, animated: true)

        }
        self.settingsTable.deselectRow(at: indexPath, animated: true)


    }
    



}
