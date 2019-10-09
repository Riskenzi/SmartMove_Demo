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
    @IBOutlet weak var ViewCars: UIView!
    ///view info
    @IBOutlet weak var time: UILabel!
    
    
    @IBOutlet weak var distantion: UILabel!
    
    
    @IBOutlet weak var CarName: UILabel!
    
    
    @IBOutlet weak var CarNumber: UILabel!
    
    @IBOutlet weak var ButtonCarDetail: UIButton! { didSet {
        ButtonCarDetail.layer.masksToBounds = false
        ButtonCarDetail.layer.cornerRadius = ButtonCarDetail.frame.width / 2
        ButtonCarDetail.layer.borderColor = UIColor.white.cgColor
        ButtonCarDetail.layer.borderWidth = 4
        }
    }
    
    @IBOutlet weak var ButtonDriving: UIButton!{ didSet {
    ButtonDriving.layer.masksToBounds = false
    ButtonDriving.layer.cornerRadius = ButtonCarDetail.frame.width / 3
        }
    }
    
    @IBOutlet weak var ButtonWalking: UIButton!{ didSet {
    ButtonWalking.layer.masksToBounds = false
    ButtonWalking.layer.cornerRadius = ButtonCarDetail.frame.width / 3
        }
    }
    
    //////
    @IBOutlet weak var mapView: GMSMapView!
//CarInfo
    
    var CarNameStr : String = ""
    var CarNumberStr : String = ""
    var timeRound : String = ""
    var distRoud : String = ""
    var CarPosition : CLLocationCoordinate2D?
    var CarSelectID : String = ""

// MARK: CarLiveView
    @IBOutlet weak var CarLiveView: UIView!
    
    @IBOutlet weak var navItemTitle: UINavigationItem!
    
    @IBOutlet weak var CarLiveName: UILabel!
    
    @IBOutlet weak var CarLiveNumber: UILabel!
    
    @IBOutlet weak var CarLiveColor: UILabel!
    
    @IBOutlet weak var CarLiveImage: UIImageView!
    
    @IBOutlet weak var CarLiveDriving: UIButton!{ didSet {
    CarLiveDriving.layer.masksToBounds = false
    CarLiveDriving.layer.cornerRadius = CarLiveDriving.frame.width / 2
        }
    }
    
    @IBOutlet weak var CarLiveWalking: UIButton!{ didSet {
    CarLiveWalking.layer.masksToBounds = false
    CarLiveWalking.layer.cornerRadius = CarLiveWalking.frame.width / 2
        }
    }
    
    @IBOutlet weak var CarLiveTime: UILabel!
    
    
    @IBOutlet weak var StatusBarMaskView: UIView!
    
    
    @IBOutlet weak var CarLiveViewRouting: UIView!
    
    
