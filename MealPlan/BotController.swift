import UIKit
import RealmSwift
import JSQMessagesViewController
import JSQSystemSoundPlayer
import FacebookCore

final class BotController: JSQMessagesViewController, BotDelegate, screenDismissed, dismissedFoodPreferences, UITableViewDelegate, UIGestureRecognizerDelegate {
    
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
        case onBoarding
    }
    
    enum explainerScreenType {
        case none
        case congratulations
        case startingOver // Used when creating Bot page to provide it with some context of task.
    }
    var botType : botTypeEnum = .onBoarding // default state
    var questions : [String] = []
    var options : [[String]] = []
    var buttonText : [String?] = []
    var answers : [[String]] = []
    var keyBoardType : [Constants.botKeyboardValidationType] = []
    var validationType : [Constants.botContentValidationType] = []
    var nextSteps : [Constants.botNextSteps] = []
    var didTap : [Constants.botDidTap?] = []
    var usersName : String = ""
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
        self.collectionView.backgroundColor = Constants.MP_WHITE
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
            questions[0] = "Hey \(user.first_name)! What is the full name of the food you want to record?"
            options = BotData.NEW_FOOD.options
            answers = BotData.NEW_FOOD.answers
            keyBoardType = BotData.NEW_FOOD.keyboardType
            didTap = BotData.NEW_FOOD.didTAP
        case .feedback:
            questions = BotData.FEEDBACK.questions
            questions[0] = "Hey \(user.first_name)!"
            questions[3] = questions[3] + ",in \(weightUnit)s?"
            options = BotData.FEEDBACK.options
            answers = BotData.FEEDBACK.answers
            keyBoardType = BotData.FEEDBACK.keyboardType
            buttonText = BotData.FEEDBACK.buttonText
            nextSteps = BotData.FEEDBACK.nextSteps
            didTap = BotData.FEEDBACK.didTAP
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.navigationBar.frame.size = CGSize(width: (self.navigationController?.navigationBar.frame.width)!, height: 35)
            self.navigationItem.hidesBackButton = true
        case .onBoarding:
            questions = BotData.ONBOARD.questions
            options = BotData.ONBOARD.options
            answers = BotData.ONBOARD.answers
            keyBoardType = BotData.ONBOARD.keyboardType
            buttonText = BotData.ONBOARD.buttonText
            nextSteps = BotData.ONBOARD.nextSteps
            didTap = BotData.ONBOARD.didTAP
        case .unstated:
            return
        }
        

        
        self.automaticallyScrollsToMostRecentMessage = true
        self.collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
        //self.outgoingCellIdentifier = outCells.cellReuseIdentifier()
        self.collectionView.register(UINib(nibName: "inCell", bundle: nil), forCellWithReuseIdentifier: "in")
        self.collectionView.register(UINib(nibName: "outCell", bundle: nil), forCellWithReuseIdentifier: "out")
        self.collectionView.register(UINib(nibName: "BotCellWithButton", bundle: nil), forCellWithReuseIdentifier: "button")
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.collectionViewLayout.messageBubbleFont = Constants.STANDARD_FONT
        self.inputToolbar.contentView?.leftBarButtonItemWidth = CGFloat(34.0)
        
        
        // MARK: ### SET SEND BUTTON AS IMAGE
        /*
        let rightButton = UIButton(frame: CGRect.zero)
        let sendImage = UIImage(named: "Sent")
        rightButton.setImage(sendImage, for: UIControlState.normal)
        self.inputToolbar.contentView?.rightBarButtonItemWidth = CGFloat(34.0)
        self.inputToolbar.contentView?.rightBarButtonItem = rightButton
         */
        
        
        
        // MARK: ### DISABLE COPY/PASTE
        // 1. add gesture recognizer to know when text view is tapped
        // 2. add blocking view after 0.7 sec
        // 3. all other methods like subclassing UITextView and using categories to not work
        let tap = UITapGestureRecognizer(target: self, action:  #selector(BotController.handleTap))
        tap.delegate = self
        self.inputToolbar.contentView?.textView?.addGestureRecognizer(tap)
        
        
        self.senderId = user.first_name
        self.senderDisplayName = user.first_name
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        inComingCellViewController.botDelegate = self

        updateKeyboard()
        
        //Send the first message
        addMessage(withId: Constants.BOT_NAME, name: "\(Constants.BOT_NAME)", text: questions[questionIndex])
        self.finishSendingMessage(animated: true)
        
    }
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    private func validateAnswer()->Bool{
        return true
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        //Consider whether to show the typing indicator
        var delayDuration : Double = 3.0
        switch nextSteps[questionIndex] {
        case .hurryAlong:
            delayDuration = (questionIndex == 0) ? 3.0 : 1.0
            
        case .createMealPlans:
            updateKeyboard()
            break
            
        case .awaitResponse:
            updateKeyboard()
            delayDuration = 3.0
        }
        
        if name != Constants.BOT_NAME {
            delayDuration = 0.0
        }

        //create closure
        let addingClosure = {
            if let message = JSQMessage(senderId: id, displayName: name, text: text) {
                self.scrollToBottom(animated: true)
                self.messages.append(message)
                self.finishSendingMessage(animated: true)
                self.showTypingIndicator = false
                self.performFollowUpAction(delayDuration: delayDuration)
            }
        }
        
        
        if name != Constants.BOT_NAME {
            addingClosure()
        } else {
            //Show the message on screen
            self.showTypingIndicator = true
            delay(delayDuration, closure: addingClosure) // if the bot is typing add a delay
        }
    }
    
    
    
    func performFollowUpAction(delayDuration:Double = 0.0){
        // perform the follow up action
        switch nextSteps[questionIndex] {
        case .hurryAlong:
            delay(delayDuration, closure: {
                self.progressToNextQuestionAfterDelay(delay: delayDuration) // this is so that the next question isn't fired until the last one has finished
            })
        case .awaitResponse:
            break
        
        case .createMealPlans:
            if botType == .feedback{
                saveFeedbackForTheWeek()
                progressToNextQuestionAfterDelay(delay: 0.0)
            } else {
                #if DEBUG
                    print("Error in add message function ###")
                #endif
            }
        }
        
    }

    
    

    /*
    // MARK: - DELEGATE METHODS
    */
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!){
        if let message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text) {
            if validateAnswer() == true{
                addMessage(withId: self.senderId, name: "t", text: text)
            }
            
            if message.text.localizedLowercase.contains("go back") && messages.count > 3{
                addMessage(withId: "foo", name: Constants.BOT_NAME, text: "OK")
                questionIndex -= 1
                let nextQuestion = questions[questionIndex]
                addMessage(withId: "foo", name: Constants.BOT_NAME, text: nextQuestion)
                self.finishSendingMessage(animated: true)
                return
            }
            
            answers[questionIndex].append(text)
            answers[questionIndex].removeFirst()
            
            if questions[questionIndex] == BotData.ONBOARD.firstName.question {
                usersName = text
                questions[questionIndex+1].append("\(usersName) 😀")
            }
            
            if questions[questionIndex] == BotData.ONBOARD.thanks.question {
                questions[questionIndex].append("\(usersName)!😀")
            }
            print("answers in didpressend: \(answers)")
        }
        progressToNextQuestionAfterDelay(delay: 0.0)
        
        // MARK: ### PLAY SOUND FOR SENT MESSAGE
        // 1. add JSQSystemSoundPlayer pod
        // 2. add JSQSystemSoundPlayer+JSQMessages.h category
        // 3. add bridging header to use this category
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
    }
    
    
    func progressToNextQuestionAfterDelay(delay:Double){
        let lastIndex : Int = (questionIndex > 0) ? questionIndex - 1 : questionIndex
        let weekNumber = SetUpMealPlan.getThisWeekAndNext().first?.number
        if questions[questionIndex + 1] == BotData.FEEDBACK.firstWeekNotice.question && weekNumber != 1 {
            questionIndex += 2
            lastIndex = questionIndex - 2
        } else {
            questionIndex += 1
            lastIndex = questionIndex - 1
        }
        let nextQuestion = questions[questionIndex]
        addMessage(withId: "foo", name: Constants.BOT_NAME, text: nextQuestion)
        self.finishSendingMessage(animated: true)
    }
    
    
    func updateKeyboard(){
        // Set the keyboard type and icon
        sideButton = UIButton(frame: CGRect.zero)
        var keyBoardImage = UIImage()
        let newKeyboardType : UIKeyboardType
        
        switch keyBoardType[questionIndex] {
        case .number:
            newKeyboardType = UIKeyboardType.numberPad
            keyBoardImage = UIImage(named: "keyboard_filled")!
            print("number keyboard")
        case .decimal:
            newKeyboardType = UIKeyboardType.decimalPad
            keyBoardImage = UIImage(named: "keyboard_filled")!
            print("decimal keyboard")
        case .text:
            newKeyboardType = UIKeyboardType.alphabet
            keyBoardImage = UIImage(named: "number_keypad")!
            print("text keyboard")
        case .none:
            newKeyboardType = UIKeyboardType.default
            keyBoardImage = UIImage(named: "number_keypad")!
            print("none keyboard")
        }
        sideButton?.setImage(keyBoardImage, for: UIControlState.normal)
        self.inputToolbar.contentView.textView.keyboardType = newKeyboardType
        self.inputToolbar.contentView.textView.reloadInputViews()
        
        self.inputToolbar.contentView?.leftBarButtonItem = sideButton
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
    
    
    func closeConversation(){
        addMessage(withId: Constants.BOT_NAME, name: "\(Constants.BOT_NAME)", text: questions[questionIndex])
        self.finishSendingMessage(animated: true)
    }
    
    
    
    
    
    func buttonTapped(forQuestion: String) {
        if let tapAction = didTap[questionIndex] {
            switch tapAction {
            case .noValueSelected:
                guard let indexForAnswer = questions.index(of: forQuestion) else {
                    return
                }
                answers[indexForAnswer].removeAll()
                progressToNextQuestionAfterDelay(delay: 0.0)
                
            case .createMealPlans:
                createNewFoodFromConversation()
                
            case .requestNotificationPermission:
                break
                
            case .saveEndOfWeekFeedback:
                saveFeedbackForTheWeek()
                
            case .quit:
                if DataHandler.userExists() == false {
                    createUserAndProfile()
                    //takeUserToMealPlan(explainerScreenTypeIs: .none) // just posted the last response
                }
                takeUserToMealPlan() // just posted the last response
            case .openHeightWeightScreen:
                let storyboard : UIStoryboard = Constants.BOT_STORYBOARD
                let  hw = storyboard.instantiateViewController(withIdentifier: "hw") as! Height_WeightListViewController
                hw.delegate = self
                UIApplication.shared.keyWindow?.rootViewController?.present(hw, animated: true, completion: {
                    
                })
            
            case .openFoodPreferencesScreen:
                let storyboard : UIStoryboard = Constants.BOT_STORYBOARD
                let foodPreferencesScreen = storyboard.instantiateViewController(withIdentifier: "likeordislike") as! LikeOrDislike
                foodPreferencesScreen.delegate = self
                UIApplication.shared.keyWindow?.rootViewController?.present(foodPreferencesScreen, animated: true, completion: {
                    
                })
            }
            
  
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismiss(animated: true)
        progressToNextQuestionAfterDelay(delay: 0.0)
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
            progressToNextQuestionAfterDelay(delay: 0.0)
        }
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return messages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        //Styling
        let botLeading : NSMutableParagraphStyle = NSMutableParagraphStyle()
        botLeading.lineSpacing = 4.33
        
        //Cell and message
        let message = messages[indexPath.item]
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        cell.textView.textColor = UIColor.black
        //cell.textView.attributedText = NSAttributedString(string: message.text, attributes: [
            //NSParagraphStyleAttributeName:botLeading,
            //NSFontAttributeName:Constants.STANDARD_FONT])
        
        if cell.messageBubbleImageView == outgoingBubbleImageView.messageBubbleImage{
            cell.textView.textColor = UIColor.black
        }
        
        if Constants.questionsThatRequireTableViews.contains(message.text!) {
            let questionIndex = questions.index(of: message.text)
            let tableViewRowData = options[questionIndex!]
            //let tableViewRowData = options[row/2]
            let cellWithTableview = collectionView.dequeueReusableCell(withReuseIdentifier: "in", for: indexPath) as! inCell
            //cellWithTableview.table.delegate = self
            
            
            
            cellWithTableview.question = message.text
            cellWithTableview.questionTextView?.attributedText = NSAttributedString(string: message.text, attributes:[
                NSFontAttributeName:Constants.STANDARD_FONT, 
                NSForegroundColorAttributeName:UIColor.black,
                NSParagraphStyleAttributeName:botLeading])
            
            cellWithTableview.data.question = message.text
            cellWithTableview.data.options = tableViewRowData
            cellWithTableview.table.reloadData()
            cellWithTableview.messageBubbleImageView.image = incomingBubbleImageView.messageBubbleImage
            cellWithTableview.backgroundColor = UIColor.clear
            cellWithTableview.botDelegate = self
            
            for row in 0...tableViewRowData.count{
                cellWithTableview.table.cellForRow(at: [0,row])?.accessoryType = .none
            }
            let answersIndex : Int
            
            if answers.count > questionIndex!{
                let answer = answers[questionIndex!].first
                if (answer?.characters.count)! > 0 {
                    if message.text == BotData.NEW_FOOD.food_type.question {
                        answersIndex = Constants.FOOD_TYPES.index(of: answer!)!
                    } else {
                        answersIndex = Int(tableViewRowData.index(of: answer!)!)
                    }
                    cellWithTableview.table.cellForRow(at: [0,Int(answersIndex)])?.accessoryType = .checkmark
                }
            } else {
                print("no answer at this stage")
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
            cellWithButton.questionTextView?.attributedText = NSAttributedString(string: message.text, attributes:[NSFontAttributeName:Constants.STANDARD_FONT, 
                 NSForegroundColorAttributeName:Constants.MP_BLACK, 
                 NSParagraphStyleAttributeName:botLeading])
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
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: Constants.MP_BRIGHT_BLUE)
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: Constants.MP_MESSAGE_BUBBLE_GREY)
        }
    
    
    private func saveFeedbackForTheWeek(){
        var feedback = FeedBack()
        if let weekJustFinished = Week().lastWeek(){
            // Get the standard measurement
            
            
            feedback.weightUnit = DataHandler.getActiveBiographical().weightUnit
            feedback.weightMeasurement = Double(answers[3].first!)!
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
            DataHandler.updateWeightForNewWeek(newWeight: Int(feedback.weightMeasurement), unit: nil)
            
            
        }
        guard mealPlanExistsForThisWeek != nil else {
            return
        }
        if mealPlanExistsForThisWeek!.yayNay == false{
            let calRequirements = SetUpMealPlan.calculateInitialCalorieAllowance() // generate new calorie requirements
            SetUpMealPlan.createWeek(daysUntilCommencement: 0, calorieAllowance: calRequirements)
            SetUpMealPlan.createWeek(daysUntilCommencement: 7, calorieAllowance: calRequirements)
            //Eat TDEE plus what you want // create meal plan from today for the next two weeks (we're starting over)
            
            //takeUserToMealPlan()
            return
            
        } else {
            switch mealPlanExistsForThisWeek!.weeksAheadIncludingCurrent.count {
            case 1:
                let currentWeek = Week().currentWeek()
                let lastWeek = currentWeek?.lastWeek()
                
                guard currentWeek != nil && lastWeek != nil else {
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
                
                //takeUserToMealPlan()
                return
            case 2:
                return
            default:
                return // this could be because the user is between the 8th day and 12th day of a meal plan.
            }
        }
    }
    
    
    func takeUserToMealPlan(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.takeUserToMealPlan(shouldShowExplainerScreen: false)
        //performSegue(withIdentifier: "showMealPlan", sender: nil)
    }
    
    

    func createUserAndProfile(){
        let bio = Biographical()
        let user = User()
        user.first_name = usersName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).localizedCapitalized
        
        // Birthdate
        if let ageIndex = questions.index(of: BotData.ONBOARD.age.question) {
            let age = answers[ageIndex].first!
            let years : Int = Int(age)! * 365 * 24 * 60 * 60
            user.birthdate = Date(timeIntervalSinceNow: Double(years * -1))
        }
        
        //numberOfDailyMeals
        if let numberOfDailyMealsIndex = questions.index(of: BotData.ONBOARD.numberOfMeals.question) {
            user.gender = answers[numberOfDailyMealsIndex].first!
        }
        
        //mealplanDuration
        if let genderIndex = questions.index(of: BotData.ONBOARD.duration.question) {
            bio.mealplanDuration = Int(answers[genderIndex].first!)!
        }
        
        //activityLevelAtWork
        if let genderIndex = questions.index(of: BotData.ONBOARD.activityLevelAtWork.question) {
            bio.activityLevelAtWork = answers[genderIndex].first!
        }
        
        //dietaryRequirement
        if let dietaryIndex = questions.index(of: BotData.ONBOARD.dietType.question) {
            var diets : [String] = []
            for diet in answers[dietaryIndex]{
                if diet != Constants.NONE_OF_THE_ABOVE {
                    diets.append(diet)
                }
            }
            DataHandler.addDietTypeFollowed(diets)
        }
        
        //objectives
        if let objectivesIndex = questions.index(of: BotData.ONBOARD.gender.question) {
            //bio.gainMuscle = Double(answers[objectivesIndex].first!)!
            
            if let loseWeight = answers[objectivesIndex].first {
                if loseWeight  == Constants.goals.loseWeight.rawValue {
                    bio.loseFat.value = true
                }
            }
            
            if answers[objectivesIndex].count > 1{
                let gainMuscle = answers[objectivesIndex][1]
                if gainMuscle  == Constants.goals.gainMuscle.rawValue {
                bio.loseFat.value = true
                }
            }
            
        }
        
        //Gender
        if let genderIndex = questions.index(of: BotData.ONBOARD.gender.question) {
            user.gender = answers[genderIndex].first!
        }
        
        //hoursOfActivity
        if let activityHoursIndex = questions.index(of: BotData.ONBOARD.gender.question) {
            bio.hoursOfActivity = Double(answers[activityHoursIndex].first!)!
        }
        
        //heightMeasurement
        if let weightHeightIndex = questions.index(of: BotData.ONBOARD.weightHeight.question) {
            
            //bio.heightMeasurement = Double(answers[weightHeightIndex].first!)!
            //bio.heightUnit = answers[heightUnitIndex].first!
            //bio.weightMeasurement = Double(answers[weightMeasurementIndex].first!)!
            //bio.weightUnit = answers[weightUnitIndex].first!
        }
        
        
        /*
         dynamic var numberOfDailyMeals: Int = 0
         dynamic var mealplanDuration: Int = 0
         dynamic var activityLevelAtWork: String? = nil
         
         let dietaryRequirement = List<DietSuitability>()
         
         var loseFat = RealmOptional<Bool>()
         var gainMuscle = RealmOptional<Bool>()
         
         dynamic var numberOfResistanceSessionsEachWeek = 0
         dynamic var numberOfCardioSessionsEachWeek = 0
         
         dynamic var heightMeasurement = 0.0
         dynamic var heightUnit = ""
         
         dynamic var weightMeasurement = 0.0
         dynamic var weightUnit = ""
         
         dynamic var waistMeasurement = 0.0
         dynamic var waistUnit = ""
        */
        
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
        switch keyBoardType[questionIndex] {
        case  Constants.botKeyboardValidationType.text:
            return text.isDecimal() ? false : true
            
        case  Constants.botKeyboardValidationType.decimal:
            return text.isDecimal() ? true : false
        
        case  Constants.botKeyboardValidationType.number:
            return text.isNumber() ? true : false
            
        case  Constants.botKeyboardValidationType.none:
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
    
    func testfunction(height:String, weight:String){
        guard let indexForAnswer = questions.index(of: questions[questionIndex]) else {
            return
        }
        answers[indexForAnswer].removeAll()
        answers[indexForAnswer].append("")
        progressToNextQuestionAfterDelay(delay: 0.0)
    }
    
    func foodPreferencesDone() {
        progressToNextQuestionAfterDelay(delay: 0.0)
    }


}


