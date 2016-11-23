import UIKit
import JSQMessagesViewController

class outCells: JSQMessagesCollectionViewCellOutgoing, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var questionTextView : UITextView!
    @IBOutlet var table : UITableView!
    var question : String = String()
    var data : (question:String, options:[String]) = ("",[])
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("super.awakeFromNib() called")
        
        table.register(UINib(nibName: "miniTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.table.dataSource = self
        self.table.delegate = self
        self.table.allowsSelection = true
        self.table.isUserInteractionEnabled = true

        self.messageBubbleTopLabel.textAlignment = .center
        self.tapGestureRecognizer.cancelsTouchesInView = false
     
        
        self.cellBottomLabel.textAlignment = .right
        self.questionTextView.textColor = UIColor.black
        self.questionTextView.sizeToFit()
        
        
        //print("size of bubble is: \(self.messageBubbleImageView.image?.size)")
        
        
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
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let q = Constants.BOT_NEW_FOOD.serving_type.question
        let options = Constants.BOT_NEW_FOOD.serving_type.tableViewList
        table.frame = CGRect(x:Int(table.frame.origin.x),y:Int(table.frame.origin.y),width:Int(table.frame.width), height:((options.count * 44)+5))//
        if question == q {
            return options.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        print("trying to place row number: \(indexPath.row)")
        print("data.options: \(data.options)")
        cell.textLabel?.text = data.options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TABLE SELECTED .")
        
        let currentRowAccessory = table.cellForRow(at: indexPath)?.accessoryType
        let newRowAccessory = (currentRowAccessory == UITableViewCellAccessoryType.checkmark) ? UITableViewCellAccessoryType.none : UITableViewCellAccessoryType.checkmark
        tableView.cellForRow(at: indexPath)?.accessoryType = newRowAccessory
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34
    }
    
    
    /*
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let hitView = super.hitTest(point, with: event)
        
        let ip = table.indexPathForRow(at: point)
        print("ip = \(ip)\n")
        
        if (hitView is JSQMessagesCollectionViewCellOutgoing) {
            print("table view cell.... : \((hitView as! UITableViewCell).textLabel?.text)")
            return nil
        }
        if (hitView is UITableView) {
            print("table view getting hit")
            return hitView
        }
        
        if (hitView is UITableViewCell) {
            print("table view CELL getting hit")
            return hitView
        }
        
        if (hitView is UILabel) {
            print("text is: \((hitView as! UILabel).text)")
            return hitView
        }
        
        print("not self: \(hitView)")
        return super.hitTest(point, with: event)
    }
    */
}


    
    
    


