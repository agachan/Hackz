//
//  MapViewController.swift
//  Hackz
//
//  Created by AGA TOMOHIRO on 2020/09/10.
//  Copyright © 2020 AGA TOMOHIRO. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

/// Location の View
class LocationViewController: UIViewController {
    
    /// 緯度を表示するラベル
    @IBOutlet weak var latitude: UILabel!
    /// 経度を表示するラベル
    @IBOutlet weak var longitude: UILabel!
    
    // 緯度
    var latitudeNow: String = ""
    // 経度
    var longitudeNow: String = ""
    
    var speedNow: String = ""
    
    var maxSpeed: String = ""
    /// ロケーションマネージャ
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        mapView.transform = CGAffineTransform(rotationAngle: CGFloat(0 * Double.pi / 180.0))
        mapView.layer.cornerRadius = self.mapView.frame.width/2
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5,
                                     target: self,
                                     selector: #selector(self.sequenceTimer),
                                     userInfo:nil,
                                     repeats: true)
        // ロケーションマネージャのセットアップ
        setupLocationManager()
    }
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var timer = Timer()
    @objc func sequenceTimer(){
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
        } else if status == .authorizedWhenInUse {
            print("\(latitudeNow),\(longitudeNow)")
            //             String(format:"%02d", minute)
            self.latitude.text = "緯度："+latitudeNow
            self.longitude.text = "経度："+longitudeNow
            self.speedLabel.text = "速度："+speedNow
            
            guard let speed = Double(speedNow) else{return}
            guard var maxspeed = Double(maxSpeed) else {return}
            if speed > maxspeed{
                maxspeed = speed
                self.maxSpeedLabel.text = "最高速度：" + "AA"
            }else{
                self.maxSpeedLabel.text = "最高速度：" + "BB"
            }
            
            self.maxSpeedLabel.text = "最高速度：" + maxSpeed
            
            let La = CLLocationDegrees(Double(latitudeNow) ?? 0.0)
            let Lo = CLLocationDegrees(Double(longitudeNow) ?? 0.0)
            let coordinate = CLLocationCoordinate2D(latitude: La, longitude: Lo)
            let span = MKCoordinateSpan(latitudeDelta:  0.008983148616, longitudeDelta: 0.010966382364)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.region = region
        }
    }
    
    
    /// ロケーションマネージャのセットアップ
    func setupLocationManager() {
        locationManager = CLLocationManager()
        
        // 権限をリクエスト
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        
        // ステータスごとの処理
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    /// アラートを表示する
    func showAlert() {
        let alertTitle = "位置情報取得が許可されていません。"
        let alertMessage = "設定アプリの「プライバシー > 位置情報サービス」から変更してください。"
        let alert: UIAlertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle:  UIAlertController.Style.alert
        )
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        // UIAlertController に Action を追加
        alert.addAction(defaultAction)
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    
    /// 位置情報が更新された際、位置情報を格納する
    /// - Parameters:
    ///   - manager: ロケーションマネージャ
    ///   - locations: 位置情報
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let speed: Double = floor((locations.last!.speed * 3.6)*100)/100
        let maxSpeed: Double = floor((locations.last!.speed * 3.6)*100)/100
        guard let latitude = location?.coordinate.latitude else{return}
        guard let longitude = location?.coordinate.longitude else{return}
        // 位置情報を格納する
        self.maxSpeed = String(maxSpeed)
        self.speedNow = String(speed)
        self.latitudeNow = String(latitude)
        self.longitudeNow = String(longitude)
    }
}
