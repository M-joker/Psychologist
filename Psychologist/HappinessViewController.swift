//
//  HappinessViewController.swift
//  Happiness
//
//  Created by 章敏杰 on 15/12/26.
//  Copyright © 2015年 zmj. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController,FaceViewDataSoure
{
    var happiness:Int = 100 {//0代表伤心，100代表开心
        didSet {
            happiness = min(max(happiness, 0), 100)
            print("happiness = \(happiness)")
            updateUI()
        }
    }
    
    private func updateUI() {
        faceView?.setNeedsDisplay()
    }
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50)/50
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSoure = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale"))
        }
    }

    private struct Constants {
        static let HappinessGestureScale:CGFloat = 4
        
    }
    
    @IBAction func changehappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChanged = -Int(translation.y / Constants.HappinessGestureScale)
            if happinessChanged != 0 {
                happiness += happinessChanged
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default:break

        }
    }
    
}
