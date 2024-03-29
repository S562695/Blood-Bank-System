import UIKit
import FirebaseFirestore

class CometChatSenderTextMessageBubble: UITableViewCell {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
     
    @IBOutlet weak var readUnRead: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
   
    func setData(message:MessageModel) {
     
       
            self.message.text = message.text
      
        
//        self.timeStamp.text =  (AuthManager.getLastSavedLoginDetails()?.mobileNo)! + " " +  message.dateSent.getFirebaseDateTime()
//
        self.timeStamp.text =   message.dateSent.getFirebaseDateTime()
        
    }
    
}
    
    
 

