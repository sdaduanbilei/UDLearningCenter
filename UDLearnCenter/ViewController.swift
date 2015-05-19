//
//  ViewController.swift
//  UDLearnCenter
//
//  Created by Scorpio on 15-4-30.
//  Copyright (c) 2015年 scorpio. All rights reserved.
//

import UIKit


class ViewController: UIViewController ,UITextFieldDelegate,UIAlertViewDelegate{

    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var pwd: UITextField!
    var userModel : UserModel!
    var dialog :FVCustomAlertView!
    var prefs:NSUserDefaults!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prefs = NSUserDefaults.standardUserDefaults();
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.98, green:0.32, blue:0.02, alpha:1)
        self.navigationController?.navigationBar.tintColor  = UIColor(red:0.16, green:0.16, blue:0.16, alpha:1)
        setUp();
        phone.delegate = self ;
        pwd.delegate = self ;
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setUp(){
        self.pwd.secureTextEntry = true ;
        
        if let user_prefs = self.prefs.stringForKey("phone"){
            phone.text = user_prefs ;
        }
        
        if let pwd_prefs = self.prefs.stringForKey("pwd"){
            pwd.text = pwd_prefs ;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func login(sender: AnyObject){
        var user = phone.text;
        var pass = pwd.text;
        
        if user.isEmpty || pass.isEmpty {
            ToolsUtil.msgBox("手机号或者密码为空")
        }else{
            self.dialog  = FVCustomAlertView();
            self.dialog.showDefaultLoadingAlertOnView(self.view, withTitle: "Loading")
            login(user, pass: pass)
        }
    }
    
    // 必须假如此方法 才会出现键盘
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    // 执行登录操作
    func login(user:String,pass:String){
        DataControl.login(user, pwd: pass, onSucc: { (response) -> Void in
            let json = JSON(response);
            let result = json["STATUS"].stringValue ;
            
            self.dialog.hideAlertFromView(self.dialog.currentView, fading: false)
            if(result=="y"){
                var head_url:String = json["head"].stringValue;
//                if head_url.isEmpty {
//                    var index = arc4random_uniform(12)+1
//                    var str = index.description ;
//                    head_url = "http://192.168.1.245/statics/images/head/"+str+".jpg"
//                    print(head_url)
//                }
                
                //保存配置文件
                self.prefs.setValue(user, forKey: "phone")
                self.prefs.setValue(pass, forKey: "pwd")
                
                self.userModel  = UserModel(userid: json["userId"].stringValue,head: head_url,nickname: json["nickname"].stringValue,score: json["score"].stringValue,conversations: json["conversations"].stringValue,userType: json["userType"].stringValue,words: json["words"].stringValue)
                // 调转到首页
                let mainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as? MainViewController;
                mainViewController?.userModel = self.userModel ;
                    self.navigationController?.pushViewController(mainViewController!, animated: true)
                }else{
                ToolsUtil.msgBox(json["MSG"].stringValue)
            }
            }) { (error) -> Void in
                
                ToolsUtil.msgBox(error.description)
        }}
    
    
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MainViewController"{
            var mainViewController  = segue.destinationViewController as MainViewController
            print("run this ===========")
            mainViewController.userModel = self.userModel ;
        }
    }
    
    
    
    @IBAction func btn_loacl_setting(sender: AnyObject) {
            var alertView = UIAlertView(title: "提示", message: "局域网服务器地址 如 192.16.1.10", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput ;
        alertView.show()
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        var str =  alertView.textFieldAtIndex(0)?.text.lowercaseString ;
        print("str"+str!)
        if str!.isEmpty{
            print("empty")
            self.prefs.setValue( str, forKey: "service")
        }else{
            print("no empty")
            self.prefs.setValue( str, forKey: "service")
        }
    }
 
}








