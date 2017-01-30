import Foundation


class BotData: NSObject {
    
    var usersName : String? {
        return DataHandler.getActiveUser().name
    }
    var objective : Biographical? {
        return DataHandler.getActiveBiographical()
    }
    
    
    
    
    struct NEW_FOOD {
        static let questions : [String] = [
            BotData.NEW_FOOD.name.question,
            BotData.NEW_FOOD.producer.question,
            BotData.NEW_FOOD.serving_type.question,
            BotData.NEW_FOOD.calories.question,
            BotData.NEW_FOOD.fat.question,
            BotData.NEW_FOOD.saturated_fat.question,
            BotData.NEW_FOOD.carbohydrates.question,
            BotData.NEW_FOOD.sugar.question,
            BotData.NEW_FOOD.fibre.question,
            BotData.NEW_FOOD.protein.question,
            BotData.NEW_FOOD.food_type.question,
            BotData.NEW_FOOD.number_of_servings.question,
            BotData.NEW_FOOD.ending.question]
        
        static let options : [[String]]  = [
            BotData.NEW_FOOD.name.tableViewList,
            BotData.NEW_FOOD.producer.tableViewList,
            BotData.NEW_FOOD.serving_type.tableViewList,
            BotData.NEW_FOOD.calories.tableViewList,
            BotData.NEW_FOOD.fat.tableViewList,
            BotData.NEW_FOOD.saturated_fat.tableViewList,
            BotData.NEW_FOOD.carbohydrates.tableViewList,
            BotData.NEW_FOOD.sugar.tableViewList,
            BotData.NEW_FOOD.fibre.tableViewList,
            BotData.NEW_FOOD.protein.tableViewList,
            BotData.NEW_FOOD.food_type.tableViewList,
            BotData.NEW_FOOD.number_of_servings.tableViewList,
            BotData.NEW_FOOD.ending.tableViewList]
        
        static let buttonText : [String]  = [
            BotData.NEW_FOOD.name.buttonText,
            BotData.NEW_FOOD.producer.buttonText,
            BotData.NEW_FOOD.serving_type.buttonText,
            BotData.NEW_FOOD.calories.buttonText,
            BotData.NEW_FOOD.fat.buttonText,
            BotData.NEW_FOOD.saturated_fat.buttonText,
            BotData.NEW_FOOD.carbohydrates.buttonText,
            BotData.NEW_FOOD.sugar.buttonText,
            BotData.NEW_FOOD.fibre.buttonText,
            BotData.NEW_FOOD.protein.buttonText,
            BotData.NEW_FOOD.food_type.buttonText,
            BotData.NEW_FOOD.number_of_servings.buttonText,
            BotData.NEW_FOOD.ending.buttonText]
        
        static let nextSteps : [Constants.botNextSteps]  = [
            BotData.NEW_FOOD.name.nextSteps,
            BotData.NEW_FOOD.producer.nextSteps,
            BotData.NEW_FOOD.serving_type.nextSteps,
            BotData.NEW_FOOD.calories.nextSteps,
            BotData.NEW_FOOD.fat.nextSteps,
            BotData.NEW_FOOD.saturated_fat.nextSteps,
            BotData.NEW_FOOD.carbohydrates.nextSteps,
            BotData.NEW_FOOD.sugar.nextSteps,
            BotData.NEW_FOOD.fibre.nextSteps,
            BotData.NEW_FOOD.protein.nextSteps,
            BotData.NEW_FOOD.food_type.nextSteps,
            BotData.NEW_FOOD.number_of_servings.nextSteps,
            BotData.NEW_FOOD.ending.nextSteps]
        
        static let answers : [[String]] = [
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
            [String()],
            [String()]]
        
        //
        static let keyboardType : [Constants.botKeyboardValidationType]  = [
            BotData.NEW_FOOD.name.keyboardType,
            BotData.NEW_FOOD.producer.keyboardType,
            BotData.NEW_FOOD.serving_type.keyboardType,
            BotData.NEW_FOOD.calories.keyboardType,
            BotData.NEW_FOOD.fat.keyboardType,
            BotData.NEW_FOOD.saturated_fat.keyboardType,
            BotData.NEW_FOOD.carbohydrates.keyboardType,
            BotData.NEW_FOOD.sugar.keyboardType,
            BotData.NEW_FOOD.fibre.keyboardType,
            BotData.NEW_FOOD.protein.keyboardType,
            BotData.NEW_FOOD.food_type.keyboardType,
            BotData.NEW_FOOD.number_of_servings.keyboardType,
            BotData.NEW_FOOD.ending.keyboardType]
        
