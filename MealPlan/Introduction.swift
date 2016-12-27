import UIKit

class Introduction: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.MP_BLUE
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func startSignUp(){
        performSegue(withIdentifier: "signup", sender: nil)
    }

}
