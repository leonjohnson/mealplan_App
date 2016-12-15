import UIKit
import RealmSwift
import JSQMessagesViewController
import JSQSystemSoundPlayer

final class BotController: JSQMessagesViewController, OutgoingCellDelegate, BotDelegate, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var messages:[JSQMessage] = [JSQMessage]();
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var customOutgoingMediaCellIdentifier : String = ""
    var miniCellViewController = miniTableViewCell()
    var outCellViewController = outCells()
    
    var questionIndex : Int = 0
    
    enum botTypeEnum {
        case unstated
        case addNewFood
        case feedback // Used when creating Bot page to provide it with some context of task.
    }
    var botType : botTypeEnum = .unstated
    var questions : [String] = BotData.NEW_FOOD.questions
    var options : [[String]] = BotData.NEW_FOOD.options
    var buttonText : [String] = BotData.NEW_FOOD.buttonText
    var answers : [[String]] = BotData.NEW_FOOD.answers
    var validationType : [Constants.botValidationEntryType] = BotData.NEW_FOOD.validationType
    
    
    
    /*
    var questions : [String] = [
        Constants.BOT_NEW_FOOD.name.question,
        Constants.BOT_NEW_FOOD.producer.question,
        Constants.BOT_NEW_FOOD.serving_type.question,
        Constants.BOT_NEW_FOOD.calories.question,
        Constants.BOT_NEW_FOOD.fat.question,
        Constants.BOT_NEW_FOOD.saturated_fat.question,
        Constants.BOT_NEW_FOOD.carbohydrates.question,
        Constants.BOT_NEW_FOOD.sugar.question,
        Constants.BOT_NEW_FOOD.fibre.question,
        Constants.BOT_NEW_FOOD.protein.question,
        Constants.BOT_NEW_FOOD.food_type.question,
        Constants.BOT_NEW_FOOD.done.question]

    var options : [[String]] = [
        Constants.BOT_NEW_FOOD.name.tableViewList,
        Constants.BOT_NEW_FOOD.producer.tableViewList,
        Constants.BOT_NEW_FOOD.serving_type.tableViewList,
        Constants.BOT_NEW_FOOD.calories.tableViewList,
        Constants.BOT_NEW_FOOD.fat.tableViewList,
        Constants.BOT_NEW_FOOD.saturated_fat.tableViewList,
        Constants.BOT_NEW_FOOD.carbohydrates.tableViewList,
        Constants.BOT_NEW_FOOD.sugar.tableViewList,
        Constants.BOT_NEW_FOOD.fibre.tableViewList,
        Constants.BOT_NEW_FOOD.protein.tableViewList,
        Constants.BOT_NEW_FOOD.food_type.tableViewList,
        Constants.BOT_NEW_FOOD.done.tableViewList]
    
    

    var answers : [[String]] = [
        [String()],
        [String()],
        [String()],
        [String()],
        [String()],
        [String()],
        [String()],
        [String()],
        [String()],
        [String()],
        [String()],
        [String()]]
    
    let validationType  = [
        Constants.BOT_NEW_FOOD.name.validation,
        Constants.BOT_NEW_FOOD.producer.validation,
        Constants.BOT_NEW_FOOD.serving_type.validation,
        Constants.BOT_NEW_FOOD.calories.validation,
        Constants.BOT_NEW_FOOD.fat.validation,
        Constants.BOT_NEW_FOOD.saturated_fat.validation,
        Constants.BOT_NEW_FOOD.carbohydrates.validation,
        Constants.BOT_NEW_FOOD.sugar.validation,
        Constants.BOT_NEW_FOOD.fibre.validation,
        Constants.BOT_NEW_FOOD.protein.validation,
        Constants.BOT_NEW_FOOD.food_type.validation,
        Constants.BOT_NEW_FOOD.done.validation]
    */
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.toolbar.isHidden = false
        self.navigationController?.toolbar.isUserInteractionEnabled = false
        self.inputToolbar.contentView.textView.autocorrectionType = .no
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        if (self.isMovingFromParentViewController){
            // Your code...
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the data
        switch botType {
        case .addNewFood:
            questions = BotData.NEW_FOOD.questions
            options = BotData.NEW_FOOD.options
            answers = BotData.NEW_FOOD.answers
            validationType = BotData.NEW_FOOD.validationType
        case .feedback:
            questions = BotData.FEEDBACK.questions
            options = BotData.FEEDBACK.options
            answers = BotData.FEEDBACK.answers
            validationType = BotData.FEEDBACK.validationType
        default:
            print("no bot type sent")
            return
        }
        
        
        self.automaticallyScrollsToMostRecentMessage = true
        self.collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
        //self.outgoingCellIdentifier = outCells.cellReuseIdentifier()
        self.collectionView.register(UINib(nibName: "outCell", bundle: nil), forCellWithReuseIdentifier: "out")
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.collectionViewLayout.messageBubbleFont = UIFont(name: "Helvetica Neue", size: 13)
        
        
        // MARK: ### SET SEND BUTTON AS IMAGE
        let rightButton = UIButton(frame: CGRect.zero)
        let sendImage = UIImage(named: "Sent")
        rightButton.setImage(sendImage, for: UIControlState.normal)
        self.inputToolbar.contentView?.rightBarButtonItemWidth = CGFloat(34.0)
        self.inputToolbar.contentView?.rightBarButtonItem = rightButton
        
        
        // MARK: ### DISABLE COPY/PASTE
        // 1. add gesture recognizer to know when text view is tapped
        // 2. add blocking view after 0.7 sec
        // 3. all other methods like subclassing UITextView and using categories to not work
        let tap = UITapGestureRecognizer(target: self, action:  #selector(BotController.handleTap))
        tap.delegate = self
        self.inputToolbar.contentView?.textView?.addGestureRecognizer(tap)
    
 
        
        
        let user = DataHandler.getActiveUser()
        self.senderId = user.name
        self.senderDisplayName = user.name
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        //self.inputToolbar.contentView.leftBarButtonItem = nil
        miniCellViewController.outgoingCellDelegate = self
        outCellViewController.botDelegate = self
        
        
        questions[0] = "Hey \(user.name)! What is the full name of the food?"
        addMessage(withId: Constants.BOT_NAME, name: "\(Constants.BOT_NAME)", text: questions[questionIndex])
        /*
         let image = UIImage(named: "Intro1")
         let photo = JSQPhotoMediaItem(image: image)
         let message2 = JSQMessage(senderId: "121", displayName: "Leon", media: photo)
         messages.append(message2!)
         */
        
        self.finishSendingMessage(animated: true);
    }

    func originalrowSelected(labelValue: String, withQuestion: String, addOrDelete:UITableViewCellAccessoryType) {
        
        guard var indexForAnswer = questions.index(of: withQuestion) else {
            print("WIRING ERROR")
            return
        }
        
        var entryValue = labelValue
        indexForAnswer = questions.index(of: withQuestion)!
        if addOrDelete == UITableViewCellAccessoryType.none{
            answers[indexForAnswer].removeObject(labelValue)
        }
        if addOrDelete == UITableViewCellAccessoryType.checkmark{
            
            
            if withQuestion == BotData.NEW_FOOD.food_type.question{
                let indexOfSelectedOptionInFoodTypeList = BotData.NEW_FOOD.food_type.tableViewList.index(of: labelValue)
                entryValue = Constants.FOOD_TYPES[indexOfSelectedOptionInFoodTypeList!]
            }
            answers[indexForAnswer].append(entryValue)
            answers[indexForAnswer].removeFirst()
        }
        print("Operation = \(addOrDelete))")
        
        if questionIndex == indexForAnswer{
            // we've tapped a row in a table that is the answer to the most progressed question yet
            progressToNextQuestion()
        }
        
    }
    
    
    

    /*
    // MARK: - DELEGATE METHODS
    */
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        if let message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text) {
            if validateAnswer() == true{
                addMessage(withId: self.senderId, name: "t", text: text)
            } else {
                print("Not a valid answer")
            }
            
            if message.text.localizedLowercase.contains("go back") && messages.count > 3{
                addMessage(withId: "foo", name: Constants.BOT_NAME, text: "OK")
                questionIndex -= 1
                let nextQuestion = questions[questionIndex]
                addMessage(withId: "foo", name: Constants.BOT_NAME, text: nextQuestion)
                self.finishSendingMessage(animated: true);
                return
            }
            
            answers[questionIndex].append(text)
            answers[questionIndex].removeFirst()
        }
        progressToNextQuestion()
        
        // MARK: ### PLAY SOUND FOR SENT MESSAGE
        // 1. add JSQSystemSoundPlayer pod
        // 2. add JSQSystemSoundPlayer+JSQMessages.h category
        // 3. add bridging header to use this category
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
    }
    
    
    func progressToNextQuestion(){
        questionIndex += 1
        let nextQuestion = questions[questionIndex]
        addMessage(withId: "foo", name: Constants.BOT_NAME, text: nextQuestion)
        self.finishSendingMessage(animated: true)
        
        if questionIndex == (questions.count-1) {
            switch botType {
            case .addNewFood:
                createNewFoodFromConversation()
            case .feedback:
                saveFeedbackForTheWeek()
            case .unstated:
                print("this bot type is unknown")
                return
            }
            takeUserToMealPlan() // just posted the last response
        }
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let currentKeyboard = self.inputToolbar.contentView.textView.keyboardType
        let newKeyboard = (currentKeyboard == .default) ? UIKeyboardType.decimalPad : UIKeyboardType.default
        self.inputToolbar.contentView.textView.resignFirstResponder()
        self.inputToolbar.contentView.textView.keyboardType = newKeyboard
        self.inputToolbar.contentView.textView.becomeFirstResponder()
        
    }
    
    func rowSelected(labelValue: String, withQuestion: String, addOrDelete:UITableViewCellAccessoryType){
        print("row \(labelValue) selected in the outGoing cell")
    }
    
    private func validateAnswer()->Bool{
        return true
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
   private func addMessage(withId id: String, name: String, media: JSQMessageMediaData) {
        if let message = JSQMessage(senderId: id, displayName: name, media: media) {
            messages.append(message)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return messages.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        var row = indexPath.row
        if (indexPath.row % 2) != 0{
            row = indexPath.row + 1
        }
        let message = messages[indexPath.item]
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if Constants.questionsThatRequireTableViews.contains(message.text!) {
            
            let tableViewRowData = options[row/2]
            let cellWithTableview = collectionView.dequeueReusableCell(withReuseIdentifier: "out", for: indexPath) as! outCells
            //cellWithTableview.table.delegate = self
            
            cellWithTableview.question = message.text
            cellWithTableview.questionTextView?.attributedText = NSAttributedString(string: message.text, attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_WHITE])
            cellWithTableview.data.question = message.text
            cellWithTableview.data.options = tableViewRowData
            cellWithTableview.table.reloadData()
            cellWithTableview.messageBubbleImageView.image = incomingBubbleImageView.messageBubbleImage
            cellWithTableview.botDelegate = self
            return cellWithTableview
        }
        
        
        if Constants.questionsThatRequireButtons.contains(message.text!) {
            let cellWithButton = collectionView.dequeueReusableCell(withReuseIdentifier: "button", for: indexPath) as! BotCellWithButton
            cellWithButton.button.titleLabel?.text = buttonText[row/2]
            cellWithButton.botDelegate = self
            cellWithButton.messageBubbleImageView.image = incomingBubbleImageView.messageBubbleImage
            cellWithButton.questionTextView?.attributedText = NSAttributedString(string: message.text, attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_WHITE])
        }
        
        return cell
    }
    
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item];
    }
    
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId
        {
            return outgoingBubbleImageView
        }
        else {
            print("\(outgoingBubbleImageView.messageBubbleImage)")
            return incomingBubbleImageView
        }
    }
    
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    override func scrollToBottom(animated: Bool) {
        if self.collectionView.numberOfSections == 0{
            return
        }
        let lastCell = IndexPath(item: self.collectionView.numberOfItems(inSection: 0)-1, section: 0)
        self.scroll(to: lastCell as IndexPath!, animated: true)
    }
    
    
    
    /*
     - (void)scrollToBottomAnimated:(BOOL)animated
     {
     if ([self.collectionView numberOfSections] == 0) {
     return;
     }
     
     NSIndexPath *lastCell = [NSIndexPath indexPathForItem:([self.collectionView numberOfItemsInSection:0] - 1) inSection:0];
     [self scrollToIndexPath:lastCell animated:animated];

 
    */
    
    
    
    
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        }
    
    
    private func saveFeedbackForTheWeek(){
        if let weekJustFinished = Week().lastWeek().first{
            weekJustFinished.feedback?.weightMeasurement = 0.0
            weekJustFinished.feedback?.weightUnit = Constants.KILOGRAMS
            weekJustFinished.feedback?.hungerLevels = ""
        }
        takeUserToMealPlan()
    }
    
    func takeUserToMealPlan(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.takeUserToMealPlan(shouldShowExplainerScreen: false)
    }
        
    private func createNewFoodFromConversation(){
        
        
        let food = Food()
        if let pk = DataHandler.getNewPKForFood() {
            food.pk = pk
        }
        
        //["item", "pot", "slice", "cup", "tablet", "heaped teaspoon", "pinch", "100ml", "100g"]
        
        let foodNameIndex = 0
        let foodName : String = answers[foodNameIndex].first!
        food.name = foodName
        
        if let foodProducerIndex = questions.index(of: BotData.NEW_FOOD.producer.question) {
            food.producer = answers[foodProducerIndex].first!
        }

        
        if let servingTypeIndex = questions.index(of: BotData.NEW_FOOD.serving_type.question) {
            var servingSizeName = answers[servingTypeIndex].first!
            if servingSizeName.contains("Item"){
                servingSizeName = Constants.item
            }
            food.servingSize = ServingSize.get(servingSizeName)
        }
        
        
        if let caloriesIndex = questions.index(of: BotData.NEW_FOOD.calories.question) {
            print("\(answers[caloriesIndex])")
            food.calories = Double(answers[caloriesIndex].first!)!
        }
        
        
        if let fatsIndex = questions.index(of: BotData.NEW_FOOD.fat.question) {
            food.fats = Double(answers[fatsIndex].first!)!
        }
        
        
        if let satFatsIndex = questions.index(of: BotData.NEW_FOOD.fat.question) {
            if let satFats = Double(answers[satFatsIndex].first!) {
                food.sat_fats = RealmOptional<Double>(satFats)
            }
        }
        
        
        if let carbIndex = questions.index(of: BotData.NEW_FOOD.carbohydrates.question) {
            food.carbohydrates = Double(answers[carbIndex].first!)!
        }
        
        
        
        if let sugarIndex = questions.index(of: BotData.NEW_FOOD.sugar.question) {
            if let sugar = Double(answers[sugarIndex].first!) {
                food.sugars = RealmOptional<Double>(sugar)
            }
        }
        
        
        if let fibreIndex = questions.index(of: BotData.NEW_FOOD.fibre.question){
            if let fibre = Double(answers[fibreIndex].first!){
                food.fibre = RealmOptional<Double>(fibre)
            }
        }
        
        
        if let proteinIndex = questions.index(of: BotData.NEW_FOOD.protein.question){
            if let proteins = Double(answers[proteinIndex].first!){
                food.proteins = proteins
            }
        }
        
        
        if let foodTypeIndex = questions.index(of: BotData.NEW_FOOD.food_type.question){
            let realm = try! Realm()
            let foodTypesSelected = answers[foodTypeIndex]
            print("foodTypesSelected: \(foodTypesSelected)")
            let foodTypesFound = realm.objects(FoodType.self).filter("name IN %@", foodTypesSelected)
            print("realm objects found: \(foodTypesFound)")
            food.foodType.append(contentsOf: foodTypesFound)
        }
        
        print("Food I want to create: \(food)")
        
        _ = DataHandler.createFood(food)
        
        
        
        /*
         
         if let value = (pdt!.value(forKey: "dietSuitability") as! NSArray?){
         let realm = try! Realm()
         let ds = realm.objects(DietSuitability).filter("name IN %@", value)
         for each in ds {
         itemFood.dietSuitability.append(each)
         }
         }
         
         
         if (pdt!.value(forKey: "readyToEat") as! Bool?)! == true{
         itemFood.readyToEat = true
         } else if (pdt!.value(forKey: "readyToEat") as! Bool?)! == false {
         itemFood.readyToEat = false
         }
         */
        
        
    }
    
    
    
    
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("letter tapped\n:\(textView.text) and: \(textView.text.characters)")
        
        if text.characters.count == 0 {
            return true //if the delete key is pressed then length of the text variable is not increase so return true
        }
        switch validationType[questionIndex] {
        case  Constants.botValidationEntryType.text:
            return text.isDecimal() ? false : true
            
        case  Constants.botValidationEntryType.decimal:
            return text.isDecimal() ? true : false
            
        case  Constants.botValidationEntryType.none:
            return text.isDecimal() ? false : true // users should be allowed to type in 'go back' even though the keyboard will be minimised.
        }
    }

    // MARK - UIGestureRecognizerDelegate
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        print(#function)
        self.perform(#selector(BotController.disableEditing), with: nil, afterDelay: 0.7)
    }
    
    func disableEditing() {
        let blockView = UIView(frame: CGRect(x: (self.inputToolbar.contentView?.textView?.frame.origin.x)!, y: (self.inputToolbar.contentView?.textView?.frame.origin.y)!, width: (self.inputToolbar.contentView?.textView?.frame.size.width)!, height: (self.inputToolbar.contentView?.textView?.frame.size.height)!))
        blockView.backgroundColor = .clear
        blockView.isUserInteractionEnabled = true
        self.inputToolbar.contentView?.addSubview(blockView)
    }
    
    


}
    

