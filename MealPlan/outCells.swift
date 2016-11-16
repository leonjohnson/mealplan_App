import UIKit
import JSQMessagesViewController

class outCells: JSQMessagesCollectionViewCellOutgoing, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var questionTextView : UITextView!
    @IBOutlet var table : UITableView!
    var question : String = String()
    var theType : Constants.BOT_NEW_FOOD.Type = Constants.BOT_NEW_FOOD.self
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        table.register(UINib(nibName: "miniTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.table.dataSource = self
        self.table.delegate = self
        self.messageBubbleTopLabel.textAlignment = .center
        //self.cellBottomLabel.textAlignment = .right
        self.questionTextView.backgroundColor = UIColor.purple
        self.questionTextView.textColor = UIColor.white
        
        
        //self.messageBubbleContainerView.frame = CGRect(x: self.messageBubbleContainerView.frame.origin.x, y: self.messageBubbleContainerView.frame.origin.y, width: self.messageBubbleContainerView.frame.width, height: 300)
        }
    
    override class func nib() -> UINib {
        return UINib(nibName: "outCell", bundle: nil)
    }
    
    override class func mediaCellReuseIdentifier() -> String {
        return "CustomMessagesCollectionViewCellIncoming"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.messageBubbleContainerView.frame = CGRect(x: self.messageBubbleContainerView.frame.origin.x, y: self.messageBubbleContainerView.frame.origin.y, width: self.messageBubbleContainerView.frame.width, height: 300)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let q = Constants.BOT_NEW_FOOD.serving_type.question
        let options = Constants.BOT_NEW_FOOD.serving_type.tableViewList
        if question == q {
            return options.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let q = Constants.BOT_NEW_FOOD.serving_type.question
        let options = Constants.BOT_NEW_FOOD.serving_type.tableViewList
        if question == q {
            cell.textLabel?.text = options[indexPath.row]
        }
        
        
        //let currentMessage =
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TOUCHED ROW")
    }
    

    
    
}
    
    
    


