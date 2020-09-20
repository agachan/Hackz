//
//  UIColorExtension.swift
//  Hackz
//
//  Created by AGA TOMOHIRO on 2020/09/11.
//  Copyright © 2020 AGA TOMOHIRO. All rights reserved.
//

import UIKit

extension UIColor{
    static func rgb(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor{
        return self.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}
let keykiColor = UIColor.rgb(r: 185, g: 223, b: 144)
