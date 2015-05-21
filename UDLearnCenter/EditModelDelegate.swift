//
//  EditModelDelegate.swift
//  UDLearnCenter
//
//  Created by Scorpio on 15-5-21.
//  Copyright (c) 2015年 scorpio. All rights reserved.
//

import Foundation

@objc protocol EditModelDelegate{
    
    func editUserIcon(image:UIImage)
    
    func editUserName(name:String)
    
}