        static let didTAP : [Constants.botDidTap?] = [
            BotData.NEW_FOOD.name.didTap,
            BotData.NEW_FOOD.producer.didTap,
            BotData.NEW_FOOD.serving_type.didTap,
            BotData.NEW_FOOD.calories.didTap,
            BotData.NEW_FOOD.fat.didTap,
            BotData.NEW_FOOD.saturated_fat.didTap,
            BotData.NEW_FOOD.carbohydrates.didTap,
            BotData.NEW_FOOD.sugar.didTap,
            BotData.NEW_FOOD.fibre.didTap,
            BotData.NEW_FOOD.protein.didTap,
            BotData.NEW_FOOD.food_type.didTap,
            BotData.NEW_FOOD.number_of_servings.didTap,
            BotData.NEW_FOOD.ending.didTap]
        
            struct name {
                static let question = "Hi! What is the full name of the food?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botKeyboardValidationType.text
                static let nextSteps = Constants.botNextSteps.awaitResponse
                static let didTap : Constants.botDidTap? = nil
            }
            
            struct producer {
                static let question = "Who makes this product?" // manufacter, don't know, blank, some other unuseful answer
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botKeyboardValidationType.text
                static let nextSteps = Constants.botNextSteps.awaitResponse
                static let didTap : Constants.botDidTap? = nil
            }
        
            struct food_type {
                static let question = "Please help me categorise this item by selecting one or more below:"
                static let tableViewList = ["It's a drink",
                                            "It's a fizzy drink",
                                            "It's a fruit",
                                            "It's a vegetable",
                                            "I would eat this at breakfast",
                                            "I would only eat this at breakfast",
                                            "This is a type of fish",
                                            "This is a condiment",
                                            "None of the above"]
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botKeyboardValidationType.none
                static let nextSteps = Constants.botNextSteps.awaitResponse
                static let didTap : Constants.botDidTap? = nil
            }
        
            struct serving_type {
                static let question = "For the nutritional information you're going to enter is it per:"
                static let tableViewList = [Constants.grams,
                                            Constants.ml,
                                            Constants.slice,
                                            "Item (such as per banana or per apple)?"]
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botKeyboardValidationType.none
                static let nextSteps = Constants.botNextSteps.awaitResponse
                static let didTap : Constants.botDidTap? = nil
            }
            
            struct calories {
                static let question = "Thanks. How many calories are in it?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botKeyboardValidationType.decimal
                static let nextSteps = Constants.botNextSteps.awaitResponse
                static let didTap : Constants.botDidTap? = nil
            }
            
            struct fat {
                static let question = "grams of fat?" //per 100g or 100ml
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botKeyboardValidationType.decimal
                static let nextSteps = Constants.botNextSteps.awaitResponse
                static let didTap : Constants.botDidTap? = nil
            }
            
            struct saturated_fat {
                static let question = "saturated fat?"
                static let tableViewList:[String] = []
                static let buttonText : String = Constants.no_value_stated
                static let tips : String = ""
                static let keyboardType = Constants.botKeyboardValidationType.decimal
                static let nextSteps = Constants.botNextSteps.awaitResponse
                static let didTap : Constants.botDidTap? = nil
            }
            
            struct carbohydrates {
                static let question = "and carbohydrates?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botKeyboardValidationType.decimal
                static let nextSteps = Constants.botNextSteps.awaitResponse
                static let didTap : Constants.botDidTap? = nil
            }
            
            struct sugar {
                static let question = "of which are sugar?"
                static let tableViewList:[String] = []
                static let buttonText : String = Constants.no_value_stated
                static let tips : String = ""
                static let keyboardType = Constants.botKeyboardValidationType.decimal
                static let nextSteps = Constants.botNextSteps.awaitResponse
                static let didTap : Constants.botDidTap? = nil
            }
            
