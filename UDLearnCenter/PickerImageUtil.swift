//
//  PickerImageUtil.swift
//  UDLearnCenter
//
//  Created by Scorpio on 15-5-19.
//  Copyright (c) 2015年 scorpio. All rights reserved.
//

import Foundation
import UIKit

class PickerImageUtil {
    
    class func compressImage(image:UIImage,width:CGFloat,height:CGFloat) -> UIImage{
        var imageSize = image.size ;
        imageSize.width = width ;
        imageSize.height =  height ;
        
        UIGraphicsBeginImageContext(imageSize)
        
        image.drawInRect(CGRectMake(0, 0, width, height))
        let imageNew = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext() ;
        return imageNew 
    }
}