//
    
    var locationManager = CLLocationManager()
    let MapApple : Map = Map()
    let marker_img = UIImage(named: "car")
    let car_img = UIImage(named: "marker")
    public var polylineArray:[GMSCircle] = [GMSCircle]() //global variable
    override func viewDidLoad() {
        super.viewDidLoad()
        MapApple.loadJsonFile()
        loadingPoint()
    }//MARK: viewDidLoad
    
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
        self.mapView.addSubview(ViewCars)
        self.mapView.addSubview(ButtonCarDetail)
        self.mapView.addSubview(CarLiveView)
        self.mapView.addSubview(StatusBarMaskView)
        self.mapView.addSubview(CarLiveViewRouting)
        ViewCars.isHidden = true
        //MARK: ViewCars hide
        ButtonCarDetail.isHidden = true
        
        CarLiveView.isHidden = true
        
        StatusBarMaskView.isHidden = true
        CarLiveViewRouting.isHidden = true
        //MARK: buttoncardetail hide
    }
    
    
    func loadingPoint(){
      //MARK: loading point
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
    
    func AnimationManager(View : UIView , Button : UIButton, mode : String, BarView : UIView,RoutingView : UIView){
        switch mode {
        case "delete":
            UIView.animate(withDuration: 0.3, animations: {
                      View.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                      View.alpha = 0
                      Button.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                      Button.alpha = 0
                   }){(success: Bool) in
                      View.isHidden = true
                      Button.isHidden = true
                   }
        case "show":
            View.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                   View.alpha = 0
                   Button.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                   Button.alpha = 0
                   UIView.animate(withDuration: 0.4){
                       View.alpha = 1
                       View.transform = CGAffineTransform.identity
                       Button.alpha = 1
                       Button.transform = CGAffineTransform.identity
                   }
                   View.isHidden = false
                   Button.isHidden = false
        case "deleteLive" :
            UIView.animate(withDuration: 0.3, animations: {
                       View.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                       View.alpha = 0
                       BarView.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                       BarView.alpha = 0
                       RoutingView.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                       RoutingView.alpha = 0}){(success: Bool) in
                           View.isHidden = true
                           BarView.isHidden = true
                           RoutingView.isHidden = true
                       }
        case "showLive" :
            View.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
            View.alpha = 0
            BarView.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
            BarView.alpha = 0
            UIView.animate(withDuration: 0.4){
                              View.alpha = 1
                              View.transform = CGAffineTransform.identity
                              BarView.alpha = 1
                              BarView.transform = CGAffineTransform.identity
                     }
            View.isHidden = false
            BarView.isHidden = false
        default:
            print("default")
        }
        
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //MARK: Did tap
        //MARK:  remove  currently selected marker
        if let selectedMarker = mapView.selectedMarker{
            
            if selectedMarker.userData != nil{
            selectedMarker.icon = drawImageWithProfilePic(pp: marker_img!, image: car_img!)
                AnimationManager(View: self.ViewCars, Button: self.ButtonCarDetail, mode: "delete", BarView: self.StatusBarMaskView, RoutingView: self.CarLiveViewRouting)
            }
        }
        //MARK:  select new marker and make navigation and selected border
      
        mapView.selectedMarker = marker
        if marker.userData  != nil {
        print("user tabed car from id :",marker.userData as! String)
        let id = marker.userData as! String
        let userPosition = locationManager.location?.coordinate
        let poinPosition = marker.position
        
        let marker_img_old = marker.icon
        let image_stoked =  marker_img_old?.stroked(with: hexStringToUIColor(hex: "4285f4"), size: 3)
        let marker_img_new = image_stoked?.rotate(radians: .pi)
        marker.icon = marker_img_new
        
        if userPosition != nil{
            drawPolilyne(src: userPosition!, dst: poinPosition, mode: "walking", state: "Draw")
            //MARK: par1 data
            self.CarNameStr = ((DataManager.sharedCenter.DataPoints.object(forKey: id) as! PinLocations).name!)
            self.CarNumberStr = ((DataManager.sharedCenter.DataPoints.object(forKey: id) as! PinLocations).favouriteArtist!)
            self.CarPosition = marker.position
            self.CarSelectID = marker.userData as! String
            latLong(lat: marker.position.latitude, long: marker.position.longitude)
            }
        }
        return true
    }
    
    func ShowPopView(CarName : String,CarNumber : String, CarDist : String, CarTime : String){

        if CarName.count != 0 {
            self.CarName.text = CarName
            self.CarNumber.text = CarNumber
            self.time.text = CarTime
            self.distantion.text = CarDist
             AnimationManager(View: self.ViewCars, Button: self.ButtonCarDetail, mode: "show", BarView: self.StatusBarMaskView, RoutingView: self.CarLiveViewRouting)
        }
    }//MARK: Show popapView

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
              
              if let location = locations.last {
                mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 14.0)
                locationManager.stopUpdatingLocation() //need fix
              }
    }//MARK: location manager
          
      //    @IBAction func refLocation(_ sender: Any) {
      //        locationManager.startUpdatingLocation()
      //    }
          
          func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
              print("Unable to access your current location")
          }//MARK: current location user
  
    @IBAction func ButtonModeDriving(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
             ModeNavigation(mode: "driving", driving: ButtonDriving, walking: ButtonWalking)
        case 2:
             ModeNavigation(mode: "walking", driving: ButtonDriving, walking: ButtonWalking)
        case 3:
             ModeNavigation(mode: "driving", driving: CarLiveDriving, walking: CarLiveWalking)
        case 4:
             ModeNavigation(mode: "walking", driving: CarLiveDriving, walking: CarLiveWalking)
        default:
            print("default")
        }
    }//MARK: ButtonModeDriving
    
    func ModeNavigation(mode : String , driving : UIButton , walking : UIButton)
    {
        
        switch mode {
        case "driving":
            driving.setImage(UIImage(named: "car_white"), for: .normal)
            walking.setImage(UIImage(named: "walking_black"), for: .normal)
            driving.backgroundColor = hexStringToUIColor(hex: "343C44")
            walking.backgroundColor = hexStringToUIColor(hex: "ebeced")
            let location = locationManager.location?.coordinate
            if CarPosition != nil{
                drawPolilyne(src: location!, dst: CarPosition!, mode: "driving", state: "ButtonDraw")
                       }
        case "walking" :
            driving.setImage(UIImage(named: "drivingButton"), for: .normal)
            walking.setImage(UIImage(named: "ButtonWalking"), for: .normal)
            driving.backgroundColor = hexStringToUIColor(hex: "ebeced")
            walking.backgroundColor = hexStringToUIColor(hex: "343C44")
            let location = locationManager.location?.coordinate
            if CarPosition != nil{
                drawPolilyne(src: location!, dst: CarPosition!, mode: "walking", state: "ButtonDraw")
            }
        default:
            print("default")
        }
    }
    
    @IBAction func ClickCarSelected(_ sender: Any) {
        print("ClickCarSelected")
        AnimationManager(View: self.ViewCars, Button: self.ButtonCarDetail, mode: "delete", BarView: self.StatusBarMaskView, RoutingView: self.CarLiveViewRouting)
       if self.CarNumberStr != "" {
            //MARK: called showPopView
        self.ShowLiveCar(CarName: self.CarNameStr, CarNumber: self.CarNumberStr,CarTime: self.distRoud)
        self.configeXib()
        }
        //MARK: car liveView info detail
    }
    
    func ShowLiveCar(CarName : String,CarNumber : String, CarTime : String){
    //MARK: Show LiveView
            if CarName.count != 0 {
                self.CarLiveName.text = CarName
                self.CarLiveNumber.text = CarNumber
                self.CarLiveTime.text = CarTime
                self.navItemTitle.title = "You car is waiting for you"
                AnimationManager(View: self.CarLiveView, Button: self.ButtonCarDetail, mode: "showLive", BarView: self.StatusBarMaskView, RoutingView: self.CarLiveViewRouting)
            }
                if CarPosition != nil{
                    // MARK: Clear map and add selected point and draw path from curren location user
                    mapView.clear()
                    let marker = GMSMarker()
                    let userPosition = locationManager.location?.coordinate
                    marker.position = CarPosition!
                    marker.icon = drawImageWithProfilePic(pp: marker_img!, image: car_img!)
                    marker.appearAnimation = GMSMarkerAnimation.pop
                    let marker_img_old = marker.icon
                    let image_stoked =  marker_img_old?.stroked(with: hexStringToUIColor(hex: "4285f4"), size: 3)
                    let marker_img_new = image_stoked?.rotate(radians: .pi)
                    marker.icon = marker_img_new
                    marker.map = mapView
                    drawPolilyne(src: userPosition!, dst: marker.position, mode: "walking",state: "ButtonDraw")
                    print(CarSelectID)
                    DataManager.sharedCenter.CarLiveRoutingLatitude = marker.position.latitude
                    DataManager.sharedCenter.CarLiveRoutingLongtitude = marker.position.longitude
                }
        }
    
    @IBAction func CarViewTabClose(_ sender: Any) {
  
        AnimationManager(View: self.CarLiveView, Button: self.ButtonCarDetail, mode: "deleteLive", BarView: self.StatusBarMaskView, RoutingView: self.CarLiveViewRouting)
        if self.mapView.selectedMarker != nil{
            self.mapView.selectedMarker!.icon = drawImageWithProfilePic(pp: marker_img!, image: car_img!)
            self.mapView.selectedMarker = nil
            self.removePolylinePath()
        }
        
        mapView.clear()
        loadingPoint()
        
    }
}

