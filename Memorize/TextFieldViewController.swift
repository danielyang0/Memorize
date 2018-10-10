//
//  TextFieldViewController.swift
//  Memorize
//
//  Created by Daniel Yang on 5/11/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import UIKit

class TextFieldViewController: UIViewController {

    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var repeatReminder: UILabel!
    
    var superVC: ContainerViewController!
    
    var word: Word?
    var wordString: String!
    
    
    
    @IBAction func clearAction(sender: UIButton) {
        textField.text = ""
        textField.resignFirstResponder()
    }
    
    @IBAction func addAction(sender: UIButton) {
        if let word = textField.text {
            if word != "" {
                if superVC.addWordDependingOnView(word) {
                    clearAction(sender)
                }
            }
        }
    }
    
    @IBAction func addAndToRecordAction(sender: UIButton) {
        if let word = textField.text {
            if word != "" {
                if superVC.addToRecordAndDictionary(word) {
                    clearAction(sender)
                }
            }
        }
        
    }
    
    
    
    func wordAction(sender: UIButton) {
        let alertController = UIAlertController(title: "Operations", message: nil, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "memorize", style: .Default) { (action) -> Void in
            self.superVC.tableVC.memorize(sender)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            
        }
        
        
        
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    @IBAction func memorizeAction(sender: UIButton) {
        if word != nil {
            self.superVC.tableVC.memorizeOpration(word!.spell!)
        }
        
    }
    
    
    
    
    @IBAction func oprationsAction(sender: UIButton) {
        let wordSpell = self.wordString
        let alertController = UIAlertController(title: "Operations", message: nil, preferredStyle: .Alert)
        if word != nil {
            let showStatus = UIAlertAction(title: "showStatus", style: .Default, handler: { (action) -> Void in
                self.superVC.tableVC.popUpStatus(self.word!)
            })
            
            let backAction = UIAlertAction(title: "back", style: .Default) { (action) -> Void in
                self.superVC.tableVC.backOperation(wordSpell)
            }
            let reMemorizeAction = UIAlertAction(title: "reMemorize", style: .Default) { (action) -> Void in
                self.superVC.tableVC.reMemorizeOperation(wordSpell)
            }
            let definitionAction = UIAlertAction(title: "definition", style: .Default, handler: { (action) -> Void in
                self.superVC.tableVC.displayYoudaoButtonDidPressed(wordSpell)
            })
            let toRecordsAction = UIAlertAction(title: "ToRecords", style: .Default, handler: { (action) -> Void in
                self.superVC.tableVC.toRecordsOperation(wordSpell)
            })
            let removeFromRecordsAction = UIAlertAction(title: "RemoveFromRecords", style: .Default, handler: { (action) -> Void in
                self.superVC.tableVC.removeFromRecordsOperation(wordSpell)
            })
            
            
            let deleteAction = UIAlertAction(title: "delete", style: .Default) { (action) -> Void in
                self.superVC.tableVC.deleteOperation(wordSpell)
            }
            alertController.addAction(showStatus)
            alertController.addAction(backAction)
            alertController.addAction(reMemorizeAction)
            alertController.addAction(definitionAction)
            alertController.addAction(toRecordsAction)
            alertController.addAction(removeFromRecordsAction)
            alertController.addAction(deleteAction)
        }else {
            let add = UIAlertAction(title: "add", style: .Default, handler: { (action) -> Void in
                self.superVC.addWordDependingOnView(wordSpell)
                self.superVC.refreshDisplayDictionaryIfNeeded()
            })
            alertController.addAction(add)
        }
        
        
        let reLookupIndictionaryAction = UIAlertAction(title: "reLookUp", style: .Default) { (action) -> Void in
            self.superVC.tableVC.lookUpBuiltInDictionaryButtonDidPressed(wordSpell)
        }
        alertController.addAction(reLookupIndictionaryAction)
        
        let removeDicDataAfterAction = UIAlertAction(title: "removeDicDataAfter", style: .Default) { (action) -> Void in
            self.superVC.removeDicDataAfterwards()
        }
        alertController.addAction(removeDicDataAfterAction)
        let clearDicData = UIAlertAction(title: "clearDicData", style: .Default) { (action) -> Void in
            self.superVC.clearDictionaryData()
        }
        alertController.addAction(clearDicData)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in }
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func lookUpHistoryBack(sender: UIButton) {
        self.superVC.historyBackButtonPressed()
    }
    
    
    @IBAction func lookupHistoryForward(sender: UIButton) {
        self.superVC.historyForwardButtonPressed()
    }
    
    
    
    
    
    



}
