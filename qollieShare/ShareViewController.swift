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
            self.alert(message: "哎呀? 意外地不能使用")
            return
        }

//        if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
//            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, err) in
//                guard let url = url as? URL else {
//                    self.alert(message: "我們不支援從瀏覽器開啟喔,請使用104 APP")
//                    return
//                }
//                //url.host
//                //https://m.104.com.tw/job/5b00o?jobsource=m104_hotorder
//
//                self.handle(url: url)
//
//            })
//        } else

        if itemProvider.hasItemConformingToTypeIdentifier("public.plain-text") {
            itemProvider.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: { (text, err) in
                guard let text = text as? String else {
                    self.alert(message: "請在104 APP內使用喔")
                    return
                }

                self.handle(text: text)
            })
        }
    }

    func handle(url: URL) {
        print(url.absoluteString)

    }

    func handle(text: String) {
        print(text)

        let array = text.components(separatedBy: "-")

        guard let company = array.first?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "https://www.qollie.com/search?keyword=\(company)&kind=company") else {
                self.alert(message: "")
                return
        }


        print(url.absoluteString)
        let safari = SFSafariViewController(url: url)
        safari.delegate = self
        self.present(safari, animated: true, completion: nil)
    }

    func alert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "確定", style: .cancel) { action in
            self.dismiss()
        })
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
