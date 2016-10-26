//
//  ViewController.swift
//  ColorChangeWithSwipe
//
//  Created by Charlie Hieger on 10/26/16.
//  Copyright © 2016 Charlie Hieger. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var pageControl: UIPageControl!
    var scrollViewContentOffsetMaxX: CGFloat!
    var numberOfWelcomeScreens: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup scroll view
        scrollView.delegate = self
        numberOfWelcomeScreens = 6
        let contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(numberOfWelcomeScreens), height: scrollView.frame.size.height)
        scrollView.contentSize = contentSize
        scrollViewContentOffsetMaxX = scrollView.contentSize.width - scrollView.frame.size.width
        scrollView.backgroundColor = UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 1)

        // Setup Labels
        for screenNumber in 0..<numberOfWelcomeScreens {
            let label = UILabel()
            label.text = String(screenNumber + 1)
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 200, weight: UIFontWeightThin)
            label.sizeToFit()
            scrollView.addSubview(label)
            let width = scrollView.frame.size.width
            label.center = CGPoint(x: width / 2 + CGFloat(screenNumber) * width, y: scrollView.frame.size.height / 2)

        }

        // Setup Page Control
        pageControl.numberOfPages = numberOfWelcomeScreens
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}

extension WelcomeViewController: UIScrollViewDelegate {
    func color(for offset: CGFloat) -> UIColor {
        let hue = offset / scrollViewContentOffsetMaxX
        let color = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
        return color
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // Change background color with offset
        let offset = scrollView.contentOffset.x
        scrollView.backgroundColor = color(for: offset)

        // Change page control dots
        let currentPage = Int(floor(offset / scrollViewContentOffsetMaxX * CGFloat(numberOfWelcomeScreens)))
        pageControl.currentPage = currentPage
    }
}