            struct fibre {
                static let question = "and fibre?"
                static let tableViewList:[String] = []
                static let buttonText : String = Constants.no_value_stated
                static let tips : String = ""
                static let keyboardType = Constants.botKeyboardValidationType.decimal
                static let nextSteps = Constants.botNextSteps.awaitResponse
                static let didTap : Constants.botDidTap? = nil
            }
            
            struct protein {
                static let question = "how much protein does this item have?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botKeyboardValidationType.decimal
                static let nextSteps = Constants.botNextSteps.awaitResponse
                static let didTap : Constants.botDidTap? = nil
            }
        
            struct number_of_servings {
                static let question = "How many servings would you like to eat:"
                static let tableViewList : [String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botKeyboardValidationType.decimal
                static let nextSteps = Constants.botNextSteps.awaitResponse
                static let didTap : Constants.botDidTap? = nil
            }
        
            struct ending {
                static let question = "Thanks! You're all done. 👍"
                static let tableViewList:[String] = []
                static let buttonText : String = "Show me my meal plan"
                static let tips : String = ""
                static let keyboardType = Constants.botKeyboardValidationType.none
                static let nextSteps = Constants.botNextSteps.awaitResponse
                static let didTap : Constants.botDidTap? = nil
            }
    }
    
    struct FEEDBACK {
        
        static let questions : [String] = [
            BotData.FEEDBACK.greeting.question,
            BotData.FEEDBACK.howWasLastWeek.question,
            BotData.FEEDBACK.howHungryWereYou.question,
            BotData.FEEDBACK.easeOfFollowingDiet.question,
            BotData.FEEDBACK.anyComments.question,
            BotData.FEEDBACK.ending.question]
        
        static let options : [[String]]  = [
            BotData.FEEDBACK.howWasLastWeek.tableViewList,
            BotData.FEEDBACK.howHungryWereYou.tableViewList,
            BotData.FEEDBACK.easeOfFollowingDiet.tableViewList,
            BotData.FEEDBACK.anyComments.tableViewList,
            BotData.FEEDBACK.ending.tableViewList]
 
        static let answers : [[String]] = [[String()],
                                           [String()],
                                           [String()],
                                           [String()],
                                           [String()],
                                           [String()]
                                           ]
        
        static let keyboardType  = [
            BotData.FEEDBACK.howWasLastWeek.keyboardType,
            BotData.FEEDBACK.howHungryWereYou.keyboardType,
            BotData.FEEDBACK.anyComments.keyboardType,
            BotData.FEEDBACK.easeOfFollowingDiet.keyboardType,
            BotData.FEEDBACK.ending.keyboardType]
        
        struct greeting {
            static let question = "Hey!"
            static let tableViewList:[String] = []
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let partOfASeries = true
        }
        
        struct update {
            static let question = "Well done! You've completed another week of your new meal plan! 👏"
            static let tableViewList:[String] = []
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let partOfASeries = true
        }
        
        struct checkin {
            static let question = "To make sure your meal plans are going accoridng to plan, we're going to quickly go over how last week went."
            static let tableViewList:[String] = []
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let partOfASeries = true

        }
        
        struct howWasLastWeek {
            static let question = "How much did you weigh this morning?"
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.decimal
            static let partOfASeries = false
        }
        
        struct howHungryWereYou {
            static let question = "How hungry were you after last weeks meal plans?"
            static let tableViewList:[String] = [Constants.hungerLevels.veryHungry.rawValue,
                                                 Constants.hungerLevels.littleHungry.rawValue,
                                                 Constants.hungerLevels.aboutRight.rawValue,
                                                 Constants.hungerLevels.full.rawValue]
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let partOfASeries = false
        }
        
        struct easeOfFollowingDiet {
            static let question = "How easy was it to stick to the meal plan?"
            static let tableViewList:[String] = [Constants.dietEase.easy.rawValue,
                                                 Constants.dietEase.ok.rawValue,
                                                 Constants.dietEase.hard.rawValue,
                                                 Constants.dietEase.veryHard.rawValue]
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let partOfASeries = false
        }
        
