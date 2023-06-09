//
//  extensions.swift
//  Spotify
//
//  Created by Tejvir Mann on 2/21/21.
//

import Foundation
import UIKit

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat{
        return frame.origin.x
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right:CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
    
}
