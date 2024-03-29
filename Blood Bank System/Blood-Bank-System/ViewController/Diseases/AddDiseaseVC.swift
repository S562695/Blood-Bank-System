
import UIKit

class AddDiseaseVC: UIViewController {
  
    @IBOutlet weak var diseaseTitle: UITextField!
    @IBOutlet weak var details: UITextView!
  
   
   @IBAction func onAdd(_ sender: Any) {
       
       if self.diseaseTitle.text!.isEmpty{
            showAlerOnTop(message: "Please add Title")
            return
       }
       
       if self.details.text!.isEmpty{
            showAlerOnTop(message: "Please add Details")
            return
       }
       
       
       FireStoreManager.shared.addDesises(desisesTitle: self.diseaseTitle.text!, details: self.details.text!) { success in
           showAlerOnTop(message: "Added Successfully")
           self.navigationController?.popViewController(animated: true)
       }
       
     }
       
   }


