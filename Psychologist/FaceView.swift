//
//  FaceView.swift
//  Happiness
//
//  Created by 章敏杰 on 15/12/26.
//  Copyright © 2015年 zmj. All rights reserved.
//

import UIKit

protocol FaceViewDataSoure:class {
    func smilinessForFaceView(sender:FaceView) -> Double?
}

@IBDesignable
class FaceView: UIView
{
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet {setNeedsDisplay() } }
    @IBInspectable
    var color:UIColor = UIColor.blueColor() { didSet {setNeedsDisplay() } }
    @IBInspectable
    var scale:CGFloat = 0.9 { didSet {setNeedsDisplay() } }
    
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    weak var dataSoure:FaceViewDataSoure?
    
    func scale(gesture:UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
        
        
    override func drawRect(rect: CGRect)
    {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat (2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        let smiliness = dataSoure?.smilinessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }

    private struct Scaling{
        static let FaceRadiusToEyeRadiusRatio:CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio:CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio:CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio:CGFloat = 1
        static let FaceRadiusToMouthHeightRatio:CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio:CGFloat = 3
    }
    
    private enum Eye {case Left,Right} //左右眼
    //绘制眼睛
    private func bezierPathForEye(whichEye:Eye) -> UIBezierPath{
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizonTalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye{
        case .Left:eyeCenter.x -= eyeHorizonTalSeparation / 2
        case .Right:eyeCenter.x += eyeHorizonTalSeparation / 2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    //参数范围-1到1，正数表示开心，负数表示伤心
    private func bezierPathForSmile(fractionOfMaxSmile:Double) -> UIBezierPath {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVertiaclOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight  //这种写法保证了 -1到1的范围
        //设置四个点，开始结束和拐点，可以靠这四点绘制一条弧线
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVertiaclOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
}
