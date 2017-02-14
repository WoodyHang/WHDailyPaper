//
//  CollectionViewController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/11.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class CollectionViewController: SuperViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var collectionView:UICollectionView!
    var dataArray:[homeModel] = []
    var titleString:String?
    var id:String?
    var last_key:String?
    var imageString:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigatinBar(true)
        self.title = titleString
        
        //self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()
        self.view.backgroundColor = UIColor.whiteColor()
        createUI()
        addRefresh()
        SVProgressHUD.showWithStatus("数据正在加载中")
        self.requestData(self.id!, str2: "0.json?")
        // Do any additional setup after loading the view.
    }
    ///创建UI 
    func createUI(){
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: flowLayout)
        flowLayout.itemSize = CGSizeMake(SCREENWIDTH / 2 - 5, SCREENWIDTH / 2 - 5 + CGFloat(50))
        collectionView.backgroundColor = UIColor.lightGrayColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.view.addSubview(collectionView)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 5
        flowLayout.scrollDirection = .Vertical
        collectionView.registerNib(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.registerNib(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        flowLayout.headerReferenceSize = CGSizeMake(SCREENWIDTH, 200)

    }
    func addRefresh(){
        let footer = MJRefreshAutoGifFooter { () -> Void in
            self.requestData(self.id!, str2: self.last_key! + ".json?")
            
        }
        footer.automaticallyHidden = false
        footer.automaticallyRefresh = false
        var imageArr:[AnyObject] = []
        for var index = 1;index <= 21;index++ {
            let imageName = UIImage(named:"list_loading_\(index)" )
            imageArr.append(imageName!)
        }
        footer.setImages(imageArr, duration:1, forState:.Refreshing)
        footer.refreshingTitleHidden = true
        footer.stateLabel?.hidden = true
        footer.placeSubviews()
        self.collectionView.mj_footer = footer
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionCell
        cell.model = self.dataArray[indexPath.row]
        cell.backgroundColor = UIColor.whiteColor()

        return cell
        
    }
    ///数据相关
    func requestData(str1:String,str2:String){
        let url = KTOPICURL + str1 + "/" + str2
        netWorkingManager.requestData(url, par: nil) { (dataSource) -> Void in
            var responseDict = [:]
            responseDict = dataSource["response"] as! [String:AnyObject]
            self.last_key = responseDict["last_key"] as? String
            var feeds = []
            feeds = (responseDict["feeds"] as? [AnyObject])!
            for dict:[String:AnyObject] in feeds as! [Dictionary] {
                let model = homeModel.yy_modelWithDictionary(dict)
                self.dataArray.append(model!)
            }
            dispatch_async(dispatch_get_main_queue()
                , { () -> Void in
                    SVProgressHUD.dismiss()
                    self.collectionView.reloadData()
                    self.collectionView.mj_footer.endRefreshing()
            })
        }
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC = DetailViewController()
        let model = self.dataArray[indexPath.row]
        detailVC.htmlString = model.post["appview"] as! String
        self.presentViewController(detailVC, animated: true, completion: nil)
    }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        ///判断是否是组头
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier:"header", forIndexPath: indexPath) as! HeaderView
           let imageData = NSData(contentsOfURL: NSURL(string: self.imageString!)!)
           let scaleView:ScaleView = self.collectionView.addScaleImageViewWithImage(UIImage(data: imageData!))
           headerView.bigImageView.addSubview(scaleView)
           headerView.titleLabel.text = self.titleString
           headerView.clipsToBounds = false
           return headerView
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
