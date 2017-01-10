import UIKit

class Introduction: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view = launchBkgrd()
        self.view.backgroundColor = Constants.MP_BLUE
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func startSignUp(){
        performSegue(withIdentifier: "signup", sender: nil)
    }
    func drawGradient(){
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let gradientColor = UIColor(red: 0.246, green: 0.277, blue: 0.843, alpha: 1.000)
        let gradientColor2 = UIColor(red: 0.358, green: 0.447, blue: 0.773, alpha: 1.000)
        let gradientColor3 = UIColor(red: 0.466, green: 0.810, blue: 0.732, alpha: 1.000)
        
        //// Gradient Declarations
        
        let linearGradient1 = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [gradientColor.cgColor, gradientColor2.cgColor, gradientColor3.cgColor] as CFArray, locations: [0, 0.3, 1])!
        
        //// box Drawing
        let boxPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        context!.saveGState()
        boxPath.addClip()
        context!.drawLinearGradient(linearGradient1,
                                    start: CGPoint(x: 97.08, y: 187.23),
                                    end: CGPoint(x: 18.86, y: -0),
                                    options: [CGGradientDrawingOptions.drawsBeforeStartLocation, CGGradientDrawingOptions.drawsAfterEndLocation])
        context!.restoreGState()

    }
}
