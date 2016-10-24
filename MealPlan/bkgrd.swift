import UIKit

class bkgrd: UIView
{
    override func drawRect(rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        //// Color Declarations
        let gradientColor = UIColor(red: 0.000, green: 0.647, blue: 0.878, alpha: 1.000)
        let gradientColor2 = UIColor(red: 0.314, green: 0.365, blue: 0.890, alpha: 1.000)
        
        //// Gradient Declarations
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [gradientColor2.CGColor, gradientColor.CGColor], [0, 1])!
                
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 320, height: 568))
        CGContextSaveGState(context)
        rectanglePath.addClip()
        CGContextDrawLinearGradient(context, gradient, CGPoint(x: 160, y: -0), CGPoint(x: 160, y: 568), CGGradientDrawingOptions())
        CGContextRestoreGState(context)
    }
}
