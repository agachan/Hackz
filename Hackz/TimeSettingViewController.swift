//
//  TimeSettingViewController.swift
//  Hackz
//
//  Created by AGA TOMOHIRO on 2020/10/02.
//  Copyright © 2020 AGA TOMOHIRO. All rights reserved.
//

import UIKit
import EventKit

protocol TimeTableViewCellDelegate {
    func sendTime(cell:TimeTableViewCell)
}

class TimeSettingViewController: UIViewController {

    @IBOutlet weak var timeTableView: UITableView!
    let cellId = "TimeCell"
    var starTime = ["00:00"]
    var endTime = ["00:00"]
    
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeTableView.delegate = self
        timeTableView.dataSource = self
        timeTableView.tableFooterView = UIView(frame: .zero)
        removeButton.isEnabled = false
        allowAuthorization()
    }
    
    func allowAuthorization() {
        if getAuthorization_status() {
            // 許可されている
            return
        } else {
            // 許可されていない
            eventStore.requestAccess(to: .event, completion: {
            (granted, error) in
                if granted {
                    return
                }
                else {
                    print("Not allowed")
                }
            })

        }
    }

    // 認証ステータスを確認する
    func getAuthorization_status() -> Bool {
        // 認証ステータスを取得
        let status = EKEventStore.authorizationStatus(for: .event)
        // ステータスを表示 許可されている場合のみtrueを返す
        switch status {
        case .notDetermined:
            print("NotDetermined")
            return false

        case .denied:
            print("Denied")
            return false

        case .authorized:
            print("Authorized")
            return true

        case .restricted:
            print("Restricted")
            return false
        @unknown default:
            return false
        }
    }

    
    var num = [1]
    var counter = 2
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    let maxCell = 6
//    時間割セルを新たに追加する
    @IBAction func addButton(_ sender: Any) {
        
        if counter < maxCell+1{
            num.append(counter)
            starTime.append("00:00")
            endTime.append("00:00")
            timeTableView.reloadData()
            counter+=1
            removeButton.isEnabled = true
            if counter == maxCell+1{
                addButton.isEnabled = false
            }
        }
    }
    
//    時間割セルを削除する
    @IBAction func removeButton(_ sender: Any) {
        if counter > 2{
            num.removeLast()
            starTime.removeLast()
            endTime.removeLast()
            timeTableView.reloadData()
            counter-=1
            addButton.isEnabled = true
            if counter == 2{
                removeButton.isEnabled = false
            }
        }
        
    }
    
//    現在取得できている時間割を保存する
    @IBAction func saveButton(_ sender: Any) {
        
        
    }
    

}

extension TimeSettingViewController:UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return num.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timeTableView.dequeueReusableCell(withIdentifier: cellId,for:indexPath) as! TimeTableViewCell
        cell.classNumber.text = String(indexPath.row + 1)
        cell.startTime.date = DateUtils.dateFromString(string: starTime[indexPath.row], format: "HH:mm")
        cell.endTime.date = DateUtils.dateFromString(string: endTime[indexPath.row], format: "HH:mm")
        cell.timeTableViewCellDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 5
        }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
}

extension TimeSettingViewController:TimeTableViewCellDelegate{
    func sendTime(cell: TimeTableViewCell) {
        let number = self.timeTableView.indexPath(for: cell)?.row
        starTime[number ?? 0] = cell.strStartTime
        endTime[number ?? 0] = cell.strEndTime
        print("開始時間:\(starTime)")
        print("終了時間:\(endTime)")
    }
}


class TimeTableViewCell:UITableViewCell{
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = LGreen
        self.layer.cornerRadius = 20
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.shadowRadius = 4
    }
    
    @IBAction func startTimer(_ sender: Any) {
        print("editStartTimer")
        strStartTime = DateUtils.stringFromDate(date: startTime.date, format: "HH:mm")
        timeTableViewCellDelegate?.sendTime(cell:self)
    }
    
    @IBAction func endTimer(_ sender: Any) {
        print("editEndTimer")
        strEndTime = DateUtils.stringFromDate(date: endTime.date, format: "HH:mm")
        timeTableViewCellDelegate?.sendTime(cell:self)
    }
    
    var timeTableViewCellDelegate:TimeTableViewCellDelegate?
    
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    @IBOutlet weak var classNumber: UILabel!
    var strStartTime:String = ""
    var strEndTime:String = ""
}


class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}


class ClassifiedViewController:UIViewController{
    private let cellId = "cellId"
    
    @IBOutlet weak var classifiedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        classifiedTableView.delegate = self
        classifiedTableView.dataSource = self
    }
    
    
}

extension ClassifiedViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = classifiedTableView.dequeueReusableCell(withIdentifier: cellId) as! ClassifiedTableViewCell
        cell.backgroundColor = .red
        return cell
    }
    
    
}

class ClassifiedTableViewCell:UITableViewCell{
    
    @IBOutlet weak var classifiedTextField: UITextField!
    @IBOutlet weak var unitNumber: UITextField!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}