        struct changeNumberOfMeals {
            static let question = "Last week you had 0 meals per day, how many would you like this week?"
            static let tableViewList:[String] = ["Keep the same",
                                                 "2","3","4","5","6","7"]
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let partOfASeries = false
        }
        
        struct anyComments {
            static let question = "Do you have any feedback on how I can make your future meal plans better for you?"
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.text
            static let partOfASeries = false
        }
        
        struct thankyou {
            static let question = "Thanks for your input. I'll create a new meal plan for you now..."
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let partOfASeries = true
        }
        
        struct ending {
            static let question = "All done!"
            static let tableViewList:[String] = []
            static let buttonText : String = "Show me my meal plan"
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
        }
    }
    
    
    struct ONBOARD {
        static let questions : [String] = [
            BotData.ONBOARD.greeting.question,
            BotData.ONBOARD.greeting2.question,
            BotData.ONBOARD.greeting3.question,
            BotData.ONBOARD.wellDone.question,
            BotData.ONBOARD.firstName.question,
            BotData.ONBOARD.firstNameGreeting.question,
            BotData.ONBOARD.gender.question,
            BotData.ONBOARD.goals.question,
            BotData.ONBOARD.age.question,
            BotData.ONBOARD.thanks.question,
            BotData.ONBOARD.weightHeight.question,
            BotData.ONBOARD.thanks.question,
            BotData.ONBOARD.numberOfMeals.question,
            BotData.ONBOARD.dietType.question,
            BotData.ONBOARD.foodPreferences.question,
            BotData.ONBOARD.nearlyThere.question,
            BotData.ONBOARD.activityLevelAtWork.question,
            BotData.ONBOARD.physicalActivity.question,
            BotData.ONBOARD.durationExplanation.question,
            BotData.ONBOARD.duration.question,
            BotData.ONBOARD.notification.question,
            BotData.ONBOARD.notificationWillAppear.question,
            BotData.ONBOARD.ending.question]
        
        static let options : [[String]]  = [
            BotData.ONBOARD.greeting.tableViewList,
            BotData.ONBOARD.greeting2.tableViewList,
            BotData.ONBOARD.greeting3.tableViewList,
            BotData.ONBOARD.wellDone.tableViewList,
            BotData.ONBOARD.firstName.tableViewList,
            BotData.ONBOARD.firstNameGreeting.tableViewList,
            BotData.ONBOARD.gender.tableViewList,
            BotData.ONBOARD.goals.tableViewList,
            BotData.ONBOARD.age.tableViewList,
            BotData.ONBOARD.thanks.tableViewList,
            BotData.ONBOARD.weightHeight.tableViewList,
            BotData.ONBOARD.thanks.tableViewList,
            BotData.ONBOARD.numberOfMeals.tableViewList,
            BotData.ONBOARD.dietType.tableViewList,
            BotData.ONBOARD.foodPreferences.tableViewList,
            BotData.ONBOARD.nearlyThere.tableViewList,
            BotData.ONBOARD.activityLevelAtWork.tableViewList,
            BotData.ONBOARD.physicalActivity.tableViewList,
            BotData.ONBOARD.durationExplanation.tableViewList,
            BotData.ONBOARD.duration.tableViewList,
            BotData.ONBOARD.notification.tableViewList,
            BotData.ONBOARD.notificationWillAppear.tableViewList,
            BotData.ONBOARD.ending.tableViewList]
        
        static let answers : [[String]] = [[String()],
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
                                           [String()]
        ]
        
