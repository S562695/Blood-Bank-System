 
import UIKit

struct Disease : Codable {
    var desisesTitle: String
    var details: String
}

class DiseaseListVC: UIViewController {

    @IBOutlet weak var addButton: ButtonWithShadow!
    @IBOutlet weak var tableView: UITableView!
    var documentId = ""
    var disease = [Disease]()
    var hideShowButon = false
    
    override func viewDidLoad() {
        self.addButton.isHidden = hideShowButon
        self.tableView.registerCells([DiseaseListCell.self])
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.disease.removeAll()
        
        FireStoreManager.shared.getAllDesises(documentId: documentId) { disease in
            self.disease.removeAll()
            self.disease = disease
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onAdd(_ sender: Any) {
        
    }
    
}



extension DiseaseListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disease.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DiseaseListCell") as! DiseaseListCell
        cell.setData(title: disease[indexPath.row].desisesTitle, desc: disease[indexPath.row].details)
        return cell
    }
}
