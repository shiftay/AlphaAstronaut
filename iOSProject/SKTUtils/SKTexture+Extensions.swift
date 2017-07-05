//
//  SKTexture+Extensions.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-07-05.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

//enum GradientDirection {
//    case Up
//    case Left
//    case UpLeft
//    case UpRight
//}

public extension SKTexture {
    
    convenience init(size: CGSize, color1: CIColor, color2: CIColor, direction: Int = 0) {
        
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CILinearGradient")
        var startVector: CIVector
        var endVector: CIVector
        
        filter!.setDefaults()
//        
//        switch direction {
//        case 0:
            endVector = CIVector(x: size.width * 0.5, y: 0)
            startVector = CIVector(x: size.width * 0.5, y: size.height)
//        case 1:
//            startVector = CIVector(x: size.width, y: size.height * 0.5)
//            endVector = CIVector(x: 0, y: size.height * 0.5)
//        case 2:
//            startVector = CIVector(x: size.width, y: 0)
//            endVector = CIVector(x: 0, y: size.height)
//        case 3:
//            startVector = CIVector(x: 0, y: 0)
//            endVector = CIVector(x: size.width, y: size.height)
//        default:
//            break
//        }
        
        filter!.setValue(startVector, forKey: "inputPoint0")
        filter!.setValue(endVector, forKey: "inputPoint1")
        filter!.setValue(color1, forKey: "inputColor0")
        filter!.setValue(color2, forKey: "inputColor1")
        
        let image = context.createCGImage(filter!.outputImage!, from: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.init(cgImage: image!)
    }
}
