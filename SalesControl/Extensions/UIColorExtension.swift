//
//  UIColorExtension.swift
//  SalesControl
//
//  Created by Juan Balderas on 7/19/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import Foundation
extension UIColor {
    static func imageWithBackgroundColor(image: UIImage, bgColor: UIColor) -> UIColor {
        let size = CGSize(width: 100, height: 100)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)


        let context = UIGraphicsGetCurrentContext()


        let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        CGContextSetFillColorWithColor(context, bgColor.CGColor)
        CGContextAddRect(context, rectangle)
        CGContextDrawPath(context, .Fill)

        CGContextDrawImage(context, rectangle,  image.CGImage)

        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: img)
        
    }
}

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(M_PI))
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }

        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size

        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()

        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);

        //   // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees));

        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat

        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }

        CGContextScaleCTM(bitmap, yFlip, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}