//
//  GoogleMap.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 26.09.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import Alamofire
class GoogleMap: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    let MapApple : Map = Map()
    var polyline : GMSPolyline? = nil
    var circle : GMSCircle? = nil
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
            let image = UIImage(named: "rapper")
            marker.icon = self.imageWithImage(image: image!, scaledToSize:  CGSize(width: 35, height: 35))
            marker.userData = id
            marker.map = mapView
            
                }
            }
       }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        print("user tabed car from id :",marker.userData as! String)
        let userPosition = locationManager.location?.coordinate
        let poinPosition = marker.position
    
        draw(src: userPosition!, dst: poinPosition)
        return true
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        //image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
        image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))  )
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
              
              if let location = locations.last {
                mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 14.0)
                //locationManager.stopUpdatingLocation()
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
                            let path = GMSPath(fromEncodedPath: polyString)
                            self.polyline?.map = nil
                            self.polyline = GMSPolyline(path: path)
                            self.polyline?.strokeWidth = 5.0
                            self.polyline?.strokeColor = UIColor.blue
                            self.polyline?.map = self.mapView
                            
                            
                        })
                    }

                } catch {
                    print("parsing error")
                }
            }
        })
        task.resume()
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
