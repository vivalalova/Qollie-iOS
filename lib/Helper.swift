//
//  File.swift
//  qollie
//
//  Created by Lova on 2017/3/3.
//  Copyright © 2017年 lova. All rights reserved.
//

import Foundation


open class Helper {
    open static let url: URL? = URL(string: "fb215646968788192://")

    open static let shared: Helper = {
        let instance = Helper()
        return instance
    }()

    open var canOpen104: Bool {
        if let url = Helper.url {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }

    open class func go104IfPossible() {
        if Helper().canOpen104, let url = Helper.url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
