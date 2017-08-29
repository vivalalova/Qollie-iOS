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
import GoogleMobileAds

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
    @IBOutlet var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        bannerView.adUnitID = "ca-app-pub-3835325644280868/5129053621"
        self.bannerView.load(GADRequest())

        print(self.bannerView.frame)
    }

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

extension IntroViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
