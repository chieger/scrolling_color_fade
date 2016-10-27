//
//  Common.swift
//
//  Created by CodePath on 9/27/16.
//  Copyright © 2016 CodePath. All rights reserved.
//

import UIKit

// MARK: Run Code After a Delay

func delay(_ delay:Double, closure:@escaping ()->()) {
    run(after: delay, closure: closure)
}

///EXAMPLE:
/*
 let secondsToDelay = 0.5
 run(after: secondsToDelay) {
 // This code will run after the delay
 }
 */

/**
 Runs a code block (closure) after a specified delay interval in seconds.

 - parameter after: Number of seconds to delay before executing the code block.
 - parameter closure: The block of code to be executed after the delay.
 */

func run(after wait: TimeInterval, closure: @escaping () -> Void) {
    let queue = DispatchQueue.main
    queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
}

// MARK: Convert Values Between Ranges

/**
 Converts an input value within a given range (range1) and returns a proportionate value in another range (range2).

 - parameter value: The input value within range1 you want to convert.
 - parameter r1Min: The minimum value of range1
 - parameter r1Max: The maximum value of range1
 - parameter r2Min: The minimum value of range1
 - parameter r2Max: The maximum value of range1

 - returns: a new value in range2 mapped to the input value of range1
 */

func convertValue(inputValue: CGFloat, r1Min: CGFloat, r1Max: CGFloat, r2Min: CGFloat, r2Max: CGFloat) -> CGFloat {
    let ratio = (r2Max - r2Min) / (r1Max - r1Min)
    return inputValue * ratio + r2Min - r1Min * ratio
}

extension CGAffineTransform {

    // MARK: Create a new rotation transform in degrees

    ///EXAMPLE:
    /*
     let degreesOfRotation: CGFloat = 90
     yourView.transform = CGAffineTransform(rotationAngleDegrees: degreesOfRotation)
     */

    /**
     Creates a new transform value with the specified rotation amount in degrees. Use this method when you want to set the transform to the specified rotation amount and ignore any of the previous transform values.

     - parameter angle: The angle, in degrees, you want the new rotation transform to be.
     */

    init(rotationAngleDegrees angle: CGFloat) {
        let rotationAngle = angle * CGFloat(M_PI) / 180

        self.init(rotationAngle: rotationAngle)
    }

    // MARK: Update the rotation an existing transform in degrees

    /// Since this method updates an existing transform value,
    /// you might use it to rotate your view an additional 90 degrees counter-clockwise from it's current state of rotation.
    ///
    /// EXAMPLE:
    /*
     let degreesToRotate: CGFloat = 90.0
     yourView.transform = yourView.transform.rotated(byDegrees: degreesToRotate)
     */

    /// Updates the existing transform value by the specified rotation amount in degrees. Use this method when you want to add or subtract rotation from and extisting transform.
    ///
    /// - Parameter angle: The angle, in degrees, by which to rotate the affine transform. A positive value specifies counterclockwise rotation and a negative value specifies clockwise rotation.
    ///
    /// - Returns: A new affine transformation.

    func rotated(byDegrees angle: CGFloat) -> CGAffineTransform {
        return self.rotated(by: angle * CGFloat(M_PI / 180))
    }
}
