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
        static let keyboardType : [Constants.botValidationEntryType]  = [
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
        
            struct name {
                static let question = "Hi! What is the full name of the food?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botValidationEntryType.text
            }
            
            struct producer {
                static let question = "Who makes this product?" // manufacter, don't know, blank, some other unuseful answer
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botValidationEntryType.text
            }
        
            struct food_type {
                static let question = "Please help me categorise this item:"
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
                static let keyboardType = Constants.botValidationEntryType.none
            }
        
            struct serving_type {
                static let question = "For the nutritional information you're going to enter is it per:"
                static let tableViewList = [Constants.grams,
                                            Constants.ml,
                                            Constants.slice,
                                            "Item (such as per banana or per apple)?"]
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botValidationEntryType.none
            }
            
            struct calories {
                static let question = "Thanks. How many calories are in it?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botValidationEntryType.decimal
            }
            
            struct fat {
                static let question = "grams of fat?" //per 100g or 100ml
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botValidationEntryType.decimal
            }
            
            struct saturated_fat {
                static let question = "saturated fat?"
                static let tableViewList:[String] = []
                static let buttonText : String = Constants.no_value_stated
                static let tips : String = ""
                static let keyboardType = Constants.botValidationEntryType.decimal
            }
            
            struct carbohydrates {
                static let question = "and carbohydrates?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botValidationEntryType.decimal
            }
            
            struct sugar {
                static let question = "of which are sugar?"
                static let tableViewList:[String] = []
                static let buttonText : String = Constants.no_value_stated
                static let tips : String = ""
                static let keyboardType = Constants.botValidationEntryType.decimal
            }
            
            struct fibre {
                static let question = "and fibre?"
                static let tableViewList:[String] = []
                static let buttonText : String = Constants.no_value_stated
                static let tips : String = ""
                static let keyboardType = Constants.botValidationEntryType.decimal
            }
            
            struct protein {
                static let question = "how much protein does this item have?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botValidationEntryType.decimal
            }
        
            struct number_of_servings {
                static let question = "How many servings would you like to eat:"
                static let tableViewList : [String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let keyboardType = Constants.botValidationEntryType.decimal
            }
        
            struct ending {
                static let question = "Thanks! You're all done. 👍"
                static let tableViewList:[String] = []
                static let buttonText : String = "Show me my meal plan"
                static let tips : String = ""
                static let keyboardType = Constants.botValidationEntryType.none
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
 
        static let answers : [[String]] = [
            [String()],
            [String()],
            [String()],
            [String()]]
        
        static let keyboardType  = [
            BotData.FEEDBACK.howWasLastWeek.keyboardType,
            BotData.FEEDBACK.howHungryWereYou.keyboardType,
            BotData.FEEDBACK.anyComments.keyboardType,
            BotData.FEEDBACK.easeOfFollowingDiet.keyboardType,
            BotData.FEEDBACK.ending.keyboardType]
        
        struct greeting {
            static let question = "Hey!"
            static let tableViewList:[String] = []
            static let keyboardType = Constants.botValidationEntryType.none
            static let partOfASeries = true
        }
        
        struct update {
            static let question = "Well done! You've completed another week of your new meal plan! 👏"
            static let tableViewList:[String] = []
            static let keyboardType = Constants.botValidationEntryType.none
            static let partOfASeries = true
        }
        
        struct checkin {
            static let question = "To make sure your meal plans are going accoridng to plan, we're going to quickly go over how last week went."
            static let tableViewList:[String] = []
            static let keyboardType = Constants.botValidationEntryType.none
            static let partOfASeries = true

        }
        
        struct howWasLastWeek {
            static let question = "How much did you weigh this morning?"
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.decimal
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
            static let keyboardType = Constants.botValidationEntryType.none
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
            static let keyboardType = Constants.botValidationEntryType.none
            static let partOfASeries = false
        }
        
        struct changeNumberOfMeals {
            static let question = "Last week you had 0 meals per day, how many would you like this week?"
            static let tableViewList:[String] = ["Keep the same",
                                                 "2","3","4","5","6","7"]
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.none
            static let partOfASeries = false
        }
        
        struct anyComments {
            static let question = "Do you have any feedback on how I can make your future meal plans better for you?"
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.text
            static let partOfASeries = false
        }
        
        struct thankyou {
            static let question = "Thanks for your input. I'll create a new meal plan for you now..."
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.none
            static let partOfASeries = true
        }
        
        struct ending {
            static let question = "All done!"
            static let tableViewList:[String] = []
            static let buttonText : String = "Show me my meal plan"
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.none
        }
    }
    
    
    struct ONBOARD {
        static let questions : [String] = [
            BotData.ONBOARD.greeting.question,
            BotData.ONBOARD.firstName.question,
            BotData.ONBOARD.gender.question,
            BotData.ONBOARD.goals.question,
            BotData.ONBOARD.age.question,
            BotData.ONBOARD.weightUnit.question,
            BotData.ONBOARD.weight.question,
            BotData.ONBOARD.heightUnit.question,
            BotData.ONBOARD.height.question,
            BotData.ONBOARD.activityLevelAtWork.question,
            BotData.ONBOARD.physicalActivity.question,
            BotData.ONBOARD.duration.question,
            BotData.ONBOARD.notification.question,
            BotData.ONBOARD.ending.question]
        
        static let options : [[String]]  = [
            BotData.ONBOARD.greeting.tableViewList,
            BotData.ONBOARD.firstName.tableViewList,
            BotData.ONBOARD.gender.tableViewList,
            BotData.ONBOARD.goals.tableViewList,
            BotData.ONBOARD.age.tableViewList,
            BotData.ONBOARD.weightUnit.tableViewList,
            BotData.ONBOARD.weight.tableViewList,
            BotData.ONBOARD.heightUnit.tableViewList,
            BotData.ONBOARD.height.tableViewList,
            BotData.ONBOARD.activityLevelAtWork.tableViewList,
            BotData.ONBOARD.physicalActivity.tableViewList,
            BotData.ONBOARD.duration.tableViewList,
            BotData.ONBOARD.notification.tableViewList,
            BotData.ONBOARD.ending.tableViewList]
        
        static let answers : [[String]] = [
            [String()],
            [String()],
            [String()],
            [String()]]
        
        static let keyboardType  = [
            BotData.ONBOARD.greeting.keyboardType,
            BotData.ONBOARD.firstName.keyboardType,
            BotData.ONBOARD.gender.keyboardType,
            BotData.ONBOARD.goals.keyboardType,
            BotData.ONBOARD.age.keyboardType,
            BotData.ONBOARD.weightUnit.keyboardType,
            BotData.ONBOARD.weight.keyboardType,
            BotData.ONBOARD.heightUnit.keyboardType,
            BotData.ONBOARD.height.keyboardType,
            BotData.ONBOARD.activityLevelAtWork.keyboardType,
            BotData.ONBOARD.physicalActivity.keyboardType,
            BotData.ONBOARD.duration.keyboardType,
            BotData.ONBOARD.notification.keyboardType,
            BotData.ONBOARD.ending.keyboardType]
        
        static let validation = [
            BotData.ONBOARD.greeting.validationTypes
        
        ]
        
        struct greeting {
            static let question = "Hey! Thanks for trying our app, we hope you love it."
            static let tableViewList:[String] = []
            static let keyboardType = Constants.botValidationEntryType.text
            static let validationTypes : [[Constants.botValidationType:String]] = [
                [.maxCharacter:"5"]
            ]
        }
        
        struct firstName {
            static let question = "What is your first name?"
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.text
            static let validationTypes : [[Constants.botValidationType:String]] = [
                [.maxCharacter:"5"]
            ]
        }
        
        
        struct gender {
            static let question = "What is your gender?"
            static let tableViewList:[String] = [Constants.male,
                                                 Constants.female]
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.none
            static let validationTypes : [[Constants.botValidationType:String]] = [
                [.maxCharacter:"5"]
            ]
        }
        
        struct goals {
            static let question = "What are your goals?"
            static let tableViewList:[String] = [Constants.dietEase.easy.rawValue,
                                                 Constants.dietEase.ok.rawValue,
                                                 Constants.dietEase.hard.rawValue,
                                                 Constants.dietEase.veryHard.rawValue]
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.none
            static let validationTypes : [[Constants.botValidationType:String]] = [
                [.maxCharacter:"5"]
            ]
        }
        
        struct age {
            static let question = "What is your age?"
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.number
            static let validationTypes : [[Constants.botValidationType:String]] = [
                [.maxCharacter:"99"],
                [.minCharacter:"14"],
            ]
        }
        
        struct weightUnit {
            static let question = "Do you normally weigh yourself in kg or pounds?"
            static let tableViewList:[String] = [Constants.KILOGRAMS,
                                                 Constants.POUNDS]
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.none
            static let validationTypes : [[Constants.botValidationType:String]] = []
        }
        
        struct weight {
            static let question = "What is your weight?"
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.decimal
            static let validationTypes : [[Constants.botValidationType:String]] = [
                [.maxCharacter:"200"],
                [.minCharacter:"40"],
                ]
        }
        
        struct heightUnit {
            static let question = "How do you prefer to measure your height?"
            static let tableViewList:[String] = ["feet and inches", "centimeters"]
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.decimal
            static let validationTypes : [[Constants.botValidationType:String]] = [
                [.maxCharacter:"99"],
                [.minCharacter:"14"],
                ]
        }
        
        struct height {
            static let question = "What is your height?"
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.none
            static let validationTypes : [[Constants.botValidationType:String]] = [
                [.maxCharacter:"99"],
                [.minCharacter:"14"],
                ]
        }
        
        struct activityLevelAtWork {
            static let question = "How active are you?"
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.decimal
            static let validationTypes : [[Constants.botValidationType:String]] = [
                [.maxCharacter:"99"],
                [.minCharacter:"14"],
                ]
        }
        
        struct physicalActivity {
            static let question = "How many hrs do you spend being active?"
            static let tableViewList:[String] = []
            static let buttonText : String = "Show me my meal plan"
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.none
            static let validationTypes : [[Constants.botValidationType:String]] = [
                [.maxCharacter:"99"],
                [.minCharacter:"14"],
                ]
        }
        
        struct duration {
            static let question = "How many weeks would you like to do this for?"
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.number
            static let validationTypes : [[Constants.botValidationType:String]] = [
                [.maxCharacter:"99"],
                [.minCharacter:"14"],
                ]
        }
        
        struct notification {
            static let question = "Can we send you notifications to remind you?"
            static let tableViewList:[String] = [Constants.BOOL_YES,
                                                 Constants.BOOL_NO]
            static let buttonText : String = ""
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.none
            static let validationTypes : [[Constants.botValidationType:String]] = [
                [.maxCharacter:"99"],
                [.minCharacter:"14"],
                ]
        }
        
        struct ending {
            static let question = "You're the best Leon. We're gonna work well together ☺️🙌"
            static let tableViewList:[String] = []
            static let buttonText : String = "Show me my meal plan"
            static let tips : String = ""
            static let keyboardType = Constants.botValidationEntryType.none
            static let validationTypes : [[Constants.botValidationType:String]] = [
                [.maxCharacter:"99"],
                [.minCharacter:"14"],
                ]
        }
    }

    
}
