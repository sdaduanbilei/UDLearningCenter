//
//  JionViewController.swift
//  UDLearnCenter
//
//  Created by Scorpio on 15-5-14.
//  Copyright (c) 2015年 scorpio. All rights reserved.
//

import UIKit

class JionViewController: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var room: UITextField!
    @IBOutlet weak var item_a: UIImageView!
    @IBOutlet weak var item_c: UIImageView!
    @IBOutlet weak var item_b: UIImageView!
    @IBOutlet weak var item_d: UIImageView!
    
    var room_No:String!;
    var selected:String! ;
    var userModel:UserModel!;

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUp();
        self.room.delegate = self
    }
    
    func setUp(){
        let imgClick = UITapGestureRecognizer(target: self, action: "imgClick:");
        item_a.addGestureRecognizer(imgClick);
        item_a.userInteractionEnabled = true ;
        
        
        let imgClick_b = UITapGestureRecognizer(target: self, action: "imgClick:");
        item_b.addGestureRecognizer(imgClick_b);
        item_b.userInteractionEnabled = true ;

        let imgClick_c = UITapGestureRecognizer(target: self, action: "imgClick:");
        item_c.addGestureRecognizer(imgClick_c);
        item_c.userInteractionEnabled = true ;
        
        let imgClick_d = UITapGestureRecognizer(target: self, action: "imgClick:");
        item_d.addGestureRecognizer(imgClick_d);
        item_d.userInteractionEnabled = true ;
        
    }
    
    // 必须假如此方法 才会出现键盘
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    
    func imgClick(gesture:UIGestureRecognizer){
        print("iamge click")
        if let imageview = gesture.view as? UIImageView{
            var index = imageview.tag ;
            switch(index){
            case 1001:
                selected = "a"
                break;
            case 1002:
                selected = "b"
                break;
            case 1003:
                selected = "c"
                break;
            case 1004:
                selected = "d"
                break;
            default:
                break ;
            }
            room_No = room.text ;
            // 进入房间
            Jion(selected);
        }
    }
    
    
    func Jion(select:String){
        print("jion"+select)
       DataControl.JionRoom(room_No, selected: select, userid: userModel.userid, onSucc: { (response) -> Void in
        print(response)
        var json = JSON(response);
        
        if json["status"] == "y"{
            let answerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AnswerViewController") as AnswerViewController ;
            answerViewController.userModel = self.userModel ;
            answerViewController.userScore = json["score"].stringValue ;
            answerViewController.room = self.room_No ;
            self.navigationController?.pushViewController(answerViewController, animated: true)
        }else{
        ToolsUtil.msgBox(json["msg"].stringValue)
        }
       }) { (error) -> Void in
        print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func btn_jion(sender: AnyObject) {
        room_No = room.text ;
        Jion("");
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
