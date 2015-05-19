//
//  UserModel.swift
//  UDLearnCenter
//
//  Created by Scorpio on 15-5-13.
//  Copyright (c) 2015年 scorpio. All rights reserved.
//

import Foundation

class UserModel: NSObject {
    var userid :String
    var head :String
    var nickname :String
    var score :String
    var conversations :String
    var userType :String
    var words:String
    
    init(userid:String,head:String ,nickname:String ,score:String ,conversations:String,userType:String,words:String){
        
        self.userid = userid ;
        self.head = head ;
        self.nickname = nickname ;
        self.score = score ;
        self.conversations = conversations ;
        self.userType = userType;
        self.words = words ;
        
        
    }
    
}
