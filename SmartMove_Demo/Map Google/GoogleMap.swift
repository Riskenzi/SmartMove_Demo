//
//  GoogleMap.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 26.09.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import UIKit
import GoogleMaps
class GoogleMap: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    let MapApple : Map = Map()
    let marker_img = UIImage(named: "car")
    let car_img = UIImage(named: "marker")
    private var polylineArray:[GMSCircle] = [GMSCircle]() //global variable
    override func viewDidLoad() {
        super.viewDidLoad()
        MapApple.loadJsonFile()
        loadingPoint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         congigStyleMap()
        if CLLocationManager.locationServicesEnabled() == true {
                   if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                       locationManager.requestWhenInUseAuthorization()}
        locationManager.desiredAccuracy = 1.0
        locationManager.delegate = self
        locationManager.startUpdatingLocation()}
        else {print("PLease turn on location services or GPS")}
        mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        
    }
    
    func congigStyleMap(){
    do {
        // Set the map style by passing the URL of the local file.
        if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)} else {
            NSLog("Unable to find style.json")}}
        catch {NSLog("One or more of the map styles failed to load. \(error)")}
    }
    
    func loadingPoint(){
      
        if let poins : NSMutableDictionary = DataManager.sharedCenter.DataPoints{
         for marker in DataManager.sharedCenter.DataPoints{
            let id =  marker.key
            let latitude = ((DataManager.sharedCenter.DataPoints.object(forKey: id) as! PinLocations).coordinateLatitude!)
            let longtitude = ((DataManager.sharedCenter.DataPoints.object(forKey: id) as! PinLocations).coordinateLongitude!)
            let posotion = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
             ///
//            var markerInfo = Dictionary<String, Any>()
//            markerInfo["CarID"] = id
            let marker = GMSMarker(position: posotion)
            marker.userData = id
            marker.icon = drawImageWithProfilePic(pp: marker_img!, image: car_img!)
            marker.appearAnimation = GMSMarkerAnimation.pop
            marker.map = mapView
        
                }
            }
       }
    
   //put this code in your viewController class
    func drawImageWithProfilePic(pp: UIImage, image: UIImage) -> UIImage {
            
           let imgView = UIImageView(image: image)
           imgView.frame = CGRect(x: 0, y: 0, width: 65, height: 65)

           let picImgView = UIImageView(image: pp)
           picImgView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)

           imgView.addSubview(picImgView)
           picImgView.center.x = imgView.center.x
           picImgView.center.y = imgView.center.y - 7
           picImgView.layer.cornerRadius = picImgView.frame.width/2
           picImgView.clipsToBounds = true
           imgView.setNeedsLayout()
           picImgView.setNeedsLayout()

           let newImage = imageWithView(view: imgView)
           return newImage
       }

       func imageWithView(view: UIView) -> UIImage {
           var image: UIImage?
           UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
           if let context = UIGraphicsGetCurrentContext() {
               view.layer.render(in: context)
               image = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
           }
           return image ?? UIImage()
       }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    
        // remove  currently selected marker
        if let selectedMarker = mapView.selectedMarker{
            selectedMarker.icon = drawImageWithProfilePic(pp: marker_img!, image: car_img!)
        }
        // select new marker and make navigation and selected border
        mapView.selectedMarker = marker
        print("user tabed car from id :",marker.userData as! String)
        let userPosition = locationManager.location?.coordinate
        let poinPosition = marker.position
        let marker_img_old = marker.icon
        let image_stoked =  marker_img_old?.stroked(with: .blue, size: 3)
        let marker_img_new = image_stoked?.rotate(radians: .pi)
        marker.icon = marker_img_new
        draw(src: userPosition!, dst: poinPosition)
        return true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
              
              if let location = locations.last {
                mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 14.0)
                locationManager.stopUpdatingLocation() //need fix
              }
    }
          
      //    @IBAction func refLocation(_ sender: Any) {
      //        locationManager.startUpdatingLocation()
      //    }
          
          func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
              print("Unable to access your current location")
          }//current location user
  
    func draw(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D){

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(src.latitude),\(src.longitude)&destination=\(dst.latitude),\(dst.longitude)&sensor=false&mode=walking&key=AIzaSyDNaomwPpfEWP5YIwuK74m8-DNog7v5gho")!

        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {

                        let preRoutes = json["routes"] as! NSArray
                        let routes = preRoutes[0] as! NSDictionary
                        let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                        let polyString = routeOverviewPolyline.object(forKey: "points") as! String

                        DispatchQueue.main.async(execute: {
                            self.showPath(polyStr: polyString)
                        })
                    }

                } catch {
                    print("parsing error")
                }
            }
        })
        task.resume()
    }//draw api
    
    //MARK: Draw polyline

    func showPath(polyStr :String) {
        guard let path = GMSMutablePath(fromEncodedPath: polyStr) else {return}
        //MARK: remove the old polyline from the GoogleMap
        self.removePolylinePath()

        let intervalDistanceIncrement: CGFloat = 10
        let circleRadiusScale = 1 / mapView.projection.points(forMeters: 1, at: mapView.camera.target)
        var previousCircle: GMSCircle?
        for coordinateIndex in 0 ..< path.count() - 1 {
            let startCoordinate = path.coordinate(at: coordinateIndex)
            let endCoordinate = path.coordinate(at: coordinateIndex + 1)
            let startLocation = CLLocation(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude)
            let endLocation = CLLocation(latitude: endCoordinate.latitude, longitude: endCoordinate.longitude)
            let pathDistance = endLocation.distance(from: startLocation)
            let intervalLatIncrement = (endLocation.coordinate.latitude - startLocation.coordinate.latitude) / pathDistance
            let intervalLngIncrement = (endLocation.coordinate.longitude - startLocation.coordinate.longitude) / pathDistance
            for intervalDistance in 0 ..< Int(pathDistance) {
                let intervalLat = startLocation.coordinate.latitude + (intervalLatIncrement * Double(intervalDistance))
                let intervalLng = startLocation.coordinate.longitude + (intervalLngIncrement * Double(intervalDistance))
                let circleCoordinate = CLLocationCoordinate2D(latitude: intervalLat, longitude: intervalLng)
                if let previousCircle = previousCircle {
                    let circleLocation = CLLocation(latitude: circleCoordinate.latitude,
                                                    longitude: circleCoordinate.longitude)
                    let previousCircleLocation = CLLocation(latitude: previousCircle.position.latitude,
                                                            longitude: previousCircle.position.longitude)
                    if mapView.projection.points(forMeters: circleLocation.distance(from: previousCircleLocation),
                                                 at: mapView.camera.target) < intervalDistanceIncrement {
                        continue
                    }
                }
                let circleRadius = 3 * CLLocationDistance(circleRadiusScale)
                let circle = GMSCircle(position: circleCoordinate, radius: circleRadius)
                circle.strokeWidth = 1.0
                circle.strokeColor = UIColor.blue
                circle.fillColor = UIColor.blue
                circle.map = mapView
                circle.userData = "root"
                polylineArray.append(circle)
                previousCircle = circle
            }
        }
    } //path creator


        //MARK: - Removing dotted polyline
        func removePolylinePath() {
        for root: GMSCircle in self.polylineArray {
            if let userData = root.userData as? String,
                userData == "root" {
                root.map = nil
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
