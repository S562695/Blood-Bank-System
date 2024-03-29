 
import UIKit


struct Faq:Codable {
    var faqTitle: String
    var details: String
}


class FaqVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var faqs = [Faq]()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Adding FAQs to the array
            faqs.append(Faq(faqTitle: "Is there a way for donors and recipients to communicate directly within the app?", details: "Yes, the app facilitates communication between donors and recipients through a chat or messaging tool. Donors and recipients can interact, discuss donation details, and coordinate logistics directly within the app, enhancing communication and ensuring seamless blood donation transactions."))
            
            faqs.append(Faq(faqTitle: "How can I reach out for assistance in case of an emergency?", details: "In case of an emergency, users can easily reach out for assistance through the app. The app provides contact information for emergency services, blood banks, and support hotlines, allowing users to quickly access help and resources when needed most. Additionally, users can utilize the live chat functionality to connect with staff for immediate assistance."))
            
            faqs.append(Faq(faqTitle: "How can I update my profile information as a donor or patient?", details: "You can update your profile information by accessing the profile management feature within the app. From there, you can edit and save changes to your personal details, including contact information and medical history."))
            
            faqs.append(Faq(faqTitle: "Can users provide feedback or reviews about their donation experience?", details: "Absolutely, the system permits users to critique and grade their donation experience. Donors and recipients can share their feedback, rate their experience, and provide comments to help improve the blood donation process and overall user satisfaction."))
            
            faqs.append(Faq(faqTitle: "How does the app ensure the security and privacy of user data?", details: "The app employs robust security measures to safeguard user data and ensure privacy protection. This includes encryption protocols, secure authentication methods, and adherence to data protection regulations. Additionally, access to sensitive information is restricted to authorized personnel only."))
            
            faqs.append(Faq(faqTitle: "What happens if I receive a notification about a blood donation request but cannot fulfill it?", details: "If you receive a notification but are unable to fulfill the blood donation request, you can communicate directly with the requester through the app's messaging tool. Clear communication ensures understanding and facilitates coordination with other potential donors."))
            
            faqs.append(Faq(faqTitle: "Can donors and recipients view each other's profiles before engaging in communication?", details: "Yes, the app allows donors and recipients to view each other's profiles before initiating communication. This transparency ensures that both parties have access to relevant information before engaging in blood donation-related discussions."))
            
            // Registering cells and setting up delegate and data source
            self.tableView.registerCells([DiseaseListCell.self])
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }

        
 }
    



extension FaqVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DiseaseListCell") as! DiseaseListCell
        cell.setData(title: faqs[indexPath.row].faqTitle, desc: faqs[indexPath.row].details)
        return cell
    }

}
