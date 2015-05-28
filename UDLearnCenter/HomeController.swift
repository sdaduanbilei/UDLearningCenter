//
//  HomeController.swift
//  UDLearnCenter
//
//  Created by Scorpio on 15/5/26.
//  Copyright (c) 2015年 scorpio. All rights reserved.
//

import UIKit



class HomeController: UITableViewController ,EditModelDelegate{
    
    var userModel:UserModel!;

    
    @IBOutlet weak var user_type: UIButton!
    @IBOutlet weak var user_icon: UIImageView!
    @IBOutlet weak var user_nickname: UIView!
    @IBOutlet weak var user_score: UIView!
    @IBOutlet weak var user_info: UIView!
    @IBOutlet weak var label_nickname: UILabel!
    @IBOutlet weak var label_huihua: UILabel!
    @IBOutlet weak var label_cihui: UILabel!
    @IBOutlet weak var lable_score: UILabel!
    
    @IBOutlet weak var webview: UIWebView!
    
    
    @IBOutlet var btn_click: UITableView!
    var prefs:NSUserDefaults!
    
    override func viewDidLoad() {
        setup();
        prefs = NSUserDefaults.standardUserDefaults()
        self.title = "优迪斯学习中心"
    }
    
    
    func setup(){
        AsyncImageUtil.CircleImageView(user_icon)
        // 用户头像
        AsyncImageUtil.sharedLoader.imageForUrl(userModel.head, completionHandler: {(image, url) -> () in
            if (image != nil) {
                self.user_icon.image = image!}
        })
        
        self.label_nickname.text = userModel.nickname
        self.lable_score.text = userModel.score
        self.label_huihua.text = "会话量:" + userModel.conversations
        self.label_cihui.text = "词汇量:" + userModel.words
        
        
        webview.layer.cornerRadius = 4 ;
        webview.backgroundColor = UIColor(red:0.92, green:0.65, blue:0, alpha:1) ;
        webview.opaque = true ;
        var user_id = userModel.userid ;
        print(DataControl.initURL())
        var service = DataControl.initURL() ;
        var url  = NSURL(string:service+"child/wuweiById?userId="+user_id)
        webview.loadRequest(NSURLRequest(URL: url!))

        
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "jion2"{
            var jsonViewController  = segue.destinationViewController as! JionViewController
            print("run this ===========")
            jsonViewController.userModel = self.userModel ;
        }
        
        if segue.identifier == "edit" {
            var editController = segue.destinationViewController as! EditViewController
            editController.userModel = self.userModel;
            editController.delegate = self ;
        }
    }
    
    func refreshData(){
        var p = prefs.stringForKey("phone")
        var pass = prefs.stringForKey("pwd")
        DataControl.login(p!, pwd: pass!, onSucc: { (response) -> Void in
            print(response)
            var json = JSON(response)
            self.lable_score.text = json["score"].stringValue ;
        }) { (error) -> Void in
            print(error)
        }
    }

    func editUserName(name: String) {
        label_nickname.text = name ;
    }
    
    func editUserIcon(image: UIImage) {
        user_icon.image = image ;
    }
    
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear")
        refreshData()
    }
}
