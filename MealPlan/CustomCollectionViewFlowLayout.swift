import UIKit
import JSQMessagesViewController

class CustomCollectionViewFlowLayout: JSQMessagesCollectionViewFlowLayout {
    
    var incomingBubbleMask = UIImageView()
    
    
    
    override func messageBubbleSizeForItem(at indexPath: IndexPath!) -> CGSize {
        
        var superSize = super.messageBubbleSizeForItem(at: indexPath)
        let currentMessageText = self.collectionView.dataSource.collectionView(self.collectionView, messageDataForItemAt: indexPath).text!()
        
        var questionIndex = 0
        var options : [[String]] = []
        var buttonText : [String?] = []
        
        if BotData.NEW_FOOD.questions.contains(currentMessageText!){
            questionIndex = BotData.NEW_FOOD.questions.index(of: currentMessageText!)!
            options = BotData.NEW_FOOD.options
        }
        if BotData.FEEDBACK.questions.contains(currentMessageText!){
            questionIndex = BotData.FEEDBACK.questions.index(of: currentMessageText!)!
            options = BotData.FEEDBACK.options
            buttonText = BotData.FEEDBACK.buttonText
        }
        if BotData.ONBOARD.questions.contains(currentMessageText!){
            questionIndex = BotData.ONBOARD.questions.index(of: currentMessageText!)!
            options = BotData.ONBOARD.options
        }
        
        /*
        let weekNumber = SetUpMealPlan.getThisWeekAndNext().first?.number
        if currentMessageText == BotData.FEEDBACK.firstWeekNotice.question && (weekNumber == 2) {
            print("before : \(questionIndex)")
            questionIndex = questionIndex + 1
            print("after collection : \(questionIndex)")
        }
 */
        
        /*
        let constraintRect = CGSize(width: superSize.width, height: .greatestFiniteMagnitude)
        let botLeading : NSMutableParagraphStyle = NSMutableParagraphStyle()
        botLeading.lineSpacing = 9.33
        let attString = NSAttributedString(string: currentMessageText!, attributes: [
            NSParagraphStyleAttributeName:botLeading,
            NSFontAttributeName:Constants.STANDARD_FONT])
        let boundingBox = attString.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        print("\(superSize.height) vs. \(boundingBox.height)")
        if superSize.height < boundingBox.height {
            superSize.height = boundingBox.height + 60
            print("width of this bubble: \(superSize.width)")
        }
        */
        

        //let op = ox?.collectionView(self.collectionView, cellForItemAt: indexPath) as! outCells
        

        if Constants.questionsThatRequireTableViews.contains(currentMessageText!){
            let numRows = options[questionIndex].count
            let rows = (Double(Constants.TABLE_ROW_HEIGHT_SMALL) * Double(numRows + 2))
            superSize.height = CGFloat(rows)
            superSize.width = superSize.width + 40
            return superSize
        }
        
        if Constants.questionsThatRequireButtons.contains(currentMessageText!){
            let constraintRect = CGSize(width: superSize.width, height: .greatestFiniteMagnitude)
            let attString = NSAttributedString(string: currentMessageText!, attributes: [NSFontAttributeName: Constants.STANDARD_FONT])
            let boundingBox = attString.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
            
            
            let buttonAttString = NSAttributedString(string: buttonText[questionIndex]!, attributes: [NSFontAttributeName: Constants.STANDARD_FONT])
            let buttonBoundingBox = buttonAttString.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
            
            superSize.height = 160
            superSize.width = (boundingBox.width > buttonBoundingBox.width) ? boundingBox.width : buttonBoundingBox.width
            superSize.width = superSize.width + 20
            //superSize.width = superSize.width + 40
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
