 
import UIKit

class CommonUpdateVC: UIViewController {
   
    var changeFor = ""
    var oldValue = ""
    
    @IBOutlet weak var upDateTitle: UILabel!
    @IBOutlet weak var commonField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upDateTitle.text = "Update \(changeFor)"
        self.commonField.placeholder = changeFor
        self.commonField.text = oldValue
    }
    
    @IBAction func onUpdate(_ sender: Any) {
        
        if self.commonField.text!.isEmpty{
             showAlerOnTop(message: "Please enter \(changeFor)")
             return
         }
         else {
             
             if changeFor.lowercased() == "mobile" {
                 
                 
                 if self.commonField.text!.count != 10 {
                     showAlerOnTop(message: "Please enter a valid mobile number with exactly 10 digits")
                     return
                 }
                 
                 if !self.commonField.text!.allSatisfy({ $0.isNumber }) {
                     showAlerOnTop(message: "Please enter a valid mobile number with exactly 10 digits")
                     return
                 }
                 
             }
             
             let documentid = UserDefaults.standard.string(forKey: "documentId") ?? ""
             let userdata = [changeFor.lowercased(): self.commonField.text ?? ""]
             FireStoreManager.shared.updateData(documentid: documentid, userData: userdata) { success in
                 if success {
                     if(self.changeFor.lowercased() == "address") {
                         UserDefaultsManager.shared.saveAddress(address: self.commonField.text!)
                     }
                     showAlerOnTop(message: "\(self.changeFor) Updated Successfully")
                     self.navigationController?.popViewController(animated: true)
                 }
             }
             
             
            
         }
        
    }
    
    
}
