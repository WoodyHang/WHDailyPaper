//
//  AccountSettingController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/19.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//
///帐号设置页
import UIKit

class AccountSettingController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    enum chosePhotoType:Int {
        case Album;
        case Camara;
    }
    @IBAction func signOutClicked(sender: UIButton) {
        let alerViewController = UIAlertController(title: "提示", message: "确定要退出帐号？", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
            ///退出登录,更改登录状态
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "isLogin")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "isWeiboLogin")
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        alerViewController.addAction(action)
        let action1 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
            alerViewController.dismissViewControllerAnimated(false, completion: nil)
        }
        alerViewController.addAction(action1)
        self.presentViewController(alerViewController, animated: false, completion: nil)
            }
    @IBOutlet weak var phoneNumberLB: UILabel!
    @IBOutlet weak var emaiLB: UILabel!
    @IBOutlet weak var userNameLB: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let user = BmobUser.getCurrentUser()
        userNameLB.text = user.username
        phoneNumberLB.text = user.mobilePhoneNumber
        emaiLB.text = user.email
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addNavigatinBar()
        self.title = "帐号设置"
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()
        self.tableView.backgroundColor = UIColor.darkGrayColor()
        userPicture.layer.cornerRadius = 50
        ///为头像添加一个手势
        let tap = UITapGestureRecognizer(target: self, action: "onTap:")
        userPicture.addGestureRecognizer(tap)
        userPicture.clipsToBounds = true
        refreshIconUrl()
        
    }
    ///增加导航栏,并添加导航项
    func addNavigatinBar(){
        let backButton = UIButton()
        backButton.frame = CGRectMake(0, 0, 30, 30)
        backButton.addTarget(self, action: "backBtnClicked:", forControlEvents: UIControlEvents.TouchDown)
        backButton.setImage(UIImage(named: "back"), forState: .Normal)
        let leftButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    func backBtnClicked(sender:UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    ///刷新用户头像
    func refreshIconUrl(){
//        if NSUserDefaults.standardUserDefaults().objectForKey("isWeiboLogin") as?Bool == true {
//            userPicture.sd_setImageWithURL(NSURL(string: NSUserDefaults.standardUserDefaults().objectForKey("userIconUrl") as! String)!)
//        }else {
        let user:BmobUser = BmobUser.getCurrentUser()
        let urlString:String? = user.objectForKey("userIconUrl") as? String
        if urlString?.isEmpty == false{
        userPicture.sd_setImageWithURL(NSURL(string: urlString!))
//        }
        }
    }
    func onTap(sender:UITapGestureRecognizer){
        let alerController = UIAlertController(title: "选择相片", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let album = UIAlertAction(title: "相册", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
            self.chosePhoto(chosePhotoType.Album)
        }
        let camera = UIAlertAction(title: "相机", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
            self.chosePhoto(chosePhotoType.Camara)
        }
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
            alerController.dismissViewControllerAnimated(false, completion: nil)
        }
        alerController.addAction(album)
        alerController.addAction(camera)
        alerController.addAction(cancel)
        self.presentViewController(alerController, animated: false, completion: nil)
        
    }
    func chosePhoto(type:chosePhotoType){
        let picturePicker = UIImagePickerController()
        picturePicker.delegate = self
        picturePicker.allowsEditing = true
        if type == chosePhotoType.Album {
            picturePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }else if type == chosePhotoType.Camara {
            picturePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }else {
            SVProgressHUD.showErrorWithStatus("相机不可用")
            return
        }
        self.presentViewController(picturePicker, animated: false, completion: nil)
    }
    //#pragma mark - 选择图片
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let img = info[UIImagePickerControllerEditedImage] as! UIImage
        var imgData:NSData!
        if (UIImagePNGRepresentation(img) != nil) {
            imgData = UIImagePNGRepresentation(img)
        }else if (UIImageJPEGRepresentation(img, 1) != nil){
            imgData = UIImageJPEGRepresentation(img, 1)
        }
        ///压缩图片
        imgData = UIImageJPEGRepresentation(img, 0.000001)
        ///将图片尺寸变小
         let theImg = self.zipImageWithData(imgData, limitedWith: 100)
        picker.dismissViewControllerAnimated(false) { () -> Void in
            self.uploadImageWithImage(theImg)
        }
    }
    ///改变图片的大小
    func zipImageWithData(imgData:NSData!, var limitedWith width:CGFloat!) -> UIImage{
        ///获取图片大小
        let img:UIImage = UIImage(data: imgData)!
        let oldImgSize = img.size
        if width > oldImgSize.width {
            width = oldImgSize.width
        }
        let newHeight = oldImgSize.height * (width / oldImgSize.width)
        ///创建新的图片的大小
        let size = CGSizeMake(width, newHeight)
        ///开启一个图片句柄
        UIGraphicsBeginImageContext(size)
        // 将图片画入新的size里面
        img.drawInRect(CGRectMake(0, 0, size.width, size.height))
        // 从图片句柄中获取一张新的图片
        let newImg:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        ///关闭
        UIGraphicsEndImageContext()
        return newImg

    }
    ///上传图片到bmob服务器
    func uploadImageWithImage(img:UIImage){
        let data:NSData = UIImagePNGRepresentation(img)!;
        SVProgressHUD.showWithStatus("上传图片...")
        let bundle = NSBundle.mainBundle()
        let fileString = bundle.bundlePath + "/cs.txt"
        let file1:BmobFile = BmobFile(fileName: fileString, withFileData: data)
        file1.saveInBackground({ (isSuccessful:Bool, error:NSError!) -> Void in
            if isSuccessful == true {
                ///将上传的图片与用户关联起来
                let user = BmobUser.getCurrentUser()
                user.setObject(file1.url, forKey: "userIconUrl")
                user.updateInBackgroundWithResultBlock({ (isSuc:Bool, err:NSError!) -> Void in
                    if isSuc == true {
                        SVProgressHUD.showSuccessWithStatus("上传成功")
                        //从服务器上面抓取图片
                       let imgString = user.objectForKey("userIconUrl") as! String
                            self.userPicture.sd_setImageWithURL(NSURL(string: imgString)!)
//                        })
                    }else {
                        SVProgressHUD.showErrorWithStatus(err.localizedDescription)
                    }
                })
            }else {
                SVProgressHUD.showErrorWithStatus(error.localizedDescription)
            }
            }) { (progress:CGFloat) -> Void in
                SVProgressHUD.showProgress(Float(progress), status: String(progress * 100) + "%", maskType: SVProgressHUDMaskType.Black)
//                SVProgressHUD.showProgress(Float(progress * 100.0), maskType: SVProgressHUDMaskType.Gradient)
        }
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
