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

    override func viewDidLoad() {
        super.viewDidLoad()
        openUrlBtn?.isHidden = !Helper.shared.canOpen104
    }

    @IBAction func go104(_ sender: UIButton) {
        Helper.go104IfPossible()
    }
}
