//
//  ViewController.swift
//  qollie
//
//  Created by Lova on 2017/2/27.
//  Copyright © 2017年 lova. All rights reserved.
//

import UIKit
import Crashlytics

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

    let e04 = "fb215646968788192://"
    var url: URL? {
        return URL(string: self.e04)
    }

    var canOpen104: Bool {
        if let url = url {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        openUrlBtn?.isHidden = !self.canOpen104
    }

    @IBAction func go104(_ sender: UIButton) {
        if canOpen104, let url = url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
