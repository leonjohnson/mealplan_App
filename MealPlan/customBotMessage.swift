import UIKit
import JSQMessagesViewController

class customBotMessage: NSObject, JSQMessageMediaData {
    
    @objc func mediaView() -> UIView! {
        let mediaView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21)) // CGFloat, Double, Int)
        label.center = CGPoint(x: 160,y :284)
        label.textAlignment = NSTextAlignment.center
        label.text = "I'am a test label"
        label.backgroundColor = UIColor.black
        mediaView.addSubview(label)
        return mediaView
    }
    
    @objc func mediaViewDisplaySize() -> CGSize {
        let size = CGSize(width: 100, height: 21)
        return size
    }
    
    
   @objc func mediaPlaceholderView() -> UIView! {
        return nil
    }
    
    @objc func mediaHash() -> UInt {
        //return super.hash// ^ self.image.hash
        return UInt(self.hash)
    }
    
}
