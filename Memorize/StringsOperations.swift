//
//  StringsOperations.swift
//  Memorize
//
//  Created by Daniel Yang on 5/29/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation

class StringsOperations {
    static func trim(str: String?) -> String? {
        if str == nil {
            return nil
        }
        return str!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
 }