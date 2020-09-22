//
//  CreateNameViewController.swift
//  Hackz
//
//  Created by AGA TOMOHIRO on 2020/09/18.
//  Copyright © 2020 AGA TOMOHIRO. All rights reserved.
//

import UIKit

class RegistButton:UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit() {
        //角丸・枠線・背景色を設定する
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}

class CreateNameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //textの表示はalertのみ。ActionSheetだとtextfiledを表示させようとすると
    //落ちます。
    @IBAction func member(_ sender: Any) {
                let ac = UIAlertController(title: "IDを入力してください！！", message: "ホストで自動生成された６桁のIDを入力", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: {[weak ac] (action) -> Void in
            guard let textFields = ac?.textFields else {
                return
            }

            guard !textFields.isEmpty else {
                return
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        //textfiledの追加
        ac.addTextField(configurationHandler: {(text:UITextField!) -> Void in
        })

        ac.addAction(ok)
        ac.addAction(cancel)

        present(ac, animated: true, completion: nil)

    }
    
    
   
}
