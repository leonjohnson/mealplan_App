import UIKit
import RealmSwift
import JSQMessagesViewController

final class BotController: JSQMessagesViewController {
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
        Constants.BOT_NEW_FOOD.saturated_fat.question,
        Constants.BOT_NEW_FOOD.done.question]
    
    

    var answers : [String:String] = ["name":"crisps"]
    
    let keyboardType : [String:String] = [:]
    var questionIndex : Int = 0
    
    enum botTypeEnum {
        case addNewFood
    }
    var botType : botTypeEnum = .addNewFood
    
    var tapped = Int()
    
    var customOutgoingMediaCellIdentifier : String = ""
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.toolbar.isHidden = false
        
        
        
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
        
        self.collectionView.register(UINib(nibName: "outCell", bundle: nil), forCellWithReuseIdentifier: "out")
        
        self.collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
        
        self.collectionView.isUserInteractionEnabled = true
        
        
        
        

        //self.customOutgoingMediaCellIdentifier = outCells.mediaCellReuseIdentifier()
        
        
        let user = DataHandler.getActiveUser()
        self.senderId = user.name
        self.senderDisplayName = user.name
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        self.inputToolbar.contentView.leftBarButtonItem = nil
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
    
    
    
    
    
    private func takeUserBackToMealPlan(){
        
        
        let index = self.navigationController?.viewControllers.index(of: self)
        let mealplanViewController = self.navigationController?.viewControllers[index!-2]
        print("indices : \(index)")
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
        //self.collectionView.collectionViewLayout.sizeForItem(at: <#T##IndexPath!#>)
        let message = messages[indexPath.item]
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        if Constants.questionsThatRequireTableViews.contains(message.text!) {
            
            let cellWithTableview = collectionView.dequeueReusableCell(withReuseIdentifier: "out", for: indexPath) as! outCells
            cellWithTableview.question = message.text
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
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    
    
    
    
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
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
        if let foodName : String = messages[foodNameIndex+1].text{
            food.name = foodName
        }
        
        let foodProducerIndex = questions.index(of: Constants.BOT_NEW_FOOD.producer.question)
        if let foodProducer = messages[(foodProducerIndex!*2)+1].text {
            food.producer = foodProducer
        }
        
        let servingTypeIndex = questions.index(of: Constants.BOT_NEW_FOOD.serving_type.question)
        if let servingType = messages[(servingTypeIndex!*2)+1].text {
            /*
             
             for index in valuesEntered{
             let ix = Constants.FOOD_TYPES[Int(index)!]
             newValues.append(ix)
             }
             let ft = realm.objects(FoodType).filter("name IN %@", valuesEntered)
             
             */
        }
        
        let caloriesIndex = questions.index(of: Constants.BOT_NEW_FOOD.calories.question)
        if let calories = Double(messages[(caloriesIndex!*2)+1].text) {
            food.calories = calories
        }
        
        let fatsIndex = questions.index(of: Constants.BOT_NEW_FOOD.fat.question)
        if let fats = Double(messages[(fatsIndex!*2)+1].text) {
            food.fats = fats
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
    

