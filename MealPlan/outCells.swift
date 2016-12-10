import UIKit
import JSQMessagesViewController

class outCells: JSQMessagesCollectionViewCellOutgoing, UITableViewDelegate, UITableViewDataSource, OutgoingCellDelegate {

    @IBOutlet var questionTextView : JSQMessagesCellTextView?
    @IBOutlet var table : UITableView!
    var question : String = String()
    var data : (question:String, options:[String]) = ("",[])
    
    var botDelegate: BotDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        table.register(UINib(nibName: "miniTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.table.dataSource = self
        self.table.delegate = self
        self.table.allowsSelection = true
        self.table.isUserInteractionEnabled = true
        self.table.allowsMultipleSelection = false
        self.questionTextView?.attributedText = NSAttributedString(string: "", attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_WHITE])
        self.messageBubbleTopLabel.textAlignment = .center
        self.tapGestureRecognizer.cancelsTouchesInView = false
        self.cellBottomLabel.textAlignment = .right

        }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.messageBubbleContainerView.frame = CGRect(x: self.messageBubbleContainerView.frame.origin.x, 
                                                       y: self.messageBubbleContainerView.frame.origin.y, 
                                                       width: self.messageBubbleContainerView.frame.width, 
                                                       height: CGFloat(300 + (data.options.count * Int(Constants.TABLE_ROW_HEIGHT_SMALL))))
        
        for row in 0...data.options.count {
            self.table.cellForRow(at: [0, row])?.accessoryType = UITableViewCellAccessoryType.none
        }
        
        table.contentInset = Constants.TABLE_INSETS

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
        print("init'ed")
    }
    
    func rowSelected(labelValue: String, withQuestion: String, addOrDelete:UITableViewCellAccessoryType) {
        print("row selected in Outcell: \(labelValue)")
        botDelegate?.originalrowSelected(labelValue: labelValue, withQuestion: withQuestion, addOrDelete:addOrDelete)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.options.count
        
        //table.frame = CGRect(x:Int(table.frame.origin.x),y:Int(table.frame.origin.y),width:Int(table.frame.width), height:((data.options.count * 44)+5))//
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! miniTableViewCell
        
        cell.textLabel?.attributedText = NSAttributedString(string: data.options[indexPath.row], attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_WHITE])
        cell.outgoingCellDelegate = self
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
        
        let currentCell = tableView.cellForRow(at: indexPath)
        let currentRowAccessory = table.cellForRow(at: indexPath)?.accessoryType
        
        let newRowAccessory = (currentRowAccessory == UITableViewCellAccessoryType.checkmark) ? UITableViewCellAccessoryType.none : UITableViewCellAccessoryType.checkmark
        
        
        for row in 0...data.options.count {
                tableView.cellForRow(at: [indexPath.section, row])?.accessoryType = UITableViewCellAccessoryType.none
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = newRowAccessory
        (tableView.cellForRow(at: indexPath) as! miniTableViewCell).outgoingCellDelegate?.rowSelected(labelValue: (currentCell?.textLabel?.text)!, withQuestion: question, addOrDelete: newRowAccessory)
        
        
        
        // if unselected, deselect everything else and select this row
        //if selected, unselect it
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TABLE_ROW_HEIGHT_SMALL
    }

}


    
    
    


