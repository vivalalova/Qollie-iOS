//
//  ShareViewController.swift
//  qollieShare
//
//  Created by Lova on 2017/2/27.
//  Copyright © 2017年 lova. All rights reserved.
//

import UIKit
import Social
import SafariServices
import Fabric
import Crashlytics
import lib
import Localize_Swift

class LOViewController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Fabric.with([Crashlytics.self])
        Crashlytics.start(withAPIKey: "ae32a781ec002f65fd6900f49c380cfbd17c7b86").delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Answers.logCustomEvent(withName: "打開分享拉", customAttributes: nil)

        guard let item = extensionContext?.inputItems.first as? NSExtensionItem, let itemProvider = item.attachments?.first as? NSItemProvider else {
            self.alert()
            return
        }

        if itemProvider.hasItemConformingToTypeIdentifier("public.plain-text") {
            itemProvider.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: { (text, err) in
                guard let text = text as? String else {
                    self.alert()
                    return
                }

                self.handle(text: text)
            })
        } else {
            self.alert()
        }
    }

    fileprivate func handle(text: String) {
        let array = text.components(separatedBy: "-")

        guard array.count >= 2,
            let company = array.first?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "https://www.qollie.com/search?keyword=\(company)&kind=company") else {
                Answers.logCustomEvent(withName: "查詢沒過", customAttributes: nil)
                self.alert()
                return
        }

        Answers.logCustomEvent(withName: "查詢有過", customAttributes: nil)
        self.open(url: url, complete: nil)
    }

    fileprivate func alert() {
        let message = "Install 104 APP for best experience".localized()
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "YES".localized(), style: .cancel) { action in
            self.dismiss()
        })

        if Helper.shared.canOpen104 {
            alert.addAction(UIAlertAction(title: "Open 104".localized(), style: .default) { action in
                Helper.go104IfPossible()
                self.dismiss()
            })
        } else if let url = URL(string: "https://itunes.apple.com/tw/app/104%E5%B7%A5%E4%BD%9C%E5%BF%AB%E6%89%BE/id437817158?l=zh&mt=8") {
            alert.addAction(UIAlertAction(title: "Install 104".localized(), style: .default) { action in
                self.open(url: url, complete: {
                    self.dismiss()
                })
            })
        }

        alert.addAction(UIAlertAction(title: "Browse Qollie".localized(), style: .default) { action in
            let url = URL(string: "https://www.qollie.com/")
            self.open(url: url!, complete: nil)
        })

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    fileprivate func dismiss() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    fileprivate func open(url: URL, complete: (() -> Void)?) {
        DispatchQueue.main.async {
            let safari = SFSafariViewController(url: url)
            safari.delegate = self

            self.present(safari, animated: true) {
                complete?()
            }
        }
    }
}

extension LOViewController: CrashlyticsDelegate {
    func crashlyticsCanUseBackgroundSessions(_ crashlytics: Crashlytics) -> Bool {
        return false
    }
}

extension LOViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss()
    }
}
