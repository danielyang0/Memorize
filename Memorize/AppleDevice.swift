//
//  AppleDeviceConstants.swift
//  Memorize
//
//  Created by Daniel Yang on 5/14/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation
import UIKit

enum Device {
    case iphone6s
    case iphone6sp
}


class AppleDevice {
    
    
    var whichDevice: Device
    
    
    init (deviceName: String) {
        if deviceName == "iphone6s" {
            self.whichDevice = Device.iphone6s
        }else {
            self.whichDevice = Device.iphone6sp
        }
    }
    
    
    enum  DeviceScreenWidth: CGFloat {
        case iphone6sp = 414
        case iphone6s = 375
    }
    
    enum DeviceScreenHeight: CGFloat {
        case iphone6sp = 735
        case iphone6s = 667
    }
    
    
    
    var dictionaryHeight: CGFloat {
        get {
            if whichDevice == Device.iphone6sp {
                return 469 //for 6sp
            }else {
                return 416 //for 6s
            }
            
        }
    }
    
    var deviceScreenWidth: CGFloat {
        get {
            if whichDevice == Device.iphone6sp {
                return DeviceScreenWidth.iphone6sp.rawValue
            }else {
                return DeviceScreenWidth.iphone6s.rawValue
            }
        }
    }
    
    var deviceScreenHeight: CGFloat {
        get {
            if whichDevice == Device.iphone6sp {
                return DeviceScreenHeight.iphone6sp.rawValue
            }else {
                return DeviceScreenHeight.iphone6s.rawValue
            }
        }
    }

}

