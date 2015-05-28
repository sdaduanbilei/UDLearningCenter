//
//  EditViewController.swift
//  UDLearnCenter
//
//  Created by Scorpio on 15-5-20.
//  Copyright (c) 2015年 scorpio. All rights reserved.
//

import UIKit

class EditViewController: UIViewController ,UIActionSheetDelegate ,UINavigationControllerDelegate,UIImagePickerControllerDelegate ,UITextFieldDelegate {
    
    var userModel:UserModel!
    var prefs:NSUserDefaults!
    @IBOutlet weak var user_icon: UIImageView!

    @IBOutlet weak var user_pwd: UITextField!
    @IBOutlet weak var user_nickname: UITextField!
    @IBOutlet weak var user_phone: UITextField!
    
    var kPreferredTextFieldToKeyboardOffset: CGFloat = 20.0
    var keyboardFrame: CGRect = CGRect.nullRect
    var keyboardIsShowing: Bool = false
    var activiTextFile:UITextField! ;
    
    var imageData:NSData! ;
    var type_:Int!
    var imageNew:UIImage!
    
    var delegate:EditModelDelegate!
    
    var dialog :FVCustomAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefs = NSUserDefaults.standardUserDefaults()
        setUp();
        
        
        
        self.user_phone.delegate = self ;
        self.user_nickname.delegate = self ;
        self.user_pwd.delegate = self ;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        self.keyboardIsShowing = true
        
        if let info = notification.userInfo {
            self.keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
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
    
    // 必须假如此方法 才会出现键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (self.activiTextFile != nil)
        {
            self.activiTextFile?.resignFirstResponder()
            self.activiTextFile = nil
        }

    }
    

    func setUp(){
        // 头像
        AsyncImageUtil.CircleImageView(user_icon)
        AsyncImageUtil.sharedLoader.imageForUrl(userModel.head, completionHandler: { (image, url) -> () in
            if(image != nil){
                self.user_icon.image = image ;
            }
        })
        
        // 头像添加收拾
        let imgClick = UITapGestureRecognizer(target: self, action: "imgClick")
        self.user_icon.addGestureRecognizer(imgClick)
        self.user_icon.userInteractionEnabled = true ;
        
        // 信息
        user_phone.text = prefs.stringForKey("phone")
        user_nickname.text = userModel.nickname
        user_pwd.text = prefs.stringForKey("pwd")
        
    }
    
    
    func imgClick(){
        
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
            takePhoto()
            break;
        case 1:
            pickerImg()
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage ;
        self.imageNew = PickerImageUtil.compressImage(image!, width: 114, height: 114)
        self.user_icon.image = imageNew
        
        self.imageData = UIImageJPEGRepresentation(self.imageNew, 0.5)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
            picker.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func btn_updata(sender: AnyObject) {
        var phone_str = user_phone.text;
        var nickname_str = user_nickname.text ;
        var pwd_str = user_pwd.text ;
        
        
        self.dialog  = FVCustomAlertView();
        self.dialog.showDefaultLoadingAlertOnView(self.view, withTitle: "Loading")
        
        if imageData == nil {
            type_ = 2 ;
            
            DataControl.Edit(phone_str, pwd: pwd_str, nickname: nickname_str, type: type_, userid: userModel.userid , onSucc: { (response) -> Void in
                print(response)
                self.dialog.hideAlertFromView(self.dialog.currentView, fading: false)
                var json = JSON(response)
                var status = json["STATUS"].stringValue ;
                if (status == "y"){
                    ToolsUtil.msgBox(json["MSG"].stringValue)
                    if(self.imageData != nil){
                        self.delegate.editUserIcon(self.imageNew)
                    }
                    self.delegate.editUserName(nickname_str)
                }else{
                    ToolsUtil.msgBox(json["MSG"].stringValue)
                }
                
            }, onFail: { (error) -> Void in
                self.dialog.hideAlertFromView(self.dialog.currentView, fading: false)
                ToolsUtil.msgBox(error.localizedDescription)
                
            })
        }else{
            type_ = 1 ;
            
            DataControl.Edit(phone_str, pwd: pwd_str, nickname: nickname_str, type: type_, userid: userModel.userid ,imageData: imageData, onSucc: { (response) -> Void in
                print("")
                self.dialog.hideAlertFromView(self.dialog.currentView, fading: false)
                var json = JSON(response)
                var status = json["STATUS"].stringValue ;
                if (status == "y"){
                    ToolsUtil.msgBox(json["MSG"].stringValue)
                    
                    if(self.imageData != nil){
                        self.delegate.editUserIcon(self.imageNew)
                    }
                    self.delegate.editUserName(nickname_str)
                    
                }else{
                    ToolsUtil.msgBox(json["MSG"].stringValue)
                }
                
            }, onFail: { (error) -> Void in
                self.dialog.hideAlertFromView(self.dialog.currentView, fading: false)
                ToolsUtil.msgBox(error.localizedDescription)
                
            })
            
        }
        
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