        static let keyboardType : [Constants.botKeyboardValidationType]  = [
            BotData.ONBOARD.greeting.keyboardType,
            BotData.ONBOARD.greeting2.keyboardType,
            BotData.ONBOARD.greeting3.keyboardType,
            BotData.ONBOARD.wellDone.keyboardType,
            BotData.ONBOARD.firstName.keyboardType,
            BotData.ONBOARD.firstNameGreeting.keyboardType,
            BotData.ONBOARD.gender.keyboardType,
            BotData.ONBOARD.goals.keyboardType,
            BotData.ONBOARD.age.keyboardType,
            BotData.ONBOARD.thanks.keyboardType,
            BotData.ONBOARD.weightHeight.keyboardType,
            BotData.ONBOARD.thanks.keyboardType,
            BotData.ONBOARD.numberOfMeals.keyboardType,
            BotData.ONBOARD.dietType.keyboardType,
            BotData.ONBOARD.foodPreferences.keyboardType,
            BotData.ONBOARD.nearlyThere.keyboardType,
            BotData.ONBOARD.activityLevelAtWork.keyboardType,
            BotData.ONBOARD.physicalActivity.keyboardType,
            BotData.ONBOARD.durationExplanation.keyboardType,
            BotData.ONBOARD.duration.keyboardType,
            BotData.ONBOARD.notification.keyboardType,
            BotData.ONBOARD.notificationWillAppear.keyboardType,
            BotData.ONBOARD.ending.keyboardType]
        
        static let validation : [[[Constants.botContentValidationType:String?]]] = [
            BotData.ONBOARD.greeting.validationTypes,
            BotData.ONBOARD.greeting2.validationTypes,
            BotData.ONBOARD.greeting3.validationTypes,
            BotData.ONBOARD.wellDone.validationTypes,
            BotData.ONBOARD.firstName.validationTypes,
            BotData.ONBOARD.firstNameGreeting.validationTypes,
            BotData.ONBOARD.gender.validationTypes,
            BotData.ONBOARD.goals.validationTypes,
            BotData.ONBOARD.age.validationTypes,
            BotData.ONBOARD.thanks.validationTypes,
            BotData.ONBOARD.weightHeight.validationTypes,
            BotData.ONBOARD.thanks.validationTypes,
            BotData.ONBOARD.numberOfMeals.validationTypes,
            BotData.ONBOARD.dietType.validationTypes,
            BotData.ONBOARD.foodPreferences.validationTypes,
            BotData.ONBOARD.nearlyThere.validationTypes,
            BotData.ONBOARD.activityLevelAtWork.validationTypes,
            BotData.ONBOARD.physicalActivity.validationTypes,
            BotData.ONBOARD.durationExplanation.validationTypes,
            BotData.ONBOARD.duration.validationTypes,
            BotData.ONBOARD.notification.validationTypes,
            BotData.ONBOARD.notificationWillAppear.validationTypes,
            BotData.ONBOARD.ending.validationTypes]
        
        static let buttonText : [String?] = [
            BotData.ONBOARD.greeting.buttonText,
            BotData.ONBOARD.greeting2.buttonText,
            BotData.ONBOARD.greeting3.buttonText,
            BotData.ONBOARD.wellDone.buttonText,
            BotData.ONBOARD.firstName.buttonText,
            BotData.ONBOARD.firstNameGreeting.buttonText,
            BotData.ONBOARD.gender.buttonText,
            BotData.ONBOARD.goals.buttonText,
            BotData.ONBOARD.age.buttonText,
            BotData.ONBOARD.thanks.buttonText,
            BotData.ONBOARD.weightHeight.buttonText,
            BotData.ONBOARD.thanks.buttonText,
            BotData.ONBOARD.numberOfMeals.buttonText,
            BotData.ONBOARD.dietType.buttonText,
            BotData.ONBOARD.foodPreferences.buttonText,
            BotData.ONBOARD.nearlyThere.buttonText,
            BotData.ONBOARD.activityLevelAtWork.buttonText,
            BotData.ONBOARD.physicalActivity.buttonText,
            BotData.ONBOARD.durationExplanation.buttonText,
            BotData.ONBOARD.duration.buttonText,
            BotData.ONBOARD.notification.buttonText,
            BotData.ONBOARD.notificationWillAppear.buttonText,
            BotData.ONBOARD.ending.buttonText]
        
