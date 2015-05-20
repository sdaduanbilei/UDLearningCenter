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
    
    var kPreferredTextFieldToKeyboardOffset: CGFloat = 20.0
    var keyboardFrame: CGRect = CGRect.nullRect
    var keyboardIsShowing: Bool = false
    var activiTextFile:UITextField! ;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prefs = NSUserDefaults.standardUserDefaults();
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.98, green:0.32, blue:0.02, alpha:1)
        self.navigationController?.navigationBar.tintColor  = UIColor(red:0.16, green:0.16, blue:0.16, alpha:1)
        setUp();
        phone.delegate = self ;
        pwd.delegate = self ;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func keyboardWillShow(notification: NSNotification)
    {
        self.keyboardIsShowing = true
        
        if let info = notification.userInfo {
            self.keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
            self.arrangeViewOffsetFromKeyboard()
        }
        
    }
    
    func arrangeViewOffsetFromKeyboard()
    {
        var theApp: UIApplication = UIApplication.sharedApplication()
        var windowView: UIView? = theApp.delegate!.window!
        
        var textFieldLowerPoint: CGPoint = CGPointMake(self.activiTextFile!.frame.origin.x, self.activiTextFile!.frame.origin.y + self.activiTextFile!.frame.size.height + 50)
        
        var convertedTextFieldLowerPoint: CGPoint = self.view.convertPoint(textFieldLowerPoint, toView: windowView)
        
        var targetTextFieldLowerPoint: CGPoint = CGPointMake(self.activiTextFile!.frame.origin.x, self.keyboardFrame.origin.y - kPreferredTextFieldToKeyboardOffset)
        
        var targetPointOffset: CGFloat = targetTextFieldLowerPoint.y - convertedTextFieldLowerPoint.y
        var adjustedViewFrameCenter: CGPoint = CGPointMake(self.view.center.x, self.view.center.y + targetPointOffset )
        
        UIView.animateWithDuration(0.2, animations:  {
            self.view.center = adjustedViewFrameCenter
        })
    }
    
    func returnViewToInitialFrame()
    {
        var initialViewRect: CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
        
        if (!CGRectEqualToRect(initialViewRect, self.view.frame))
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame = initialViewRect
            });
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        self.keyboardIsShowing = false
        
        self.returnViewToInitialFrame()
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("start edit")
        self.activiTextFile = textField
        
        if(self.keyboardIsShowing)
        {
            self.arrangeViewOffsetFromKeyboard()
        }
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
//        if (self.activiTextFile != nil)
//        {
//            self.activiTextFile?.resignFirstResponder()
//            self.activiTextFile = nil
//        }
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
                let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController;
                homeViewController?.userModel = self.userModel ;
                    self.navigationController?.pushViewController(homeViewController!, animated: true)
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
        var str =  alertView.textFieldAtIndex(0)?.text;
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








