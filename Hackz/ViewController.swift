//
//  ViewController.swift
//  Hackz
//
//  Created by AGA TOMOHIRO on 2020/09/09.
//  Copyright © 2020 AGA TOMOHIRO. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewButton: UIBarButtonItem!

    var latitudeNow: String = ""
    var longitudeNow: String = ""
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        
        mapView.layer.cornerRadius = self.mapView.frame.width/2
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        latitude.text = latitudeNow
        longitude.text = longitudeNow
        countLabel.text = "00:00:00"
    }
    
//    現在位置から国土地理院のAPIを用いて標高を求める関数
    @IBAction func heightPosition(_ sender: Any) {
        print("getApi\(longitudeNow)\(latitudeNow)")
        let baseUrl = "https://cyberjapandata2.gsi.go.jp/general/dem/scripts/getelevation.php?"
        let listurl = baseUrl+String("lon=\(132.72548464931793)&lat=\(34.4168036097029)&outtype=JSON")
        // URLを生成する
        guard let url = URL(string: listurl) else { return }
        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                   // コンソールに出力
                   print("data: \(String(describing: data))")
                   print("response: \(String(describing: response))")
                   print("error: \(String(describing: error))")
               })
               task.resume()
           }
    
    var startTime = Date()
    var timer:Timer = Timer()
    var c = 0
    
    @IBOutlet weak var countLabel: UILabel!
    
    
//    タイマー機能を持たせる関数
    @IBAction func startButton(_ sender: Any) {
        if c == 0{
        timer.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector:#selector(ViewController.updateTimer),
            userInfo: nil,
            repeats: true)
            c += 1
        }else if c == 1{
            startTime = Date()
            timer.invalidate()
            c += 1
        }else{
            countLabel.text = "00:00:00"
            c = 0
        }
    }
    
//    表示方法を決定する関数（0.01秒間隔で刻み表示をする）
    @objc func updateTimer() {
        // タイマー開始からのインターバル時間
        let currentTime = Date().timeIntervalSince(startTime)
        // fmod() 余りを計算
        let minute = (Int)(fmod((currentTime/60), 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
        // floor 切り捨て、小数点以下を取り出して *100
        let msec = (Int)((currentTime - floor(currentTime))*100)
        
        // %02d： ２桁表示、0で埋める
        let sMinute = String(format:"%02d", minute)
        let sSecond = String(format:"%02d", second)
        let sMsec = String(format:"%02d", msec)
        
        countLabel.text = "\(sMinute):\(sSecond):\(sMsec)"
    }
}

extension ViewController: CLLocationManagerDelegate {

//    現在位置を取得する関数
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        guard let latitude = location?.coordinate.latitude else {return}
        guard let longitude = location?.coordinate.longitude else {return}
        // 位置情報を格納する
        self.latitude.text = String(latitude)
        latitudeNow = String(latitude)
        self.longitude.text = String(longitude)
        longitudeNow = String(longitude)
        print("\(latitude),\(longitude)")
        let database = Database.database().reference()
        database.ref.child("users").child("name").setValue(["longitude":longitude,"latitude":latitude])
        
//  取得した位置情報をマップに転記させる関数
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta:  0.0008983148616*2, longitudeDelta: 0.0010966382364*2)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        print(coordinate)
        mapView.region = region
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

}
