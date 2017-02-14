//
//  ScrollerTableViewCell.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/3/18.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class ScrollerTableViewCell: UITableViewCell,UIScrollViewDelegate {
    //为imageview定义一个tag值
    let IMAGEVIEWTAG = 10
    var imageViewArray:[UIImageView] = []
    var _ScrollerArray:[homeModel] = []
    var pageController:UIPageControl!
    var ScrollerArray:[homeModel] {
        set {
        self._ScrollerArray = newValue
//            print(self._ScrollerArray.count)
            //在滑动视图左右各加一张图片
            let model1 = self._ScrollerArray.last
            let model2 = self._ScrollerArray.first
            self._ScrollerArray.insert(model1!, atIndex: 0)
            self._ScrollerArray.append(model2!)
//            print(self._ScrollerArray.count)
              for var i = 0;i<self._ScrollerArray.count;i++ {
                let  imageView = UIImageView(frame: CGRectMake(CGFloat(i)*SCREENWIDTH,0 ,SCREENWIDTH, 250))
                scrollerCell.addSubview(imageView)
                self.imageViewArray.append(imageView)
                let model = self._ScrollerArray[i]
                imageView.sd_setImageWithURL(NSURL(string:model.image!))
                let titleLabel = UILabel(frame: CGRectMake(10,180,SCREENWIDTH-20,50))
                imageView.addSubview(titleLabel)
                titleLabel.font = UIFont.systemFontOfSize(18)
                titleLabel.numberOfLines = 0
                titleLabel.adjustsFontSizeToFitWidth = true
                titleLabel.textAlignment = .Center
                titleLabel.textColor = UIColor.whiteColor()
                var dic:[String:AnyObject] = [:]
                dic = model.post
                titleLabel.text = dic["title"] as? String
                //                为图片添加手势
                imageView.userInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: "onTap:")
                imageView.addGestureRecognizer(tap)
                imageView.tag = IMAGEVIEWTAG + i
            }
            scrollerCell.pagingEnabled = true
            scrollerCell.contentSize = CGSizeMake(SCREENWIDTH * CGFloat(self._ScrollerArray.count),0)
            scrollerCell.contentOffset = CGPointMake(SCREENWIDTH, 0)
        }
        get{
         return []
}
    }

    @IBOutlet weak var scrollerCell: UIScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollerCell.delegate = self
       pageController = UIPageControl()
        pageController.center.x = self.center.x
        pageController.frame.size.width = 20
        pageController.frame.origin.y = 240
        pageController.frame.size.height = 10
       pageController.pageIndicatorTintColor = UIColor.grayColor()
        pageController.currentPageIndicatorTintColor = UIColor.yellowColor()
       pageController.numberOfPages = 3
        self.contentView.addSubview(pageController)
        pageController.currentPage = 0
        pageController.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        // Initialization code
        //定时器
        let timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "autoPlay", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode:  NSRunLoopCommonModes)
    }
    func autoPlay(){
     let x = scrollerCell.contentOffset.x
        //print(x)
        if x+SCREENWIDTH >= scrollerCell.contentSize.width {
            scrollerCell.setContentOffset(CGPointMake(SCREENWIDTH, 0), animated: false)
        }else {
            scrollerCell.setContentOffset(CGPointMake(x+SCREENWIDTH, 0), animated: false)
        }
    }
    func valueChanged(sender:UIPageControl) {
        let page = sender.currentPage
        print(page)
        let x = (page) * Int(SCREENWIDTH)
scrollerCell.setContentOffset(CGPointMake(CGFloat(x), 0), animated: true)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let page = (x + scrollView.frame.size.width/2)/scrollView.frame.size.width
        pageController.currentPage = Int(page) - 1
        if x == 0  {
            scrollerCell.setContentOffset(
                CGPointMake(3 * SCREENWIDTH,0), animated: false)
        }
        if x == 4 * SCREENWIDTH {
            scrollerCell.setContentOffset(CGPointMake(SCREENWIDTH,0), animated: false)
        }
    }
    func onTap(sender:UITapGestureRecognizer) {
        let imageView = sender.view
        let index = (imageView?.tag)! - IMAGEVIEWTAG
        let model = self._ScrollerArray[index]
        let detailVC = DetailViewController()
        detailVC.htmlString = model.post["appview"] as! String
        let viewVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        //detailVC.modalTransitionStyle = .PartialCurl
        viewVC!.presentViewController(detailVC, animated: true, completion: nil)
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
