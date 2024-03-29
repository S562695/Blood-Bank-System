import UIKit
import MapKit

class ChatReceiverLocation: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var unReadMessageCount: UILabel!
    @IBOutlet weak var unReadHeader: UIView!
    @IBOutlet weak var viewButton: UIButton!
    
    func setData(message: MessageModel) {

        let latLongArray = message.text.components(separatedBy: ",")

        // Extract latitude and longitude from the array
        if latLongArray.count == 2,
            let latitude = Double(latLongArray[0]),
            let longitude = Double(latLongArray[1]) {

            print("Latitude: \(latitude), Longitude: \(longitude)")

            // Create a CLLocationCoordinate2D object
            let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            // Set the region of the MKMapView
            let region = MKCoordinateRegion(center: locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)

            // Optionally, add a pin at the location
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            mapView.addAnnotation(annotation)
            
        } else {
            print("Invalid latitude and longitude format")
        }

        self.timeStamp.text = message.dateSent.getFirebaseDateTime()
        
        
        viewButton.onTap {
            
            if latLongArray.count == 2 {
                openMap(userLat: latLongArray[0], userLong: latLongArray[1])
            }
            
        }
    }
}
