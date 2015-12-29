//
//  TextViewController.swift
//  Psychologist
//
//  Created by 章敏杰 on 15/12/29.
//  Copyright © 2015年 zmj. All rights reserved.
//

import UIKit

class TextViewController: UIViewController
{

    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = text 
        }
    }
    
    var text:String = "" {
        didSet {
            textView?.text = text
        }
    }
    override var preferredContentSize:CGSize {
        get{
            if textView != nil && presentingViewController != nil{//presentationViewController也是父类的属性，表示当前显示的页面
            return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            
        } else {
            return super.preferredContentSize //无论如何要考虑所有情况
            }
        }
        set{ super.preferredContentSize = newValue }
    }
}
