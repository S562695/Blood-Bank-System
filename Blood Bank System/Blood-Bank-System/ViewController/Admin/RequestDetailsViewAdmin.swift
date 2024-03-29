 
import UIKit

class RequestDetailsViewAdmin: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var collectionDate: UILabel!
  @IBOutlet weak var diseaseView: DesignableView!
  @IBOutlet weak var receiverName: UITextField!
  @IBOutlet weak var mobile: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var address: UITextField!
  @IBOutlet weak var bloodGroup: UITextField!

    @IBOutlet weak var donorName: UITextField!
    @IBOutlet weak var donorEmail: UITextField!
    @IBOutlet weak var donorMobile: UITextField!
    @IBOutlet weak var donorAddress: UITextField!
    @IBOutlet weak var donorBloodGroup: UITextField!
    
    var bloodRequestData: BloodRequestData!
  
    @IBOutlet weak var acceptRequestButton: ButtonWithShadow!
    
    @IBOutlet weak var cancelRequestButton:ButtonWithShadow!
    
    override func viewDidLoad() {
       
        collectionDate.text = "Collection Date \(bloodRequestData.requestTimeString)"
        statusLabel.text = bloodRequestData.status
     
           self.receiverName.text = bloodRequestData.requestByName
           self.email.text = bloodRequestData.requestByEmail
           self.mobile.text = bloodRequestData.requestByMobile
           self.address.text = bloodRequestData.requestByAddress ?? ""
           self.bloodGroup.text = bloodRequestData.requestForBloodGroup
        
           
           self.donorEmail.text = bloodRequestData.requestToEmail
           self.donorName.text = bloodRequestData.requestToName
           self.donorMobile.text = bloodRequestData.requestToMobile
           self.donorAddress.text = bloodRequestData.requestToAddress ?? ""
           self.donorBloodGroup.text = bloodRequestData.requestForBloodGroup
     
        
        if(bloodRequestData.status == PENDING_FROM_ADMIN ) {
            self.cancelRequestButton.isHidden = false
            self.acceptRequestButton.isHidden = false
        }else {
            self.cancelRequestButton.isHidden = true
            self.acceptRequestButton.isHidden = true
        }
            
        
         
      
            
        cancelRequestButton.onTap {[self] in
            
            FireStoreManager.shared.changeRequestStatus(request: bloodRequestData, Cancelled_BY_ADMIN, documentID: bloodRequestData.documentId!) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                    // Show alert for successful status change
                    self.showAlert(message: "The request has been Rejected by you.")
                   
                } else {
                    // Show alert for failure
                    self.showAlert(message: "Failed to update request status.")
                }
            }
        }

        
        acceptRequestButton.onTap {[self] in
             
            FireStoreManager.shared.changeRequestStatus(request: bloodRequestData, APPROVED_BY_ADMIN, documentID: bloodRequestData.documentId!) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                    // Show alert for successful status change
                    self.showAlert(message: "The request has been approved by you.")
                   
                } else {
                    // Show alert for failure
                    self.showAlert(message: "Failed to update request status.")
                }
            }
        }
      
  }
 
    @IBAction func onDisease(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "DiseaseListVC" ) as! DiseaseListVC
        vc.documentId = bloodRequestData.documentId!
        vc.hideShowButon = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
