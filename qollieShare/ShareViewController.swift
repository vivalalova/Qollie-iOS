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

class LOViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let item = extensionContext?.inputItems.first as? NSExtensionItem, let itemProvider = item.attachments?.first as? NSItemProvider else {
            self.alert(message: "哎呀? 請在104 APP內使用喔")
            return
        }

        if itemProvider.hasItemConformingToTypeIdentifier("public.plain-text") {
            itemProvider.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: { (text, err) in
                guard let text = text as? String else {
                    self.alert(message: "請在104 APP內使用喔")
                    return
                }

                self.handle(text: text)
            })
        } else {
            self.alert(message: "哎呀? 請在104 APP內使用喔")
        }
    }

    func handle(text: String) {
        let array = text.components(separatedBy: "-")

        guard let company = array.first?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "https://www.qollie.com/search?keyword=\(company)&kind=company") else {
                self.alert(message: "請在104 APP內使用喔")
                return
        }

        let safari = SFSafariViewController(url: url)
        safari.delegate = self

        self.present(safari, animated: true, completion: nil)
    }

    func alert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "確定", style: .cancel) { action in
            self.dismiss()
        })

        self.present(alert, animated: true, completion: nil)
    }

    func dismiss() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}

extension LOViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss()
    }
}
