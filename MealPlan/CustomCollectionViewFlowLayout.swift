import UIKit
import JSQMessagesViewController

class CustomCollectionViewFlowLayout: JSQMessagesCollectionViewFlowLayout {
    
    var incomingBubbleMask = UIImageView()
    
    override func messageBubbleSizeForItem(at indexPath: IndexPath!) -> CGSize {
        /*
         CGSize superSize = [super messageBubbleSizeForItemAtIndexPath:indexPath];
         
         JSQMessage *currentMessage = (JSQMessage *)[self.collectionView.dataSource collectionView:self.collectionView messageDataForItemAtIndexPath:indexPath];
         
         /*********** Setting size **************/
         //check if outgoing, you can import your Session Manager to check your user identifier
         if ([currentMessage.senderId isEqualToString:@"me") {
         superSize = CGSizeMake(175, superSize.height);
         }
         //do whatever other checks and setup your width/height accordingly
         
         return superSize;
         */
        
        var superSize = super.messageBubbleSizeForItem(at: indexPath)
        let currentMessage = self.collectionView.dataSource.collectionView(self.collectionView, messageDataForItemAt: indexPath)
        
        superSize.height = 400
        print("returning 4000000")
        return superSize
        
    }

}
