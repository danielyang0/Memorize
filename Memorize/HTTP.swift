//
//  HTTP.swift
//  Memorize
//
//  Created by Daniel Yang on 5/15/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import UIKit

class WebManager {
    
    var dataTask: NSURLSessionDataTask?
    var urlSession: NSURLSession!
    
    
    func initSession() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.urlSession = NSURLSession(configuration: configuration)
    }
    
    
    func cancelSession() {
        self.urlSession.invalidateAndCancel()
        self.urlSession = nil
    }
    
    
    func downloadHtml(url:String, completion:(url:String, htmlString:String) -> Void) {
        let nsurl = NSURL(string: url)!
        let request = NSURLRequest(URL:nsurl)
        self.dataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                if let htmlAsString = String(data: data!, encoding: NSUTF8StringEncoding) {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in //make sure to download at main thread
                        completion(url: url, htmlString: htmlAsString)
                    })
                }
            }
        })
        self.dataTask?.resume()
    }
    
    
    //word string -> access html -> get definition -> ...
    func downloadYoudaoDefinition(wordSpell: String, completion: (defination: Defination) -> Void) {
        self.downloadHtml(Youdao.generateYoudaoURL(wordSpell)) { (url, htmlString) -> Void in
            let youdaoPage = Youdao(word: wordSpell, htmlString: htmlString)
            let definationObject = Defination(youdaoPage: youdaoPage)
            
            let df = DefinationHelper(word: wordSpell)
            df.saveDefination(definationObject)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion(defination: definationObject)
            })
        }
    }
    
    //word string->access html -> get or definition object or load from stored file
    func loadOrdownloadYoudaoDefinition(wordSpell: String, completion: (defination: Defination) -> Void) {
        let df = DefinationHelper(word: wordSpell)
        df.readDefination { (defination) -> Void in
            if let foundDefination = defination {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completion(defination: foundDefination)
                })
            }else {
                self.downloadYoudaoDefinition(wordSpell, completion: completion)
            }
        }
    }
    
}
