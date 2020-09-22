//
//  LoginViewController.swift
//  Hackz
//
//  Created by AGA TOMOHIRO on 2020/09/11.
//  Copyright © 2020 AGA TOMOHIRO. All rights reserved.
//

import UIKit

class SaveButton: UIButton{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 20
        self.tintColor = .white
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowColor = keykiColor.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4
    }
}



class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var mailTextfield: UITextField!
    @IBOutlet weak var saveButton: SaveButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    let len = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        saveButton.alpha = 0.3
        nameTextfield.delegate = self
        mailTextfield.delegate = self
        passwordTextfield.delegate = self
        let id = randomString(length: len)
        print(id)
        // Do any additional setup after loading the view.
    }
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
   

}

extension LoginViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
