import UIKit
protocol dismissedFoodPreferences {
    func foodPreferencesDone()
}
class LikeOrDislike: UIViewController {
    
    enum outcome {
        case like
        case dislike
        case unstated
    }
    
    @IBOutlet var foodLabel : UILabel!
    @IBOutlet var likeButton : UIView!
    @IBOutlet var dislikeButton : UIView!
    @IBOutlet var doneButton : MPButton!
    @IBOutlet var foodImageView : UIImageView!
    
    var data : [Food] = DataHandler.foodsThatRequireRating()
    var index = 0
    var foodsLiked : [Food] = []
    var foodsDisliked : [Food] = []
    var delegate : dismissedFoodPreferences? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNextFood()
        
        let tap = UITapGestureRecognizer(target: self, action:  #selector(LikeOrDislike.likeThisFood))
        likeButton.addGestureRecognizer(tap)
        likeButton.layer.cornerRadius = dislikeButton.frame.width/2
        likeButton.clipsToBounds = true
        
        let tap2 = UITapGestureRecognizer(target: self, action:  #selector(LikeOrDislike.dislikeThisFood))
        dislikeButton.addGestureRecognizer(tap2)
        dislikeButton.layer.cornerRadius = dislikeButton.frame.width/2
        dislikeButton.clipsToBounds = true
        
        doneButton.backgroundColor = Constants.MP_GREEN
        doneButton.layer.cornerRadius = 25
        let doneTitle = NSAttributedString(string:"DONE", attributes:[NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        doneButton.setAttributedTitle(doneTitle, for: .normal)
    }
    
    
    @IBAction func likeThisFood() {
        guard index < data.count else {
            dislikeButton.alpha = 0.3
            likeButton.alpha = 0.3
            return
        }
        foodsLiked.append(data[index])
        index = index + 1
        showNextFood()
    }
    
    @IBAction func dislikeThisFood() {
        guard index < data.count else {
            dislikeButton.alpha = 0.3
            likeButton.alpha = 0.3
            return
        }
        foodsDisliked.append(data[index])
        index = index + 1
        showNextFood()
    }
    
    
    func showNextFood(){
        if index > data.count - 1 {
            updateFoodPreferences()
        } else {
            let name = data[index].name
            if let first_word = name.components(separatedBy: " ").first {
                print("going to look for: \(first_word.lowercased())")
                foodLabel.text = first_word + "?"
                foodImageView.image = UIImage(named: first_word.localizedLowercase)
                if UIImage(named: first_word.localizedLowercase) != nil {
                }
            } else {
                foodLabel.text = data[index].name + "?"
                print("going to look for: \(data[index].name.lowercased())")
                if UIImage(named: data[index].name.lowercased()) != nil {
                    foodImageView.image = UIImage(named: data[index].name.localizedLowercase)
                }
                
            }
        }
    }
    
    func updateFoodPreferences(){
        DataHandler.updateLikeFoods(foodsLiked)
        DataHandler.updateDisLikeFoods(foodsDisliked)
        print("had enough called")
    }
    
    @IBAction func moveOnToNextScreen(){
        //self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "showExplanation", sender: nil)
    }
    
    @IBAction func goBack(){
        _ = self.navigationController?.popViewController(animated: true)
        print("wanna pass this down")
        //self.dismiss(animated: true, completion: nil)
        //self.delegate?.foodPreferencesDone()
        
    }

}