        static let nextSteps : [Constants.botNextSteps] = [
            BotData.ONBOARD.greeting.nextSteps,
            BotData.ONBOARD.greeting2.nextSteps,
            BotData.ONBOARD.greeting3.nextSteps,
            BotData.ONBOARD.wellDone.nextSteps,
            BotData.ONBOARD.firstName.nextSteps,
            BotData.ONBOARD.firstNameGreeting.nextSteps,
            BotData.ONBOARD.gender.nextSteps,
            BotData.ONBOARD.goals.nextSteps,
            BotData.ONBOARD.age.nextSteps,
            BotData.ONBOARD.thanks.nextSteps,
            BotData.ONBOARD.weightHeight.nextSteps,
            BotData.ONBOARD.thanks.nextSteps,
            BotData.ONBOARD.numberOfMeals.nextSteps,
            BotData.ONBOARD.dietType.nextSteps,
            BotData.ONBOARD.foodPreferences.nextSteps,
            BotData.ONBOARD.nearlyThere.nextSteps,
            BotData.ONBOARD.activityLevelAtWork.nextSteps,
            BotData.ONBOARD.physicalActivity.nextSteps,
            BotData.ONBOARD.durationExplanation.nextSteps,
            BotData.ONBOARD.duration.nextSteps,
            BotData.ONBOARD.notification.nextSteps,
            BotData.ONBOARD.notificationWillAppear.nextSteps,
            BotData.ONBOARD.ending.nextSteps
        ]
        
        static let didTAP : [Constants.botDidTap?] = [
            BotData.ONBOARD.greeting.didTap,
            BotData.ONBOARD.greeting2.didTap,
            BotData.ONBOARD.greeting3.didTap,
            BotData.ONBOARD.wellDone.didTap,
            BotData.ONBOARD.firstName.didTap,
            BotData.ONBOARD.firstNameGreeting.didTap,
            BotData.ONBOARD.gender.didTap,
            BotData.ONBOARD.goals.didTap,
            BotData.ONBOARD.age.didTap,
            BotData.ONBOARD.thanks.didTap,
            BotData.ONBOARD.weightHeight.didTap,
            BotData.ONBOARD.thanks.didTap,
            BotData.ONBOARD.numberOfMeals.didTap,
            BotData.ONBOARD.dietType.didTap,
            BotData.ONBOARD.foodPreferences.didTap,
            BotData.ONBOARD.nearlyThere.didTap,
            BotData.ONBOARD.activityLevelAtWork.didTap,
            BotData.ONBOARD.physicalActivity.didTap,
            BotData.ONBOARD.durationExplanation.didTap,
            BotData.ONBOARD.duration.didTap,
            BotData.ONBOARD.notification.didTap,
            BotData.ONBOARD.notificationWillAppear.didTap,
            BotData.ONBOARD.ending.didTap
        ]
        
        struct greeting {
            static let question = "Hey there!"
            static let tableViewList:[String] = []
            static let buttonText : String? = nil
            static let keyboardType = Constants.botKeyboardValidationType.text
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .hurryAlong
        }
        
        struct greeting2 {
            static let question = "Thanks for trying the Meal Plan app, we hope you enjoy it."
            static let tableViewList:[String] = []
            static let buttonText : String? = nil
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .hurryAlong
        }
        
        struct greeting3 {
            static let question = "To create your customised meal plan I need to ask you a few questions. If you see a button that appears tap one of the options 👇"
            static let tableViewList:[String] = ["Option 1", "Option 2"]
            static let buttonText : String? = nil
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .awaitResponse
        }
        
        struct wellDone {
            static let question = "Nice, you're a pro! If you need to type an answer to a question, then the keyboard will appear and you can type away."
            static let tableViewList:[String] = []
            static let buttonText : String? = nil
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .hurryAlong
        }
        
        struct firstName {
            static let question = "My name is Coach, what is your first name?"
            static let tableViewList:[String] = []
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.text
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.minCharacterCount:"2"]
            ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .awaitResponse
        }
        
        struct firstNameGreeting {
            static let question = "Nice to meet you "
            static let tableViewList:[String] = []
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .hurryAlong
        }
        
        
        struct gender {
            static let question = "Let's get started, what is your gender?"
            static let tableViewList:[String] = [Constants.male,
                                                 Constants.female]
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .awaitResponse
        }
        
        
        struct goals {
            static let question = "What are your goals?"
            static let tableViewList:[String] = [Constants.goals.loseWeight.rawValue,
                                                 Constants.goals.gainMuscle.rawValue]
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .awaitResponse
        }
        
