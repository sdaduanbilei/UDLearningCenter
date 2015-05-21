//
//  DataControl.swift
//  UDLearnCenter
//
//  Created by Scorpio on 15-5-12.
//  Copyright (c) 2015年 scorpio. All rights reserved.
//

import Foundation
import UIKit


var BASE_URL:String!;
var prefs:NSUserDefaults!

class DataControl {
    
    class func initURL() -> String{
        prefs = NSUserDefaults.standardUserDefaults();
        if let service  = prefs.stringForKey("service"){
            if service.isEmpty{
//                BASE_URL = "http://www.chuyuntech.com/cyClap/"
//                BASE_URL = "http://192.168.1.245/"
                BASE_URL = "http://112.112.170.66:8080/"
            }else{
            BASE_URL = "http://"+service+"/"}
        }else{
//            BASE_URL = "http://www.chuyuntech.com/cyClap/"
//            BASE_URL = "http://192.168.1.245/"
            BASE_URL = "http://112.112.170.66:8080/"
        }
        return BASE_URL ;
       
    }
    
    // 登录
    class func login(phone:String ,pwd:String,onSucc:(response:AnyObject) ->Void,onFail:(error:NSError)->Void) {
        initURL();
        print(BASE_URL)
        let manager = AFHTTPRequestOperationManager();
        
        let params = ["telNo":phone,"password":pwd]
        
        manager.POST(BASE_URL+"api/login", parameters: params, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) ->Void in
            onSucc(response: responseObject)
            print(responseObject)
            }) {(operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
            onFail(error: error)
        }
    }
    
    
    // 进入房间
    class func JionRoom(room:String,selected:String,userid:String ,onSucc:(response:AnyObject) ->Void,onFail:(error:NSError) ->Void){
        initURL();
        let manager = AFHTTPRequestOperationManager();
        var params:[String:String] ;
        if selected.isEmpty {
              params = ["roomNo":room,"userId":userid]
        }else{
             params = ["roomNo":room,"userId":userid,"team":selected]
        }
        manager.POST(BASE_URL+"api/room", parameters: params, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) ->Void in
            onSucc(response: responseObject)
            }) {(operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                onFail(error: error)
        }
    }
    
    
    
    // 回答问题
    class func AnswerQuestion(userid:String,options:String,room:String,onSucc:(response:AnyObject) -> Void,onFail:(error:NSError) ->Void){
        initURL();
        let manager = AFHTTPRequestOperationManager();
        var params = ["roomNo":room,"userId":userid,"options":options]
        manager.POST(BASE_URL+"api/answer", parameters: params, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) ->Void in
            onSucc(response: responseObject)
            }) {(operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                onFail(error: error)
        }
    }
    
    
    // 注册
    class func LogUp(phone:String,pwd:String ,nickname:String,imageData:NSData,userType:String,onSucc:(response:AnyObject)->Void,onFail:(error:NSError)->Void){
        initURL();
        let manager = AFHTTPRequestOperationManager();
        var params = ["telNo":phone,"password":pwd,"nickname":nickname,"userType":userType]
        manager.POST( BASE_URL+"api/register2", parameters: params,
            constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                data.appendPartWithFileData(imageData, name: "head", fileName: "head.jpg", mimeType: "image/jpeg")
                print(data)
                },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                print(responseObject)
                onSucc(response: responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
        })
    }
    
    // 编辑
    class func Edit(phone:String,pwd:String,nickname:String,type:Int,userid:String ,imageData:NSData,onSucc:(response:AnyObject) ->Void,onFail:(error:NSError) -> Void){
        initURL()
        print("有图")
        let manager = AFHTTPRequestOperationManager();
        var params = ["telNo":phone,"password":pwd,"nickname":nickname,"type":type,"user_id":userid]
        print(params)
        manager.POST( BASE_URL+"api/edit", parameters: params,
            constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                data.appendPartWithFileData(imageData, name: "head", fileName: "head.jpg", mimeType: "image/jpeg")
                print(data)
            },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                print(responseObject)
                onSucc(response: responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                onFail(error: error)
        })
    }
    
    
    // 编剧 无图
    class func Edit(phone:String,pwd:String,nickname:String,type:Int,userid:String,onSucc:(response:AnyObject) ->Void,onFail:(error:NSError) -> Void){
        print("无图")
        initURL()
        let manager = AFHTTPRequestOperationManager();
        var params = ["telNo":phone,"password":pwd,"nickname":nickname,"type":type,"user_id":userid]
        print(params)
        manager.POST( BASE_URL+"api/edit", parameters: params,
            constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                
            },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                print(responseObject)
                onSucc(response: responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription)")
                onFail(error: error)
        })
    }
}



