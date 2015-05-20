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
    @IBOutlet weak var temp_img: UIImageView!
    
    @IBOutlet weak var iamge_picker: UIImageView!
    
    var activiTextFile:UITextField! ;
    
    var picker:UIImagePickerController!
    var Phone:String!
    var Nickname:String!
    var Pwd:String!
    var actionSheet:UIActionSheet!
    var Usertype:String! = "0"
    var imageData:NSData!
    var imagePath:NSString!
    var dialog:FVCustomAlertView!
    
    var kPreferredTextFieldToKeyboardOffset: CGFloat = 20.0
    var keyboardFrame: CGRect = CGRect.nullRect
    var keyboardIsShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp();
        self.phone.delegate = self ;
        self.nickname.delegate = self ;
        self.pwd.delegate = self ;
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
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
        btn_adults.selected = true ;
        pwd.secureTextEntry = true ;
        
        
        let imgClick = UITapGestureRecognizer(target: self, action: "picker_click");
        self.temp_img.addGestureRecognizer(imgClick)
        self.temp_img.userInteractionEnabled = true ;
        
        AsyncImageUtil.CircleImageView(self.temp_img)
    }
    
    func picker_click(){
        var sheet: UIActionSheet = UIActionSheet()
        
        sheet.addButtonWithTitle("相机")
        sheet.addButtonWithTitle("相册")
        
        sheet.addButtonWithTitle("取消")
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1
        sheet.delegate = self
        sheet.showInView(self.view)
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
        if (self.activiTextFile != nil)
        {
            self.activiTextFile?.resignFirstResponder()
            self.activiTextFile = nil
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("start edit")
        self.activiTextFile = textField
        
        if(self.keyboardIsShowing)
        {
            self.arrangeViewOffsetFromKeyboard()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("end edit")
        activiTextFile = nil ;
    }
    
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage ;
        
        // 压缩图片
        var imageSize:CGSize! = image?.size
        imageSize.width = 144 ;
        imageSize.height = 144
        
        UIGraphicsBeginImageContext(imageSize)
        
        image?.drawInRect(CGRectMake(0, 0, 144, 144))
        var imageNew = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.imageData = UIImageJPEGRepresentation(imageNew, 0.5)
        
        // 显示圆形图片
        let whiterColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1);
        self.temp_img.image = imageNew ;
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
       
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancel")
        picker.dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    @IBAction func tap_pic(sender: AnyObject) {
        print("click")
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
