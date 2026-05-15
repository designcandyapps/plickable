//
//  Fonts.swift
//  Kwell
//
//  Created by Hitesh Rupani on 17/01/25.
//

import Foundation
import SwiftUICore
import UIKit

extension Font {
    // loading custom fonts
    static func gotham(_ textStyle: UIFont.TextStyle) -> Font {
        let size = UIFont.preferredFont(forTextStyle: textStyle).pointSize
        return .custom("Gotham-Book", size: size)
    }
    
    static func gothamBold(_ textStyle: UIFont.TextStyle) -> Font {
        let size = UIFont.preferredFont(forTextStyle: textStyle).pointSize
        return .custom("Gotham-Bold", size: size)
    }
    
    static func gothamMedium(_ textStyle: UIFont.TextStyle) -> Font {
        let size = UIFont.preferredFont(forTextStyle: textStyle).pointSize
        return .custom("Gotham-Medium", size: size)
    }
    
    static func gothamLight(_ textStyle: UIFont.TextStyle) -> Font {
        let size = UIFont.preferredFont(forTextStyle: textStyle).pointSize
        return .custom("Gotham-Light", size: size)
    }
    
    static func gothamNarrowBoldItalic(_ textStyle: UIFont.TextStyle) -> Font {
        let size = UIFont.preferredFont(forTextStyle: textStyle).pointSize
        return .custom("GothamNarrow-BoldItalic", size: size)
    }
}

extension Font {
    static func gotham(size: CGFloat) -> Font {
        return .custom("Gotham-Book", size: size)
    }
    
    static func gothamBold(size: CGFloat) -> Font {
        return .custom("Gotham-Bold", size: size)
    }
    
    static func gothamMedium(size: CGFloat) -> Font {
        return .custom("Gotham-Medium", size: size)
    }
    
    static func gothamLight(size: CGFloat) -> Font {
        return .custom("Gotham-Light", size: size)
    }
    
    static func gothamNarrowBoldItalic(size: CGFloat) -> Font {
        return .custom("GothamNarrow-BoldItalic", size: size)
    }
}
