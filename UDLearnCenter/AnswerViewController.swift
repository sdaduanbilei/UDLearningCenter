//
//  AnswerViewController.swift
//  UDLearnCenter
//
//  Created by Scorpio on 15-5-14.
//  Copyright (c) 2015年 scorpio. All rights reserved.
//

import UIKit
import AVFoundation

class AnswerViewController: UIViewController {
    
    var userModel:UserModel!
    var userScore:String!
    var room:String!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var user_score: UILabel!
    @IBOutlet weak var room_no: UILabel!
    @IBOutlet weak var user_nick: UILabel!
    @IBOutlet weak var user_icon: UIImageView!
    
    var audioPlay_error:AVAudioPlayer!
    var audioPlay_right:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url_error = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("error", ofType:"mp3")!)
        audioPlay_error = AVAudioPlayer(contentsOfURL:url_error, error:nil)
        
        let url_right = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("right", ofType:"mp3")!)
        audioPlay_right = AVAudioPlayer(contentsOfURL:url_right, error:nil)
        
        setUp()
        // Do any additional setup after loading the view.
    }

    func setUp(){
        var screenWidht = UIScreen.mainScreen().bounds.width;
        var screenHeight = UIScreen.mainScreen().bounds.height ;
//        self.scrollview.contentSize = CGSizeMake(screenWidht, 3000)
        // 圆形头像
        AsyncImageUtil.CircleImageView(user_icon)
        user_nick.text = userModel.nickname ;
        room_no.text = room ;
        user_score.text = userScore ;
        
        AsyncImageUtil.sharedLoader.imageForUrl(userModel.head, completionHandler: { (image, url) -> () in
            self.user_icon.image = image ;
        })
        
        // 添加按钮
        
        let btn_size = self.contentView.frame.width / 2 ;
        let btn_a = UIButton(frame: CGRectMake(0, 0, btn_size,btn_size))
        btn_a.setBackgroundImage(UIImage(named: "a.png"), forState: UIControlState.Normal);
        btn_a.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
        btn_a.tag = 2001 ;
        
        self.contentView.addSubview(btn_a)
        
        let btn_b = UIButton(frame: CGRectMake(0, btn_size, btn_size,btn_size))
        btn_b.setBackgroundImage(UIImage(named: "c.png"), forState: UIControlState.Normal);
        btn_b.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
        btn_b.tag = 2002 ;
        self.contentView.addSubview(btn_b)
        
        let btn_c = UIButton(frame: CGRectMake(btn_size, 0, btn_size,btn_size))
        btn_c.setBackgroundImage(UIImage(named: "b.png"), forState: UIControlState.Normal);
        btn_c.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
        btn_c.tag = 2003 ;
        self.contentView.addSubview(btn_c)
        
        let btn_d = UIButton(frame: CGRectMake(btn_size, btn_size, btn_size,btn_size))
        btn_d.setBackgroundImage(UIImage(named: "d.png"), forState: UIControlState.Normal);
        btn_d.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
        btn_d.tag = 2004 ;
        self.contentView.addSubview(btn_d)
    }
    
    func AnstewQuestion(options:String){
        DataControl.AnswerQuestion(userModel.userid, options: options, room: room, onSucc: { (response) -> Void in
            print(response)
            var json = JSON(response);
           
            if let isright = json["ISRIGHT"].string{
                if isright == "y"{
                    self.user_score.backgroundColor = UIColor(red:0.3, green:0.67, blue:0.2, alpha:1) ;
                    self.user_score.text  = json["SCORE"].stringValue
                    self.audioPlay_right.play()
                }else{
                    self.user_score.backgroundColor = UIColor(red:0.8, green:0.08, blue:0.13, alpha:1) ;
                    self.audioPlay_error.play()
                }
            }
        }) { (error) -> Void in
            print(error)
        }
    }
    
    func onClick(sender:UIButton){
        var index = sender.tag ;
        var options = ""
        switch(index){
        case 2001:
            options = "a"
            break;
        case 2002:
            options = "c"
            break;
        case 2003:
            options = "b"
            break;
        case 2004:
            options = "d"
            break;
        default:
            break;
        }
        
        AnstewQuestion(options)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