        struct age {
            static let question = "Great! What is your age?"
            static let tableViewList:[String] = []
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.number
            static let validationTypes : [[Constants.botContentValidationType:String]] = [
                [.maxValue:"99"],
                [.minValue:"14"],
                ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .awaitResponse
        }
        
        struct weightHeight {
            static let question = "Please enter your height and weight"
            static let tableViewList:[String] = []
            static let buttonText : String? = "Click here"
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let didTap : Constants.botDidTap? = .openHeightWeightScreen
            static let nextSteps : Constants.botNextSteps = .awaitResponse
        }
        
        
        struct thanks {
            static let question = "Thanks "
            static let tableViewList:[String] = []
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .hurryAlong
        }
        
        
        struct numberOfMeals {
            static let question = "How many meals (including snacks) would you like to have per day?"
            static let tableViewList:[String] = []
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.number
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .awaitResponse
        }
        
        
        struct dietType {
            static let question = "Do you have any of these dietary needs?"
            static let tableViewList:[String] = Constants.dietTypes
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .awaitResponse
        }
        
        struct foodPreferences {
            static let question = "Please select the foods that you like or dislike"
            static let tableViewList:[String] = Constants.dietTypes
            static let buttonText : String? = "Let's start"
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let didTap : Constants.botDidTap? = .openFoodPreferencesScreen
            static let nextSteps : Constants.botNextSteps = .awaitResponse
        }
        
        struct nearlyThere {
            static let question = "We're nearly done! I have a few more questions for you, and then I can create your personalised meal plan 😊🤗"
            static let tableViewList:[String] = []
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.decimal
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .hurryAlong
        }
        
        struct activityLevelAtWork {
            static let question = "How active are you at work/college?"
            static let tableViewList:[String] = Constants.activityLevelsAtWork
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.decimal
            static let validationTypes : [[Constants.botContentValidationType:String]] = [
                [.maxCharacterCount:"99"],
                [.minCharacterCount:"14"],
                ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .awaitResponse
        }
        
        struct physicalActivity {
            static let question = "How many hours per week do you spend being active?/nThis includes anything that leaves you out of breath such as jogging, lifting weights, gym classes, or playing a sport."
            static let tableViewList:[String] = []
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.decimal
            static let validationTypes : [[Constants.botContentValidationType:String]] = [
                [.maxValue:"14"],
                [.minValue:"0"],
                ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .awaitResponse
        }
        
        struct durationExplanation {
            static let question = "I recommend that you commit to this meal plan for anywhere between 8 - 20 weeks; the choice is yours."
            static let tableViewList:[String] = []
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .hurryAlong
        }
        
        struct duration {
            static let question = "How many weeks would you like to do this for?"
            static let tableViewList:[String] = []
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.number
            static let validationTypes : [[Constants.botContentValidationType:String]] = [
                [.maxCharacterCount:"26"],
                [.minCharacterCount:"6"],
                ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .awaitResponse
        }
        
        
        struct notification {
            static let question = "Lastly, I'd like to send you an occasional notification to help you with your meal plan. It's customisable and you can stop them whenever you like. Is that okay?"
            static let tableViewList:[String] = [Constants.BOOL_YES,
                                                 Constants.BOOL_NO]
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let didTap : Constants.botDidTap? = nil
            static let nextSteps : Constants.botNextSteps = .awaitResponse
            
        }
        
        struct notificationWillAppear {
            static let question = "Great. In a moment you should see a pop-up asking for permission. Please tap 'OK'"
            static let tableViewList:[String] = []
            static let buttonText : String? = nil
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let nextSteps : Constants.botNextSteps = .awaitResponse
            static let didTap : Constants.botDidTap? = .requestNotificationPermission
        }
        
        struct ending {
            static let question = "You're the best. We're gonna work well together ☺️🙌"
            static let tableViewList:[String] = []
            static let buttonText : String? = "Show me my meal plan"
            static let tips : String = ""
            static let keyboardType = Constants.botKeyboardValidationType.none
            static let validationTypes : [[Constants.botContentValidationType:String?]] = [
                [.none:nil]
            ]
            static let nextSteps : Constants.botNextSteps = .awaitResponse // next steps is what happens once the bubble and its data is displayed.
            static let didTap : Constants.botDidTap? = .quit
        }
    }
}
