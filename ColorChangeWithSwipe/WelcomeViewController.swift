//
//  ViewController.swift
//  ColorChangeWithSwipe
//
//  Created by Charlie Hieger on 10/26/16.
//  Copyright © 2016 Charlie Hieger. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    // Declare properties for scroll view
    var scrollViewContentOffsetMaxX: CGFloat!
    var numberOfWelcomeScreens: Int!

    // Initialize target colors

    var screenColors: [UIColor]!
    var redLightColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    var redDarkColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
    var purpleLightColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    var purpleDarkColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)


    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup scroll view
        scrollView.delegate = self
        numberOfWelcomeScreens = 6
        let contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(numberOfWelcomeScreens), height: scrollView.frame.size.height)
        scrollView.contentSize = contentSize
        scrollViewContentOffsetMaxX = scrollView.contentSize.width - scrollView.frame.size.width
        scrollView.backgroundColor = redLightColor

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

        // Setup Colors
        screenColors = [redLightColor, redDarkColor, purpleLightColor, purpleDarkColor]


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}

extension UIColor {
    // Convert UIColor to CIColor to allow access to color components
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }

    // Extract color components
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}

extension WelcomeViewController: UIScrollViewDelegate {

    func color(for offset: CGFloat) -> UIColor {
        let hue = offset / scrollViewContentOffsetMaxX
        let color = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
        return color
    }

    func color(for offset: CGFloat, fromOffset: CGFloat, toOffset: CGFloat, fromColor: UIColor, toColor: UIColor) -> UIColor {

        let fromComponents = [fromColor.components.red, fromColor.components.green, fromColor.components.blue, fromColor.components.alpha]

        let toComponents = [toColor.components.red, toColor.components.green, toColor.components.blue, toColor.components.alpha]


        var blendedComponents: [CGFloat] = []
        for index in 0..<fromComponents.count {
            var blendedComponent = convertValue(inputValue: offset, r1Min: fromOffset, r1Max: toOffset, r2Min: fromComponents[index], r2Max: toComponents[index])
            if blendedComponent > 1 {
                blendedComponent = 1
            } else if blendedComponent < 0 {
                blendedComponent = 0
            }

            print("blended component: \(blendedComponent)")
            blendedComponents.append(blendedComponent)
        }

        let blendedColor = UIColor(red: blendedComponents[0], green: blendedComponents[1], blue: blendedComponents[2], alpha: blendedComponents[3])
        return blendedColor
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Determine to and from colors based on offset
        // If less than page 2, if less than page 3, etc.
        var isWithinRange = true
        var offset = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.frame.size.width
        var fromColor = UIColor()
        var toColor = UIColor()
        var fromOffset: CGFloat = 0
        var toOffset: CGFloat = 0

        if offset < scrollViewWidth {
            fromColor = screenColors[0]
            toColor = screenColors[1]
            fromOffset = 0
            toOffset = scrollViewWidth
            isWithinRange = true

        } else if offset < scrollViewWidth * 2 {
            fromColor = screenColors[1]
            toColor = screenColors[2]
            fromOffset = scrollViewWidth
            toOffset = scrollViewWidth * 2
            isWithinRange = true

        } else if offset < scrollViewWidth * 3 {
            fromColor = screenColors[2]
            toColor = screenColors[3]
            fromOffset = scrollViewWidth * 2
            toOffset = scrollViewWidth * 3
            isWithinRange = true
        } else {
            isWithinRange = false
        }

        // Change background color with offset
        if isWithinRange {
        scrollView.backgroundColor = color(for: offset, fromOffset: fromOffset, toOffset: toOffset, fromColor: fromColor, toColor: toColor)
        }

        // Change page control dots
        let currentPage = Int(floor(offset / scrollViewContentOffsetMaxX * CGFloat(numberOfWelcomeScreens)))
        pageControl.currentPage = currentPage
    }
}

