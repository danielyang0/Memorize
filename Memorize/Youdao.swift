//
//  Youdao.swift
//  Memorize
//
//  Created by Daniel Yang on 5/8/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation
import HTMLReader

class Youdao {
    
    var htmlString:String
    let word:String
    let urlString:String
    var doc:HTMLDocument!
    
    
    init (word newWord:String, htmlString newString: String) {
        self.word = newWord
        self.htmlString = newString
        self.doc = HTMLDocument(string: self.htmlString)
        self.urlString = Youdao.generateYoudaoURL(self.word)
    }
    
    static func generateYoudaoURL(word: String) -> String {
        return "http://dict.youdao.com/w/eng/"+word+"/#keyfrom=dict2.index"
    }
    
    func parseChineseDefinition() -> String? {
        let chineseDefinitions = doc.nodesMatchingSelector("#phrsListTab > div.trans-container > ul > li")
        var result: String? = nil
        for definition in chineseDefinitions {
            let content = definition.textContent
            if result == nil {
                result = ""
            }
            result = result! + content + "\n"
        }
        return result
        
    }
    
    func parsePhonetic() -> String? {
        let phoneticSpans = doc.nodesMatchingSelector("#phrsListTab > h2 > div > span > span")
        var phoneticString: String? = nil
        
        for span in phoneticSpans {
            phoneticString = span.textContent
        }
        return phoneticString
    }
    
    
    
}