import UIKit

class DiseaseListCell: UITableViewCell {

    @IBOutlet weak var diseasTitle: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var diseeasDes: UILabel!
    
    override func awakeFromNib() {
        bgView.dropShadow()
    }
    func setData(title:String,desc:String) {
        
        self.diseasTitle.text = title
        self.diseeasDes.text = desc
        
    }
    
}
