import UIKit

class bkgrd: UIView
{
    override func draw(_ rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        //// Color Declarations
        let gradientColor = UIColor(red: 0.000, green: 0.647, blue: 0.878, alpha: 1.000)
        let gradientColor2 = UIColor(red: 0.314, green: 0.365, blue: 0.890, alpha: 1.000)
        
        let lightBlue = UIColor(red: 0.188, green: 0.137, blue: 0.682, alpha: 1.000)
        let darkBlue = UIColor(red: 0.788, green: 0.427, blue: 0.847, alpha: 1.000)
        //let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [lightBlue.cgColor, darkBlue.cgColor] as CFArray, locations: [0, 1])!
        
        
        //// Gradient Declarations
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [gradientColor2.cgColor, gradientColor.cgColor] as CFArray, locations: [0, 1])!
                
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        context?.saveGState()
        rectanglePath.addClip()
        context?.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: self.frame.width, y: self.frame.height), options: CGGradientDrawingOptions())
        context?.restoreGState()
    }
}
