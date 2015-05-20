//
//  HomeViewController.swift
//  UDLearnCenter
//
//  Created by Scorpio on 15-5-19.
//  Copyright (c) 2015年 scorpio. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    @IBOutlet weak var user_type: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userHeaderImg: UIImageView!
    
    @IBOutlet weak var user_nickname: UIView!
    @IBOutlet weak var user_score: UIView!
    @IBOutlet weak var user_info: UIView!
    @IBOutlet weak var webView: UIWebView!
    var userModel :UserModel! ;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
                setUp();
                initUserIcon();
        
    }
    
    func setUp(){
        
        if userModel == nil{
            print("empty")
            
        }else{
            print("no empty" + userModel.userType + "\n")
            var screenWidth = UIScreen.mainScreen().bounds.width;
            var screenHeight  = UIScreen.mainScreen().bounds.height;
            
            
            // scrollview contentSize
            
            // 用户类型
            if self.userModel.userType == "0"{
                self.user_type.layer.cornerRadius = 8 ;
                self.user_type.setTitle("成人", forState: UIControlState.Normal)
            }
            // 用户头像
            AsyncImageUtil.sharedLoader.imageForUrl(userModel.head, completionHandler: {(image, url) -> () in
                if (image != nil) {
                    self.userHeaderImg.image = image!}
            })
            
            
            // 用户昵称
            let nick_name = UILabel(frame: CGRectMake(8, 0, user_nickname.frame.width, user_nickname.frame.height))
            nick_name.text = userModel.nickname ;
            user_nickname.layer.cornerRadius = 4 ;
            user_nickname.layer.masksToBounds = true ;
            user_nickname.layer.backgroundColor = UIColor(red:0.92, green:0.65, blue:0, alpha:1).CGColor ;
            user_nickname.addSubview(nick_name);
            
            // 用户积分
            user_score.layer.cornerRadius = 4 ;
            user_score.layer.backgroundColor = UIColor(red:0.92, green:0.65, blue:0, alpha:1).CGColor ;
            let title = UILabel(frame: CGRectMake(8, 0, user_score.frame.width,user_score.frame.height/2))
            title.text = "当前积分"
            user_score.addSubview(title)
            
            let score = UILabel(frame: CGRectMake(8, title.frame.height, user_score.frame.width, user_score.frame.height/2))
            score.text = userModel.score ;
            user_score.addSubview(score);
            
            // 用户单词量
            user_info.layer.cornerRadius = 4;
            user_info.layer.backgroundColor = UIColor(red:0.92, green:0.65, blue:0, alpha:1).CGColor ;
            
            let tips = UILabel(frame: CGRectMake(8, 0, user_info.frame.width, user_info.frame.height/3))
            tips.text = "成才信息"
            
            user_info.addSubview(tips)
            
            let cihui = UILabel(frame: CGRectMake(14, tips.frame.height, user_info.frame.width, user_info.frame.height/3))
            cihui.text = "词汇量" + userModel.words ;
            
            user_info.addSubview(cihui)
            
            let danci = UILabel(frame: CGRectMake(14, tips.frame.height + cihui.frame.height, user_info.frame.width, user_info.frame.height/3))
            let log:CGFloat = cihui.frame.height;
            
            danci.text = "会话量" + userModel.conversations ;
            
            user_info.addSubview(danci) ;
            
            // 用户能力图
            
            webView.layer.cornerRadius = 4 ;
            webView.backgroundColor = UIColor(red:0.92, green:0.65, blue:0, alpha:1) ;
            webView.opaque = true ;
            var user_id = userModel.userid ;
            print(DataControl.initURL())
            var service = DataControl.initURL() ;
            var url  = NSURL(string:service+"child/wuweiById?userId="+user_id)
            webView.loadRequest(NSURLRequest(URL: url!))
            
            
            
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 将头像设置为圆形头像
    private func initUserIcon(){
        let whiterColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1);
        self.userHeaderImg.layer.borderWidth = 2 ;
        self.userHeaderImg.layer.borderColor = whiterColor.CGColor;
        self.userHeaderImg.layer.cornerRadius = CGRectGetHeight(self.userHeaderImg.bounds)/2 ;
        self.userHeaderImg.clipsToBounds = true ;
    }
    
    @IBAction func btnJion(sender: AnyObject) {
        print("click")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "jion"{
            var jsonViewController  = segue.destinationViewController as JionViewController
            print("run this ===========")
            jsonViewController.userModel = self.userModel ;
        }
    }
    
    
    @IBAction func pushEditControllerView(sender: AnyObject) {
        
        let editViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditViewController") as EditViewController ;
        
        editViewController.userModel = self.userModel ;
        
        self.navigationController?.pushViewController(editViewController, animated: true)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
