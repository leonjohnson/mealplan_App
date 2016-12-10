//import Foundation
import UIKit


class BotData: NSObject {
    
    var usersName : String?
    var objective : Biographical?
    
    override init(){
        usersName = DataHandler.getActiveUser().name
        objective = DataHandler.getActiveBiographical()
    }
    
    
    //var questions = BotData.THE_QUESTIONS.questions
    //var options = BotData.THE_QUESTIONS.options
    //var answers = BotData.THE_QUESTIONS.answers
    //var validationType = BotData.THE_QUESTIONS.validationType
    
    
    
    /*
    struct THE_QUESTIONS {
        
        
    }
    */
    
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
            BotData.NEW_FOOD.ending.tableViewList]
        
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
            [String()]]
        
        static let validationType : [Constants.botValidationEntryType]  = [
            BotData.NEW_FOOD.name.validation,
            BotData.NEW_FOOD.producer.validation,
            BotData.NEW_FOOD.serving_type.validation,
            BotData.NEW_FOOD.calories.validation,
            BotData.NEW_FOOD.fat.validation,
            BotData.NEW_FOOD.saturated_fat.validation,
            BotData.NEW_FOOD.carbohydrates.validation,
            BotData.NEW_FOOD.sugar.validation,
            BotData.NEW_FOOD.fibre.validation,
            BotData.NEW_FOOD.protein.validation,
            BotData.NEW_FOOD.food_type.validation,
            BotData.NEW_FOOD.ending.validation]
        
            struct name {
                static let question = "Hi! What is the full name of the food?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let validation = Constants.botValidationEntryType.text
            }
            
            struct producer {
                static let question = "Who makes this product?" // manufacter, don't know, blank, some other unuseful answer
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let validation = Constants.botValidationEntryType.text
            }
            
            struct serving_type {
                static let question = "For the nutritional information you're going to enter is it per:"
                static let tableViewList = [Constants.grams,
                                            Constants.ml,
                                            Constants.slice,
                                            "Item (such as per banana or per apple)?"]
                static let buttonText : String = ""
                static let tips : String = ""
                static let validation = Constants.botValidationEntryType.none
            }
            
            struct calories {
                static let question = "Thanks. How many calories are in it?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let validation = Constants.botValidationEntryType.decimal
            }
            
            struct fat {
                static let question = "grams of fat?" //per 100g or 100ml
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let validation = Constants.botValidationEntryType.decimal
            }
            
            struct saturated_fat {
                static let question = "saturated fat?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let validation = Constants.botValidationEntryType.decimal
            }
            
            struct carbohydrates {
                static let question = "and carbohydrates?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let validation = Constants.botValidationEntryType.decimal
            }
            
            struct sugar {
                static let question = "of which are sugar?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let validation = Constants.botValidationEntryType.decimal
            }
            
            struct fibre {
                static let question = "and fibre?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let validation = Constants.botValidationEntryType.decimal
            }
            
            struct protein {
                static let question = "how much protein does this item have?"
                static let tableViewList:[String] = []
                static let buttonText : String = ""
                static let tips : String = ""
                static let validation = Constants.botValidationEntryType.decimal
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
                static let validation = Constants.botValidationEntryType.none
            }
            
            
            
            struct ending {
                static let question = "Thanks! You're all done. 👍"
                static let tableViewList:[String] = []
                static let buttonText : String = "Show me my meal plan"
                static let tips : String = ""
                static let validation = Constants.botValidationEntryType.none
            }
    }
    
    struct FEEDBACK {
        static let questions : [String] = [
            BotData.FEEDBACK.howWasLastWeek.question,
            BotData.FEEDBACK.howHungryWereYou.question,
            BotData.FEEDBACK.anyComments.question,
            BotData.FEEDBACK.ending.question]
        
        static let options : [[String]]  = [
            BotData.FEEDBACK.howWasLastWeek.tableViewList,
            BotData.FEEDBACK.howHungryWereYou.tableViewList,
            BotData.FEEDBACK.anyComments.tableViewList,
            BotData.FEEDBACK.ending.tableViewList]
 
        static let answers : [[String]] = [
            [String()],
            [String()],
            [String()],
            [String()]]
        
        static let validationType  = [
            BotData.FEEDBACK.howWasLastWeek.validation,
            BotData.FEEDBACK.howHungryWereYou.validation,
            BotData.FEEDBACK.anyComments.validation,
            BotData.FEEDBACK.ending.validation]
        
        struct greeting {
            
            /*
            var objectives = ""
            if (objective.addMoreDefinition == true) {
                objectives.append("adding more definition to your physique")
            }
            if objective.looseFat == true{
                objectives.append("lose fat")
            }
            if objective.gainMuscle == true{
                objectives.append("gain muscle")
            }
            if objective.looseFat == true && objective.gainMuscle == true{
                objectives.append("lose fat and gain muscle")
            }
            */
            let question = "Hey! It's meal plan check-in time! This won't take long and is done to ensure your meal plans are going accoridng to plan. I just need to know your weight and get a bit of feedback."
            let tableViewList:[String] = []
            let validation = Constants.botValidationEntryType.text
        }
        
        struct howWasLastWeek {
            static let question = "How much did you weigh this morning?"
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let validation = Constants.botValidationEntryType.decimal
        }
        
        struct howHungryWereYou {
            static let question = "How hungry were you after following last weeks meal plans?"
            static let tableViewList:[String] = [Constants.hungerLevels.veryHungry.rawValue,
                                                 Constants.hungerLevels.littleHungry.rawValue,
                                                 Constants.hungerLevels.aboutRight.rawValue,
                                                 Constants.hungerLevels.full.rawValue]
            static let buttonText : String = ""
            static let tips : String = ""
            static let validation = Constants.botValidationEntryType.none
        }
        
        struct anyComments {
            static let question = "Do you have any feedback on how I can make your future meal plans better for you?"
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let validation = Constants.botValidationEntryType.text
        }
        
        struct thankyou {
            static let question = "Thanks for your input. I'll create a new meal plan for you now..."
            static let tableViewList:[String] = []
            static let buttonText : String = ""
            static let tips : String = ""
            static let validation = Constants.botValidationEntryType.none
        }
        
        struct ending {
            static let question = "All done!"
            static let tableViewList:[String] = []
            static let buttonText : String = "Show me my meal plan"
            static let tips : String = ""
            static let validation = Constants.botValidationEntryType.none
        }
    }

        /*
         static let BOT_QUESTION_NAME = "Hi! What is the full name of the food?" //name
         static let BOT_QUESTION_PRODUCER = "Who makes this product?" // manufacter, don't know, blank, some other unuseful answer
         static let BOT_QUESTION_SERVING_TYPE = "For the nutritional information you're going to enter is it per:\n1.100g \n2.100ml\n3.Slice\n4.Item (such as per banana or per apple)? \nPlease enter the relevant number" //1,2,3 or 4
         static let BOT_QUESTION_CALORIES = "Thanks. How many calories are in it?"
         static let BOT_QUESTION_FAT = "grams of fat?" //per 100g or 100ml
         static let BOT_QUESTION_SATURATED_FAT = "grams of saturated fat?"
         static let BOT_QUESTION_CARBOHYDRATES = "and carbohydrates?"
         static let BOT_QUESTION_SUGAR = "of which are sugar? (type n/a if it's not labelled)"
         static let BOT_QUESTION_FIBRE = "and fibre? (type n/a if it's not labelled)"
         static let BOT_QUESTION_PROTEIN = "how much protein does this item have?"
         static let BOT_QUESTION_FOOD_TYPE = "Please help me categorise this item. \n\nWhich of the following numbers apply to this item? \n\n1.It's a drink 2. It's a fizzy drink\n3.It's a fruit \n4.It's a vegetable \n5.I would eat this at breakfast \n6.I would only eat this at breakfast \n7.This is a type of fish \n8.This is a condiment \n9.None of the above "
         static let BOT_QUESTION_DONE = "Thanks! You're all done now."
         */
    
    
    
    /*
     var questions : [String] = [
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
     BotData.NEW_FOOD.done.question]
     
     var options : [[String]] = [
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
     BotData.NEW_FOOD.done.tableViewList]
     
     
     
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
     BotData.NEW_FOOD.name.validation,
     BotData.NEW_FOOD.producer.validation,
     BotData.NEW_FOOD.serving_type.validation,
     BotData.NEW_FOOD.calories.validation,
     BotData.NEW_FOOD.fat.validation,
     BotData.NEW_FOOD.saturated_fat.validation,
     BotData.NEW_FOOD.carbohydrates.validation,
     BotData.NEW_FOOD.sugar.validation,
     BotData.NEW_FOOD.fibre.validation,
     BotData.NEW_FOOD.protein.validation,
     BotData.NEW_FOOD.food_type.validation,
     BotData.NEW_FOOD.done.validation]
     */
    
}
