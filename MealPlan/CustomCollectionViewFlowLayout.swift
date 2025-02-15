import UIKit
import JSQMessagesViewController

class CustomCollectionViewFlowLayout: JSQMessagesCollectionViewFlowLayout {
    
    var incomingBubbleMask = UIImageView()
    
    
    
    override func messageBubbleSizeForItem(at indexPath: IndexPath!) -> CGSize {
        
        var superSize = super.messageBubbleSizeForItem(at: indexPath)
        let currentMessageText = self.collectionView.dataSource.collectionView(self.collectionView, messageDataForItemAt: indexPath).text!()
        

        //let op = ox?.collectionView(self.collectionView, cellForItemAt: indexPath) as! outCells
        

        if Constants.questionsThatRequireTableViews.contains(currentMessageText!){
            
            let rows = (4 * 45) + (4*23)
            superSize.height = CGFloat(rows)
            //superSize.width = superSize.width
            return superSize
 
        }
        
        return superSize
        
    }
    
    
    
    
    /*
     
     
     
     - (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
     {
     CGSize messageBubbleSize = [self messageBubbleSizeForItemAtIndexPath:indexPath];
     JSQMessagesCollectionViewLayoutAttributes *attributes = (JSQMessagesCollectionViewLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:indexPath];
     
     CGFloat finalHeight = messageBubbleSize.height;
     finalHeight += attributes.cellTopLabelHeight;
     finalHeight += attributes.messageBubbleTopLabelHeight;
     finalHeight += attributes.cellBottomLabelHeight;
     
     return CGSizeMake(self.itemWidth, ceilf(finalHeight));
     }
 
 
 
    */

}
