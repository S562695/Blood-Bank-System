 
import UIKit

class OtherUserProfileVC: UIViewController,UITextFieldDelegate {

  
   @IBOutlet weak var fullName: UITextField!
   @IBOutlet weak var mobile: UITextField!
   @IBOutlet weak var email: UITextField!
   @IBOutlet weak var address: UITextField!
   @IBOutlet weak var profileTilte: UILabel!
   var user: User!
   @IBOutlet weak var requestButton: ButtonWithShadow!
    override func viewDidLoad() {
       self.email.text = user.email
       self.fullName.text = user.name
       self.mobile.text = user.mobile
       self.address.text = user.address ?? ""
       let userType = user.userType
       let bloodGroup = user.bloodGroup
       self.profileTilte.text = "\(userType!) \(bloodGroup!) Blood Group"
        
        if(UserDefaultsManager.shared.getUserType() == .Admin) {
            requestButton.setTitle("Chat", for: .normal)
        }
       
   }
    
   @IBAction func onMedical(_ sender: Any) {
       let vc = self.storyboard?.instantiateViewController(withIdentifier:  "DiseaseListVC" ) as! DiseaseListVC
       vc.documentId = user.documentId!
       vc.hideShowButon = true
       self.navigationController?.pushViewController(vc, animated: true)
   }
    
    
   
  @IBAction func onRequestBlood(_ sender: Any) {
      
      
      if(UserDefaultsManager.shared.getUserType() == .Admin) {
          
          let contact = user!
          let mobileNumber = contact.mobile!
          let formattedNumber = formatPhoneNumber(mobileNumber)
          print(formattedNumber)
          
          if mobileNumber.contains(getMyFormatedMobile())  {
              showAlert(message: "Can't send chat to self")
              return
          }
          
          
          let chatId = getChatID(email1: getMobile(), email2: formattedNumber)
          
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
          vc.chatID = chatId
          vc.chatWithName = contact.name!
          vc.sendToMobile = formattedNumber
          vc.modalPresentationStyle = .fullScreen
          self.navigationController?.pushViewController(vc, animated: true)
       }
      else {
          
          if(UserDefaultsManager.shared.getAddress().isEmpty) {
              showAlert(message: "Please update your address")
              return
          }
          FireStoreManager.shared.haveAlreadyRequested(requestTo: user.mobile!) { err,bloodRequests in
               
              if(bloodRequests?.count != 0) {
                  showAlerOnTop(message: "Already Requested")
              }else {
                  self.proceedRequest()
              }
              
          }
          
      }
      
  }
    
    func proceedRequest(){
        
        showConfirmationAlert(message: "Schedule Timing And Request For Blood Collect?") { _ in
           
            let dateTimePicker = GlobalDateTimePicker()
            dateTimePicker.uIDatePickerMode = .dateAndTime
            dateTimePicker.modalPresentationStyle = .overCurrentContext
            dateTimePicker.onDone = { date in
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy HH:mm"
                let dateString = formatter.string(from: date)
                print("Selected date: \(dateString)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    
                    showConfirmationAlert(message: "Confirm Request For Blood Collect at \(dateString)") { [self] _ in
                        
                        let timeStampDouble = date.timeIntervalSince1970
                        
                        let data = ["createdAt" : Date().timeIntervalSince1970,  "requestTimeStamp" : timeStampDouble , "requestTimeString" : dateString , "requestByName" : UserDefaultsManager.shared.getName(),"requestByMobile" : getMobile(),"requestByEmail" : UserDefaultsManager.shared.getEmail(),"status" : REQUEST_STATUS_PENDING , "requestToMobile" : self.user.mobile!, "requestToName" : user.name! , "requestToEmail" : user.email! , "requestForBloodGroup" : user.bloodGroup! , "requestToAddress" : user.address ?? "","requestByAddress" : UserDefaultsManager.shared.getAddress()]
                         
                     
                        
                        FireStoreManager.shared.addBloodRequest(requestTo: self.user.mobile!, data: data) { value in
                             
                            if(value) {
                                
//                                showAlerOnTop(message: "Requested Successfully")
                                self.showRatingDialog()
                                self.navigationController?.popViewController(animated: true)
                                
                            }else {
                                self.showAlert(message: "Already Requested")
                            }
                            
                        }
                      
                        
                    }
                    
                })
                

            }
            
           dateTimePicker.modalPresentationStyle = .overCurrentContext

           self.present(dateTimePicker, animated: true, completion: nil)
            
        }
       
    }
 
}


extension OtherUserProfileVC {
    
    
    func showRatingDialog() {
        let alertController = UIAlertController(title: "Rate the App", message: "Thank you for using our app! Please take a moment to rate your experience.", preferredStyle: .alert)

        // Add buttons for rating
        alertController.addAction(UIAlertAction(title: "⭐️", style: .default) { _ in
            // User tapped one star
            // Handle the rating logic accordingly
            self.handleRating(1)
        })
        
        alertController.addAction(UIAlertAction(title: "⭐️⭐️", style: .default) { _ in
            // User tapped two stars
            // Handle the rating logic accordingly
            self.handleRating(2)
        })

        alertController.addAction(UIAlertAction(title: "⭐️⭐️⭐️", style: .default) { _ in
            // User tapped three stars
            // Handle the rating logic accordingly
            self.handleRating(3)
        })

        alertController.addAction(UIAlertAction(title: "⭐️⭐️⭐️⭐️", style: .default) { _ in
            // User tapped four stars
            // Handle the rating logic accordingly
            self.handleRating(4)
        })

        alertController.addAction(UIAlertAction(title: "⭐️⭐️⭐️⭐️⭐️", style: .default) { _ in
            // User tapped five stars
            // Handle the rating logic accordingly
            self.handleRating(5)
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present the alertController
        self.present(alertController, animated: true, completion: nil)
    }

    // Function to handle the selected rating
    func handleRating(_ rating: Int) {
        // Implement logic to handle the selected rating
        // You can send the rating to a server, store it locally, etc.
        print("User rated the app with \(rating) star(s)")

        // Show a thank you message based on the rating
        var thankYouMessage = ""

        switch rating {
            case 1:
                thankYouMessage = "We're sorry to hear that. How can we improve? 🙁"
            case 2:
                thankYouMessage = "Thank you for your feedback. We appreciate it. 😊"
            case 3:
                thankYouMessage = "Glad you had an okay experience. Any suggestions for improvement? 🤔"
            case 4:
                thankYouMessage = "Thank you for your positive feedback! We're happy to hear that. 😃"
            case 5:
                thankYouMessage = "Wow! Thanks for the amazing rating. We're thrilled to have made your experience great. 🌟"
            default:
                break
       }
       showAlert(message: thankYouMessage)
    }
    
}
