//
//  DiangnosedHaapinessViewController.swift
//  Psychologist
//
//  Created by 章敏杰 on 15/12/29.
//  Copyright © 2015年 zmj. All rights reserved.
//

import UIKit

class DiangnosedHaapinessViewController:HappinessViewController,UIPopoverPresentationControllerDelegate
{
    override var happiness:Int{
    didSet{
        diagnostHistory += [happiness]
    }
        
}
    private let defaults = NSUserDefaults.standardUserDefaults()
    var diagnostHistory:[Int]{
        get{return defaults.objectForKey(History.DefaultsKey) as? [Int] ?? []}
        set{defaults.setObject(newValue, forKey: History.DefaultsKey)}
        
}
    
    private struct History{
        static let SegueIdentifier = "Show Diagnostic History"
        static let DefaultsKey = "DiagnosedHappinessViewController.History"
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            switch identifier{
            case History.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController{
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    tvc.text = "\(diagnostHistory)"
                }
            default:break
                
            }
            
        }
        
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
