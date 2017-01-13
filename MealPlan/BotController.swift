import UIKit
import RealmSwift
import JSQMessagesViewController
import JSQSystemSoundPlayer
import FacebookCore

final class BotController: JSQMessagesViewController, BotDelegate, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var messages:[JSQMessage] = [JSQMessage]();
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var customOutgoingMediaCellIdentifier : String = ""
    var miniCellViewController = miniTableViewCell()
    var inComingCellViewController = inCell()
    
    var questionIndex : Int = 0
    
    enum botTypeEnum {
        case unstated
        case addNewFood
        case feedback // Used when creating Bot page to provide it with some context of task.
    }
    
    enum explainerScreenType {
        case none
        case congratulations
        case startingOver // Used when creating Bot page to provide it with some context of task.
    }
    var botType : botTypeEnum = .unstated
    var questions : [String] = BotData.NEW_FOOD.questions
    var options : [[String]] = BotData.NEW_FOOD.options
    var buttonText : [String] = BotData.NEW_FOOD.buttonText
    var answers : [[String]] = BotData.NEW_FOOD.answers
    var validationType : [Constants.botValidationEntryType] = BotData.NEW_FOOD.validationType
    var sideButton : UIButton?
    
    var meal : Meal? = Meal()
    var returningCustomer : Bool? = Bool()
    
    var mealPlanExistsForThisWeek : (yayNay:Bool, weeksAheadIncludingCurrent:[Week])?
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.toolbar.isHidden = false
        self.navigationController?.toolbar.isUserInteractionEnabled = false
        self.inputToolbar.contentView.textView.autocorrectionType = .no
        self.inputToolbar.contentView.textView.becomeFirstResponder()
        self.collectionView.backgroundColor = Constants.MP_BLUEGREY
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
        let user = DataHandler.getActiveUser()
        let weightUnit = DataHandler.getActiveBiographical().weightUnit
        
        // Load the data
        switch botType {
        case .addNewFood:
            questions = BotData.NEW_FOOD.questions
            questions[0] = "Hey \(user.name)! What is the full name of the food you want to record?"
            options = BotData.NEW_FOOD.options
            answers = BotData.NEW_FOOD.answers
            validationType = BotData.NEW_FOOD.validationType
        case .feedback:
            questions = BotData.FEEDBACK.questions
            questions[0] = "Hey \(user.name)! I'm checking in with you to see how things have been going?\nWhat was your weight this morning (in \(weightUnit)s)?"
            options = BotData.FEEDBACK.options
            answers = BotData.FEEDBACK.answers
            validationType = BotData.FEEDBACK.validationType
        default:
            return
        }
        if botType == .addNewFood{
            
        }
        
        self.automaticallyScrollsToMostRecentMessage = true
        self.collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
        //self.outgoingCellIdentifier = outCells.cellReuseIdentifier()
        self.collectionView.register(UINib(nibName: "inCell", bundle: nil), forCellWithReuseIdentifier: "in")
        self.collectionView.register(UINib(nibName: "outCell", bundle: nil), forCellWithReuseIdentifier: "out")
        self.collectionView.register(UINib(nibName: "BotCellWithButton", bundle: nil), forCellWithReuseIdentifier: "button")
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.collectionViewLayout.messageBubbleFont = Constants.STANDARD_FONT
        
        
        // MARK: ### SET SEND BUTTON AS IMAGE
        /*
        let rightButton = UIButton(frame: CGRect.zero)
        let sendImage = UIImage(named: "Sent")
        rightButton.setImage(sendImage, for: UIControlState.normal)
        self.inputToolbar.contentView?.rightBarButtonItemWidth = CGFloat(34.0)
        self.inputToolbar.contentView?.rightBarButtonItem = rightButton
         */
        
        // MARK: ### SET SEND BUTTON AS IMAGE
        
        
        
        // MARK: ### DISABLE COPY/PASTE
        // 1. add gesture recognizer to know when text view is tapped
        // 2. add blocking view after 0.7 sec
        // 3. all other methods like subclassing UITextView and using categories to not work
        let tap = UITapGestureRecognizer(target: self, action:  #selector(BotController.handleTap))
        tap.delegate = self
        self.inputToolbar.contentView?.textView?.addGestureRecognizer(tap)
        
        
        self.senderId = user.name
        self.senderDisplayName = user.name
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        inComingCellViewController.botDelegate = self
        
        
        //let height = self.inputToolbar.contentView.leftBarButtonContainerView.frame.size.height
        //let image = UIImage(named:"keyboard")
        //sideButton = UIButton(type: .custom)
        //sideButton?.setImage(image, for: .normal)
        //sideButton?.frame = CGRect(x: 0, y: 0, width: (sideButton?.frame.width)!, height: (sideButton?.frame.height)!)
        /*
        sideButton = UIButton()
        sideButton?.imageView?.image = UIImage(named:"keyboard")
        sideButton?.sizeToFit()
         */
        
        
        
        addMessage(withId: Constants.BOT_NAME, name: "\(Constants.BOT_NAME)", text: questions[questionIndex])
        self.finishSendingMessage(animated: true)
        
        
        // Set the keyboard type and icon
        sideButton = UIButton(frame: CGRect.zero)
        var keyBoardImage = UIImage()
        
        switch validationType[0] {
        case .decimal:
            self.inputToolbar.contentView.textView.keyboardType = .decimalPad
            keyBoardImage = UIImage(named: "keyboard_filled")!
        case .text:
            self.inputToolbar.contentView.textView.keyboardType = .default
            keyBoardImage = UIImage(named: "number_keypad")!
        case .none:
            self.inputToolbar.contentView.textView.keyboardType = .default
            keyBoardImage = UIImage(named: "number_keypad")!
        }
        sideButton?.setImage(keyBoardImage, for: UIControlState.normal)
        self.inputToolbar.contentView?.leftBarButtonItemWidth = CGFloat(34.0)
        self.inputToolbar.contentView?.leftBarButtonItem = sideButton
        
        
        
        /*
        sideButton.frame =
         UIImage *image = [UIImage imageNamed:@"smileButton"];
         UIButton* smileButton = [UIButton buttonWithType:UIButtonTypeCustom];
         [smileButton setImage:image forState:UIControlStateNormal];
         [smileButton addTarget:self action:@selector(smileButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
         [smileButton setFrame:CGRectMake(0, 0, 25, height)];
        
         let image = UIImage(named: "Intro1")
         let photo = JSQPhotoMediaItem(image: image)
         let message2 = JSQMessage(senderId: "121", displayName: "Leon", media: photo)
         messages.append(message2!)
         */
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
            print("answers in didpressend: \(answers)")
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
        
        // Set the keyboard type
        if validationType[questionIndex - 1] != validationType[questionIndex]{
            switch validationType[questionIndex] {
            case .decimal:
                self.inputToolbar.contentView.textView.keyboardType = .decimalPad
            case .text:
                self.inputToolbar.contentView.textView.keyboardType = .default
            case .none:
                self.inputToolbar.contentView.textView.keyboardType = .default
            }
            self.inputToolbar.contentView.textView.reloadInputViews()
        }
        
        
    }
    
    func closeConversation(){
        addMessage(withId: Constants.BOT_NAME, name: "\(Constants.BOT_NAME)", text: questions[questionIndex])
        self.finishSendingMessage(animated: true)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let currentKeyboard = self.inputToolbar.contentView.textView.keyboardType
        
        let newKeyboardType = (currentKeyboard == .default) ? UIKeyboardType.decimalPad : UIKeyboardType.default
        //page1Content.imageView.image = UIImage(named:"winner")
        var newKeyboardImage : UIImage = UIImage()
        if currentKeyboard == .decimalPad{
            newKeyboardImage = UIImage(named: "number_keypad")!
            
        }
        if currentKeyboard == .default{
            newKeyboardImage = UIImage(named: "keyboard_filled")!
        }
        
        sideButton?.setImage(newKeyboardImage, for: UIControlState.normal)
        self.inputToolbar.contentView.textView.keyboardType = newKeyboardType
        self.inputToolbar.contentView.textView.reloadInputViews()
    }
    
    func buttonTapped(forQuestion: String) {
        
        if questionIndex == (questions.count-1) {
            switch botType {
            case .addNewFood:
                createNewFoodFromConversation()
            case .feedback:
                saveFeedbackForTheWeek()
            case .unstated:
                return
            }
            takeUserToMealPlan(explainerScreenTypeIs: .none) // just posted the last response
            return
        }
        
        print("question tapped: \(forQuestion)")
        guard let indexForAnswer = questions.index(of: forQuestion) else {
            return
        }
        answers[indexForAnswer].removeAll()
        print("passed")
        progressToNextQuestion()
    }
    
    
    func originalrowSelected(labelValue: String, withQuestion: String, index:IndexPath, addOrDelete:UITableViewCellAccessoryType) {
        
        guard var indexForAnswer = questions.index(of: withQuestion) else {
            return
        }
        
        var entryValue = labelValue
        indexForAnswer = questions.index(of: withQuestion)!
        
        if addOrDelete == UITableViewCellAccessoryType.none{
            answers[indexForAnswer].removeObject(labelValue)
        }
        if addOrDelete == UITableViewCellAccessoryType.checkmark{
            if BotData.NEW_FOOD.food_type.question == withQuestion {
                let indexOfSelectedOptionInFoodTypeList = BotData.NEW_FOOD.food_type.tableViewList.index(of: labelValue)
                entryValue = Constants.FOOD_TYPES[indexOfSelectedOptionInFoodTypeList!]
            }
            
            if BotData.FEEDBACK.easeOfFollowingDiet.question == withQuestion {
                let indexOfSelectedOption = BotData.FEEDBACK.easeOfFollowingDiet.tableViewList.index(of: labelValue)
                entryValue = BotData.FEEDBACK.easeOfFollowingDiet.tableViewList[indexOfSelectedOption!]
            }
            
            if BotData.FEEDBACK.howHungryWereYou.question == withQuestion {
                let indexOfSelectedOption = BotData.FEEDBACK.howHungryWereYou.tableViewList.index(of: labelValue)
                entryValue = BotData.FEEDBACK.howHungryWereYou.tableViewList[indexOfSelectedOption!]
            }
            
            if BotData.FEEDBACK.changeNumberOfMeals.question == withQuestion {
                
            }
            
            answers[indexForAnswer].append(entryValue)
            answers[indexForAnswer].removeFirst()
        }
        
        if questionIndex == indexForAnswer{
            // we've tapped a row in a table that is the answer to the most progressed question yet
            progressToNextQuestion()
        }
    }
    
    /*
    func rowSelected(labelValue: String, withQuestion: String, index: IndexPath, addOrDelete:UITableViewCellAccessoryType){
        print("PING : rowSelected called.")
        
        print("row \(labelValue) selected called from BotController")
        
        if BotData.NEW_FOOD.serving_type.question == withQuestion {
            //serving size table
            let servingSizeType = Constants.servingSizeBotQuestionMapping[withQuestion]
            if let servingSizeTypeIndex = questions.index(of: BotData.NEW_FOOD.serving_type.question){
                if addOrDelete == .checkmark{
                    answers[servingSizeTypeIndex].append(servingSizeType!)
                } else {
                    answers[servingSizeTypeIndex].removeObject(servingSizeType!)
                }
            }
        }
        
        if BotData.NEW_FOOD.food_type.question == withQuestion {
            //food type size table
            let foodType = Constants.foodTypeBotQuestionMapping[withQuestion]
            if let foodTypeIndex = questions.index(of: BotData.NEW_FOOD.food_type.question){
                if addOrDelete == .checkmark{
                    answers[foodTypeIndex].append(foodType!)
                } else {
                    answers[foodTypeIndex].removeObject(foodType!)
                }
            }
        }
        
    }
    */

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

        let message = messages[indexPath.item]
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        cell.textView.textColor = UIColor.black
        
        if Constants.questionsThatRequireTableViews.contains(message.text!) {
            let questionIndex = questions.index(of: message.text)
            let tableViewRowData = options[questionIndex!]
            //let tableViewRowData = options[row/2]
            let cellWithTableview = collectionView.dequeueReusableCell(withReuseIdentifier: "in", for: indexPath) as! inCell
            //cellWithTableview.table.delegate = self
            
            cellWithTableview.question = message.text
            cellWithTableview.questionTextView?.attributedText = NSAttributedString(string: message.text, attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_BLACK])
            cellWithTableview.data.question = message.text
            print("table data: \(tableViewRowData)")
            cellWithTableview.data.options = tableViewRowData
            cellWithTableview.table.reloadData()
            cellWithTableview.messageBubbleImageView.image = incomingBubbleImageView.messageBubbleImage
            cellWithTableview.backgroundColor = UIColor.clear
            cellWithTableview.botDelegate = self
            
            for row in 0...tableViewRowData.count{
                cellWithTableview.table.cellForRow(at: [0,row])?.accessoryType = .none
            }
            var answersIndex : Int = 0
            var answer = answers[questionIndex!].first
            if (answer?.characters.count)! > 0 {
                if message.text == BotData.NEW_FOOD.food_type.question {
                    answersIndex = Constants.FOOD_TYPES.index(of: answer!)!
                } else {
                    answersIndex = Int(tableViewRowData.index(of: answer!)!)
                }
                cellWithTableview.table.cellForRow(at: [0,Int(answersIndex)])?.accessoryType = .checkmark
                print("gonna check this answer")
            }
            
            return cellWithTableview
            
        } else if Constants.questionsThatRequireButtons.contains(message.text!) {
            let cellWithButton = collectionView.dequeueReusableCell(withReuseIdentifier: "button", for: indexPath) as! BotCellWithButton
            cellWithButton.question = message.text
            let questionIndex = questions.index(of: message.text)
            let buttonTitle = buttonText[questionIndex!]
            
            print("button title: \(buttonText)")
            cellWithButton.button.setTitle(buttonTitle, for: .normal)
            cellWithButton.backgroundColor = UIColor.clear
            cellWithButton.botDelegate = self
            cellWithButton.messageBubbleImageView.image = incomingBubbleImageView.messageBubbleImage
            cellWithButton.questionTextView?.attributedText = NSAttributedString(string: message.text, attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_BLACK])
            return cellWithButton
        }
          else {
        }
        
        
        
        return cell
    }
    
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item];
    }
    
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId {
            return outgoingBubbleImageView
        }
        else {
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
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: Constants.MP_WHITE)
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: Constants.MP_GREEN.withAlphaComponent(0.5))
        }
    
    
    private func saveFeedbackForTheWeek(){
        var feedback = FeedBack()
        if let weekJustFinished = Week().lastWeek(){
            // Get the standard measurement
            
            
            feedback.weightUnit = DataHandler.getActiveBiographical().weightUnit
            
            feedback.weightMeasurement = Double(answers[0].first!)!
            // using subscript notation as the text to this question has been changed but I'm confident that it's the first one
            
            if let hungerIndex = questions.index(of: BotData.FEEDBACK.howHungryWereYou.question) {
                feedback.hungerLevels = answers[hungerIndex].first!
            }

            
            if let easeOfFollowingIndex = questions.index(of: BotData.FEEDBACK.easeOfFollowingDiet.question) {

                switch answers[easeOfFollowingIndex].first! {
                
                case Constants.dietEase.easy.rawValue:
                    feedback.easeOfFollowingDiet = Constants.dietEase.easy.rawValue
                
                case Constants.dietEase.hard.rawValue:
                    feedback.easeOfFollowingDiet = Constants.dietEase.hard.rawValue
                
                case Constants.dietEase.ok.rawValue:
                    feedback.easeOfFollowingDiet = Constants.dietEase.ok.rawValue
                
                default:
                    feedback.easeOfFollowingDiet = Constants.dietEase.unstated.rawValue
                }
            }
            
            if let notesIndex = questions.index(of: BotData.FEEDBACK.anyComments.question) {
                feedback.notes = answers[notesIndex].first
            }
            
            DataHandler.updateMealPlanFeedback(weekJustFinished, feedback: feedback)
            DataHandler.updateWeight(newWeight: Int(feedback.weightMeasurement), unit: nil)
            
            
        }
        
        guard mealPlanExistsForThisWeek != nil else {
            return
        }
        if mealPlanExistsForThisWeek!.yayNay == false{
            let calRequirements = SetUpMealPlan.calculateInitialCalorieAllowance() // generate new calorie requirements
            SetUpMealPlan.createWeek(daysUntilCommencement: 0, calorieAllowance: calRequirements)
            SetUpMealPlan.createWeek(daysUntilCommencement: 7, calorieAllowance: calRequirements)
            //Eat TDEE plus what you want // create meal plan from today for the next two weeks (we're starting over)
            
            takeUserToMealPlan(explainerScreenTypeIs: .startingOver)
            return
            
        } else {
            switch mealPlanExistsForThisWeek!.weeksAheadIncludingCurrent.count {
            case 1:
                print("Case 1")
                let currentWeek = Week().currentWeek()
                let lastWeek = currentWeek?.lastWeek()
                
                guard currentWeek != nil && lastWeek != nil else {
                    print("Error at 2")
                    return
                }
                let daysUntilExpiry = currentWeek?.daysUntilWeekExpires()
                
                var newCaloriesAllowance = 0
                if(Config.getBoolValue(Constants.STANDARD_CALORIE_CUT) == true){
                    
                    newCaloriesAllowance = SetUpMealPlan.cutCalories(fromWeek: lastWeek!, userfoundDiet: Constants.dietEase(rawValue: feedback.easeOfFollowingDiet)!)
                } else {
                    newCaloriesAllowance = SetUpMealPlan.initialCalorieCut(firstWeek: lastWeek!) // run initialCalorieCut
                    Config.setBoolValue(Constants.STANDARD_CALORIE_CUT,status: true)
                }
                
                // delete current week and create a new meal plan for this week and next.
                DataHandler.deleteThisWeeksMealPlan() //TO-DO: Create MP from next weeks foods to minimise changes
                SetUpMealPlan.createWeek(daysUntilCommencement: daysUntilExpiry! - 7, calorieAllowance: newCaloriesAllowance)
                SetUpMealPlan.createWeek(daysUntilCommencement: daysUntilExpiry!, calorieAllowance: newCaloriesAllowance)
                AppEventsLogger.log("updated meal plans")
                
                takeUserToMealPlan(explainerScreenTypeIs: .congratulations)
                return
            case 2:
                return
            default:
                return // this could be because the user is between the 8th day and 12th day of a meal plan.
            }
        }
    }
    
    
    func takeUserToMealPlan(explainerScreenTypeIs:Constants.explainerScreenType){
        if explainerScreenTypeIs == .none{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.takeUserToMealPlan(shouldShowExplainerScreen: false)
        } else {
            performSegue(withIdentifier: "giveUserFeedback", sender: explainerScreenTypeIs)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "giveUserFeedback" {
            let controller = segue.destination as! UserFeedbackVanilla
            controller.explainType = (sender as? Constants.explainerScreenType)!
        }
    }

    
    func createNewFoodFromConversation(){
        let food = Food()
        guard let pk = DataHandler.getNewPKForFood() else {
            return
        }
        food.pk = pk
        
        //["item", "pot", "slice", "cup", "tablet", "heaped teaspoon", "pinch", "100ml", "100g"]
        
        let foodNameIndex = 0
        let foodName : String = answers[foodNameIndex].first!
        food.name = foodName
        print("food2: \(food.name)")
        
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
            food.calories = Double(answers[caloriesIndex].first!)!
        }
        
        
        if let fatsIndex = questions.index(of: BotData.NEW_FOOD.fat.question) {
            food.fats = Double(answers[fatsIndex].first!)!
        }
        
        
        if let satFatsIndex = questions.index(of: BotData.NEW_FOOD.fat.question) {
            if let satFats = answers[satFatsIndex].first {
                food.sat_fats = RealmOptional<Double>(Double(satFats))
            }
        }
        
        
        if let carbIndex = questions.index(of: BotData.NEW_FOOD.carbohydrates.question) {
            food.carbohydrates = Double(answers[carbIndex].first!)!
        }
        
        
        
        if let sugarIndex = questions.index(of: BotData.NEW_FOOD.sugar.question) {
            if let sugar = answers[sugarIndex].first {
                food.sugars = RealmOptional<Double>(Double(sugar))
            }
        }
        
        
        if let fibreIndex = questions.index(of: BotData.NEW_FOOD.fibre.question){
            if let fibre = answers[fibreIndex].first{
                food.fibre = RealmOptional<Double>(Double(fibre))
            }
        }
        
        
        if let proteinIndex = questions.index(of: BotData.NEW_FOOD.protein.question){
            if let proteins = answers[proteinIndex].first{
                food.proteins = Double(proteins)!
            }
        }
        
        
        if let foodTypeIndex = questions.index(of: BotData.NEW_FOOD.food_type.question){
            let realm = try! Realm()
            let foodTypesSelected = answers[foodTypeIndex]
            let foodTypesFound = Set(realm.objects(FoodType.self).filter("name IN %@", foodTypesSelected))
            food.foodType.append(contentsOf: foodTypesFound)
        }
        
        //_ = DataHandler.createFood(fooditem.food!)
        
        
        let fooditem = FoodItem()
        fooditem.food = food
        
        if let servingAmountIndex = questions.index(of: BotData.NEW_FOOD.number_of_servings.question) {
            fooditem.numberServing = Double(answers[servingAmountIndex].first!)!
        }
        
        print("food item object: \(fooditem)")
        
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
    

