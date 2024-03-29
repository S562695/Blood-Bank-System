
import UIKit

class OtherUserProfileRequested: UIViewController,UITextFieldDelegate {

  @IBOutlet weak var collectionDate: UILabel!
  @IBOutlet weak var diseaseView: DesignableView!
  @IBOutlet weak var status: UITextField!
  @IBOutlet weak var fullName: UITextField!
  @IBOutlet weak var mobile: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var address: UITextField!
  @IBOutlet weak var profileTilte: UILabel!
  var bloodRequestData: BloodRequestData!
  var showForDonor = false
    
    @IBOutlet weak var acceptRequestButton: ButtonWithShadow!
    
    @IBOutlet weak var cancelRequestButton:ButtonWithShadow!
    
    override func viewDidLoad() {
       
        collectionDate.text = "Collection Date \(bloodRequestData.requestTimeString)"
       
       if(showForDonor == true ) {
           
           self.email.text = bloodRequestData.requestByName
           self.fullName.text = bloodRequestData.requestByEmail
           self.mobile.text = bloodRequestData.requestByMobile
           self.address.text = bloodRequestData.requestByAddress ?? ""
           let userType = UserType.Patient.rawValue
           let bloodGroup = bloodRequestData.requestForBloodGroup
           self.profileTilte.text = "\(userType) Of \(bloodGroup) Blood Group"
           self.status.text = "Status - \(bloodRequestData.status!)"
           self.diseaseView.isHidden = true
           self.cancelRequestButton.setTitle("Reject Request", for: .normal)
       }else {
           
           self.email.text = bloodRequestData.requestToEmail
           self.fullName.text = bloodRequestData.requestToName
           self.mobile.text = bloodRequestData.requestToMobile
           self.address.text = bloodRequestData.requestToAddress ?? ""
           let userType = UserType.Donor.rawValue
           let bloodGroup = bloodRequestData.requestForBloodGroup
           self.profileTilte.text = "\(userType) Of \(bloodGroup) Blood Group"
           self.status.text = "Status - \(bloodRequestData.status!)"
           
       }
        
        if(bloodRequestData.status == REQUEST_STATUS_PENDING) {
            self.cancelRequestButton.isHidden = false
            self.acceptRequestButton.isHidden = false
        }else {
            self.cancelRequestButton.isHidden = true
            self.acceptRequestButton.isHidden = true
        }
            
        if(UserDefaultsManager.shared.getUserType() == .Patient) {
            self.acceptRequestButton.isHidden = true
        }
            
        cancelRequestButton.onTap {[self] in
            if self.showForDonor {
                FireStoreManager.shared.changeRequestStatus(request: bloodRequestData, REQUEST_STATUS_REJECTED_BY_DONOR, documentID: bloodRequestData.documentId!) { success in
                    if success {
                        self.navigationController?.popViewController(animated: true)
                        // Show alert for successful status change
                        self.showAlert(message: "The request has been rejected by the donor.")
                       
                    } else {
                        // Show alert for failure
                        self.showAlert(message: "Failed to update request status.")
                    }
                }
            } else {
                FireStoreManager.shared.changeRequestStatus(request: bloodRequestData, REQUEST_STATUS_CANCELLED_BY_RECEIVER, documentID: bloodRequestData.documentId!) { success in
                    if success {
                        self.navigationController?.popViewController(animated: true)
                        // Show alert for successful status change
                        self.showAlert(message: "The request has been cancelled by the receiver.")
                    } else {
                        // Show alert for failure
                        self.showAlert(message: "Failed to update request status.")
                    }
                }
            }
        }

        
        acceptRequestButton.onTap {[self] in
             
            if self.showForDonor {
                FireStoreManager.shared.changeRequestStatus(request: bloodRequestData, PENDING_FROM_ADMIN, documentID: bloodRequestData.documentId!) { success in
                    if success {
                        self.navigationController?.popViewController(animated: true)
                        // Show alert for successful status change
                        self.showAlert(message: "The request has been accepted by you, Its now Pending For Admin Approval.")
                       
                    } else {
                        // Show alert for failure
                        self.showAlert(message: "Failed to update request status.")
                    }
                }
            } else {
                print("NA")
            }
        }
      
  }
   
  @IBAction func onMedical(_ sender: Any) {
      let vc = self.storyboard?.instantiateViewController(withIdentifier:  "DiseaseListVC" ) as! DiseaseListVC
      vc.documentId = bloodRequestData.documentId!
      vc.hideShowButon = true
      self.navigationController?.pushViewController(vc, animated: true)
  }
   
}
