//
//  LogupViewController.swift
//  UDLearnCenter
//
//  Created by Scorpio on 15-5-15.
//  Copyright (c) 2015年 scorpio. All rights reserved.
//

import UIKit
import MobileCoreServices

class LogupViewController: UIViewController,UINavigationControllerDelegate ,UIImagePickerControllerDelegate ,UITextFieldDelegate ,UIActionSheetDelegate  {

    @IBOutlet weak var btn_adults: UIButton!
    @IBOutlet weak var btn_kids: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var selected_Img: UIButton!
    var picker:UIImagePickerController!
    var Phone:String!
    var Nickname:String!
    var Pwd:String!
    var actionSheet:UIActionSheet!
    var Usertype:String! = "0"
    var imageData:NSData!
    var imagePath:NSString!
    var dialog:FVCustomAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp();
        self.phone.delegate = self ;
        self.nickname.delegate = self ;
        self.pwd.delegate = self ;
        // Do any additional setup after loading the view.
    }

    func setUp(){
        btn_adults.selected = true ;
        pwd.secureTextEntry = true ;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func adultsClick(sender: AnyObject) {
        btn_adults.selected = true
        btn_kids.selected = false
        Usertype = "0" ;
        
    }

    @IBAction func kidsClick(sender: AnyObject) {
        btn_adults.selected = false ;
        btn_kids.selected = true
        Usertype = "1" ;
    }
    
    
    @IBAction func PickClick(sender: AnyObject) {
        var sheet: UIActionSheet = UIActionSheet()
        
        sheet.addButtonWithTitle("相机")
        sheet.addButtonWithTitle("相册")
        
        sheet.addButtonWithTitle("取消")
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1
        sheet.delegate = self
        sheet.showInView(self.view)
    }
    
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            print("click=====0")
            takePhoto();
            break;
        case 1:
            print("click=====1")
            pickerImg();
            break;
        default:
            break ;
        }
    }
    
    func takePhoto(){
        var sourceType = UIImagePickerControllerSourceType.Camera;
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        var picker  = UIImagePickerController();
        picker.delegate = self ;
        picker.allowsEditing = false ;
        picker.sourceType = sourceType ;
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func pickerImg(){
        var pickerImg = UIImagePickerController();
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            pickerImg.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            pickerImg.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(pickerImg.sourceType)!;
        }
        
        pickerImg.delegate = self ;
        pickerImg.allowsEditing = false ;
        self.presentViewController(pickerImg, animated: true, completion: nil)
        
    }
    
    @IBAction func btn_logup(sender: AnyObject) {
        Phone = phone.text;
        Nickname  = nickname.text ;
        Pwd = pwd.text ;
        print("phone==="+Phone+"===pwd=="+Pwd+"=="+Nickname)
        if Phone.isEmpty || Nickname.isEmpty || Pwd.isEmpty {
            ToolsUtil.msgBox("以上信息不能为空")
        }else{
            if (self.imageData == nil){
                ToolsUtil.msgBox("请设置头像")
            }else{
                self.dialog  = FVCustomAlertView();
                self.dialog.showDefaultLoadingAlertOnView(self.view, withTitle: "Loading")
                RegUp();
            }
            
        }
    }
    
    func RegUp(){
        DataControl.LogUp(Phone, pwd: Pwd, nickname: Nickname, imageData:self.imageData, userType: Usertype, onSucc: { (response) -> Void in
            print(response)
            var json = JSON(response);
            if json["status"] == "y"{
                self.dialog.hideAlertFromView(self.dialog.currentView, fading: false)
                ToolsUtil.msgBox("注册成功，请返回执行登录")
            }else{
                ToolsUtil.msgBox(json["MSG"].stringValue)
                self.dialog.hideAlertFromView(self.dialog.currentView, fading: false)
            }
        }) { (error) -> Void in
            print(error)
            self.dialog.hideAlertFromView(self.dialog.currentView, fading: false)
        }
    }
    
    
    // 必须假如此方法 才会出现键盘
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.scrollView.endEditing(true)
    }
    
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        print(info)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage ;
        let whiterColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1);
        self.selected_Img.imageView?.image = image ;
        self.selected_Img.layer.borderWidth = 2 ;
        self.selected_Img.layer.borderColor = whiterColor.CGColor ;
        self.selected_Img.layer.cornerRadius = CGRectGetHeight(self.selected_Img.bounds)/2
        self.selected_Img.clipsToBounds = true ;

//        imageURL = info[UIImagePickerControllerReferenceURL] as NSURL
        self.imageData = UIImageJPEGRepresentation(image!, 1.0)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancel")
        picker.dismissViewControllerAnimated(true, completion: nil)

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
