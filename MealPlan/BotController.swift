import UIKit
import RealmSwift
import JSQMessagesViewController

final class BotController: JSQMessagesViewController, OutgoingCellDelegate, BotDelegate, UITableViewDelegate {
    
    var messages:[JSQMessage] = [JSQMessage]();
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var reasonForContact :String = String()
    
    static let NAME = "Hi! What is the full name of the food?"
    
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
    
    

    var answers : [String] = [
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""]
    
    let keyboardType : [String:String] = [:]
    var questionIndex : Int = 0
    
    enum botTypeEnum {
        case addNewFood
    }
    var botType : botTypeEnum = .addNewFood
    
    var tapped = Int()
    
    var customOutgoingMediaCellIdentifier : String = ""
    
    var miniCellViewController = miniTableViewCell()
    
    var outCellViewController = outCells()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.toolbar.isHidden = false
        print("viewWillAppear got title of : \(self.navigationController?.navigationItem.backBarButtonItem?.title)\n")
        
    }
    
    
    
    
    
    
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController){
            // Your code...
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
        
        
    }
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("viewDidLoad got title of : \(self.navigationController?.navigationItem.backBarButtonItem?.title)\n")
        
        self.automaticallyScrollsToMostRecentMessage = true
        self.collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
        //self.outgoingCellIdentifier = outCells.cellReuseIdentifier()
        self.collectionView.register(UINib(nibName: "outCell", bundle: nil), forCellWithReuseIdentifier: "out")
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.collectionViewLayout.messageBubbleFont = UIFont(name: "Helvetica Neue", size: 13)
        
        
        
        let user = DataHandler.getActiveUser()
        self.senderId = user.name
        self.senderDisplayName = user.name
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        //self.inputToolbar.contentView.leftBarButtonItem = nil
        questions[0] = "Hey \(user.name)! What is the full name of the food?"
        addMessage(withId: Constants.BOT_NAME, name: "\(Constants.BOT_NAME)", text: questions[questionIndex])

        
        /*
        let image = UIImage(named: "Intro1")
        let photo = JSQPhotoMediaItem(image: image)
        let message2 = JSQMessage(senderId: "121", displayName: "Leon", media: photo)
        messages.append(message2!)
         */
        
        miniCellViewController.outgoingCellDelegate = self
        
        outCellViewController.botDelegate = self
        
        
        self.finishSendingMessage(animated: true);
    }

    func originalrowSelected(labelValue: String, withQuestion: String) {
        
        guard var indexForAnswer = questions.index(of: withQuestion) else {
            print("WIRING ERROR")
            return
        }
        indexForAnswer = questions.index(of: withQuestion)!
        answers[indexForAnswer] = labelValue
        
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
            
            answers[questionIndex] = text
        }
        
        questionIndex += 1
        let nextQuestion = questions[questionIndex]
        addMessage(withId: "foo", name: Constants.BOT_NAME, text: nextQuestion)
        self.finishSendingMessage(animated: true)
        
        if questionIndex == (questions.count-1){
            // just posted the last response
            //takeUserBackToMealPlan()
            createNewFoodFromConversation()
            
        }
    }
    
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let currentKeyboard = self.inputToolbar.contentView.textView.keyboardType
        let newKeyboard = (currentKeyboard == .default) ? UIKeyboardType.decimalPad : UIKeyboardType.default
        self.inputToolbar.contentView.textView.resignFirstResponder()
        self.inputToolbar.contentView.textView.keyboardType = newKeyboard
        self.inputToolbar.contentView.textView.becomeFirstResponder()
        
    }
    
    func rowSelected(labelValue: String, withQuestion: String){
        print("row \(labelValue) selected in the outGoing cell")
        
    }
    
    private func takeUserBackToMealPlan(){
        
        
        let index = self.navigationController?.viewControllers.index(of: self)
        let mealplanViewController = self.navigationController?.viewControllers[index!-2]
        self.navigationController?.popToViewController(mealplanViewController!, animated: true)
        
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let message = messages[indexPath.item]
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        
        if Constants.questionsThatRequireTableViews.contains(message.text!) {
            
            //print("row num == \(indexPath)")
            let tableViewRowData = options[indexPath.row/2]
            //print("Question: \(message.text) and options: \(options[questionIndex])/n")
            let cellWithTableview = collectionView.dequeueReusableCell(withReuseIdentifier: "out", for: indexPath) as! outCells
            //cellWithTableview.table.delegate = self
            
            cellWithTableview.question = message.text
            cellWithTableview.questionTextView.attributedText = NSAttributedString(string: message.text, attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_WHITE])
            cellWithTableview.data.question = message.text
            cellWithTableview.data.options = tableViewRowData
            cellWithTableview.table.reloadData()
            cellWithTableview.questionTextView.sizeToFit()
            cellWithTableview.messageBubbleImageView.image = incomingBubbleImageView.messageBubbleImage
            
            cellWithTableview.botDelegate = self
            
            return cellWithTableview
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
    
    
    /*
     // MARK: - CREATE NEW FOODS
     */
    private func createNewFoodFromConversation(){
        
        
        let food = Food()
        if let pk = DataHandler.getNewPKForFood() {
            food.pk = pk
        }
        
        //["item", "pot", "slice", "cup", "tablet", "heaped teaspoon", "pinch", "100ml", "100g"]
        
        let foodNameIndex = 0
        let foodName : String = answers[1]
        food.name = foodName
        
        if let foodProducerIndex = questions.index(of: Constants.BOT_NEW_FOOD.producer.question) {
            food.producer = answers[foodProducerIndex]
        }

        
        if let servingTypeIndex = questions.index(of: Constants.BOT_NEW_FOOD.serving_type.question) {
            var servingSizeName = answers[servingTypeIndex]
            if servingSizeName.contains("Item"){
                servingSizeName = Constants.item
            }
            food.servingSize = ServingSize.get(servingSizeName)
        }
        
        
        if let caloriesIndex = questions.index(of: Constants.BOT_NEW_FOOD.calories.question) {
            food.calories = Double(answers[caloriesIndex])!
        }
        
        
        if let fatsIndex = questions.index(of: Constants.BOT_NEW_FOOD.fat.question) {
            food.fats = Double(answers[fatsIndex])!
        }
        
        if let satFatsIndex = questions.index(of: Constants.BOT_NEW_FOOD.fat.question) {
            food.sat_fats = RealmOptional<Double>(answers[satFatsIndex])
        }
        
        let satFatsIndex = questions.index(of: Constants.BOT_NEW_FOOD.saturated_fat.question)
        if let satFats = Double(messages[(satFatsIndex!*2)+1].text) {
            food.sat_fats = RealmOptional<Double>(satFats)
        }
        
        let carbIndex = questions.index(of: Constants.BOT_NEW_FOOD.carbohydrates.question)
        if let carbs = Double(messages[(carbIndex!*2)+1].text) {
            food.carbohydrates = carbs
        }
        
        let sugarIndex = questions.index(of: Constants.BOT_NEW_FOOD.sugar.question)
        if let sugar = Double(messages[(sugarIndex!*2)+1].text) {
            food.sugars = RealmOptional<Double>(sugar)
        }
        
        let fibreIndex = questions.index(of: Constants.BOT_NEW_FOOD.fibre.question)
        if let fibre = Double(messages[(fibreIndex!*2)+1].text) {
            food.fibre = RealmOptional<Double>(fibre)
        }
        
        let proteinIndex = questions.index(of: Constants.BOT_NEW_FOOD.protein.question)
        if let proteins = Double(messages[(proteinIndex!*2)+1].text) {
            food.proteins = proteins
        }
        
        let foodTypeIndex = questions.index(of: Constants.BOT_NEW_FOOD.food_type.question)
        if let foodType = messages[(foodTypeIndex!*2)+1].text {
            var valuesEntered = foodType.components(separatedBy: .init(charactersIn: ",.- "))
            valuesEntered = valuesEntered.filter { $0 != "" }
            var newValues : String = String()
            let realm = try! Realm()
            for index in valuesEntered{
                let ix = Constants.FOOD_TYPES[Int(index)!]
                newValues.append(ix)
            }
            let ft = realm.objects(FoodType).filter("name IN %@", valuesEntered)
            for each in ft {
                food.foodType.append(each)
            }
        }
        
        let created = DataHandler.createFood(food)
        
        
        
        /*
         
         if let value = (pdt!.value(forKey: "dietSuitablity") as! NSArray?){
         let realm = try! Realm()
         let ds = realm.objects(DietSuitability).filter("name IN %@", value)
         for each in ds {
         itemFood.dietSuitablity.append(each)
         }
         }
         
         if let value = (pdt!.value(forKey: "foodType") as! NSArray?){
         let realm = try! Realm()
         let ft = realm.objects(FoodType).filter("name IN %@", value)
         for each in ft {
         itemFood.foodType.append(each)
         }
         }
         
         if (pdt!.value(forKey: "readyToEat") as! Bool?)! == true{
         itemFood.readyToEat = true
         } else if (pdt!.value(forKey: "readyToEat") as! Bool?)! == false {
         itemFood.readyToEat = false
         }
         */
        
        
    }
    
    
    



}
    

