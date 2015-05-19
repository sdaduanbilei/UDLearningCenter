// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let lblRect = CGRectMake(0, 0, 320, 100)
let view = UIView(frame: lblRect);

let title = UILabel(frame: CGRectMake(8, 0, 320, 50))
title.text = "text"
view.layer.cornerRadius = 5 ;
view.layer.masksToBounds = true ;
view.layer.backgroundColor = UIColor(red:0.86, green:0.25, blue:0.08, alpha:1).CGColor
view.addSubview(title)


let btn = UIButton(frame: lblRect)
btn.layer.cornerRadius = 5 ;
//btn.layer.backgroundColor = UIColor(red:0.35, green:0.7, blue:0.99, alpha:1).CGColor
btn.setBackgroundImage(UIImage(named: "a.png"), forState:UIControlState.Normal)
btn.setTitle("text", forState: UIControlState.Normal)




