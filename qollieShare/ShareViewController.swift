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

    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let item = extensionContext?.inputItems.first as? NSExtensionItem, let itemProvider = item.attachments?.first as? NSItemProvider {
            if itemProvider.hasItemConformingToTypeIdentifier("public.url") {

                itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, err) in

                    if let url = url as? NSURL {
//                            url.host
                        print(url.absoluteString ?? "")
                    }
                })
            } else if itemProvider.hasItemConformingToTypeIdentifier("public.plain-text") {
                itemProvider.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: { (text, err) in
                    if let text = text as? String {
                        print(text)
                        let array = text.components(separatedBy: "-")

                        if array.count == 2 {
                            let company = array[0]
//                                let job = array [1]

                            if let encodeCompany = company.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
                                let url = URL(string: "https://www.qollie.com/search?keyword=\(encodeCompany)&kind=company") {

                                    print(url.absoluteString)
                                    let safari = SFSafariViewController(url: url)
                                    safari.delegate = self
                                    self.present(safari, animated: true, completion: nil)
                            } else {

                            }
                        } else {

                        }
                    }
                })
            }

        }
    }

    @IBAction func dismiss(_ sender: UIButton) {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    open func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    open func didSelectPost() {

        if let item = extensionContext?.inputItems.first as? NSExtensionItem {


            if let itemProvider = item.attachments?.first as? NSItemProvider {

                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {

                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, err) in

                        if (url as? NSURL) != nil {
                            UserDefaults.standard.set(url, forKey: "URLArrayValue")
                            print("!!!!")
                        }

                        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                    })
                }
            }
        }

    }

    open func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
}


extension LOViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
