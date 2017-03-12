//
//  ViewController.swift
//  qollie
//
//  Created by Lova on 2017/2/27.
//  Copyright © 2017年 lova. All rights reserved.
//

import UIKit
import Crashlytics
import lib
import SafariServices

class ViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self

        Answers.logCustomEvent(withName: "打開APP耶", customAttributes: nil)

        self.setNeedsStatusBarAppearanceUpdate()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / self.view.frame.size.width)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class IntroViewController: UIViewController {

    @IBOutlet weak var openUrlBtn: UIButton?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        openUrlBtn?.isHidden = !Helper.shared.canOpen104
    }
    
    @IBAction func qollieWeb(_ sender: Any) {
        if let url = URL(string: "https://www.qollie.com") {
            Answers.logCustomEvent(withName: "APP看官網", customAttributes: nil)


            let safari = SFSafariViewController(url: url)
            self.present(safari, animated: true, completion: nil)
        }
    }
    
    @IBAction func download104(_ sender: Any) {
        if let url = URL(string: "https://itunes.apple.com/tw/app/104%E5%B7%A5%E4%BD%9C%E5%BF%AB%E6%89%BE/id437817158?l=zh&mt=8") {

            Answers.logCustomEvent(withName: "下載104", customAttributes: nil)


            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    @IBAction func go104(_ sender: UIButton) {
        Answers.logCustomEvent(withName: "打開104", customAttributes: nil)
        Helper.go104IfPossible()
    }
}
