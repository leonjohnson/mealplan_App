import UIKit
import JSQMessagesViewController

class CustomCollectionViewFlowLayout: JSQMessagesCollectionViewFlowLayout {
    
    var incomingBubbleMask = UIImageView()
    
    override func messageBubbleSizeForItem(at indexPath: IndexPath!) -> CGSize {
        
        var superSize = super.messageBubbleSizeForItem(at: indexPath)
        let currentMessageText = self.collectionView.dataSource.collectionView(self.collectionView, messageDataForItemAt: indexPath).text!()

        if Constants.questionsThatRequireTableViews.contains(currentMessageText!){
            superSize.height = 400
            print("returning 4000000")
            return superSize
        }
        
        return superSize
        
    }

}
