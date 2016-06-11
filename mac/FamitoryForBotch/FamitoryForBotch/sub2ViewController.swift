//
//  subViewController.swift
//  FamitoryForBotch
//
//  Created by sugimon on 2016/06/12.
//  Copyright © 2016年 ping. All rights reserved.
//
import UIKit

struct ButtonList{
    static let buttonNameList:[String]=[
        "1",
        "2",
        "4",
        "3",
        "5"
    ]
}

class sub2ViewController: UIViewController {
    
    @IBOutlet var scrollView :UIScrollView!
    
    // ページの高さ
    var pHeight:CGFloat!
    // ページの幅
    var pWidth:CGFloat!
    
    // Totalのページ数
    let pNum:Int  = ButtonList.buttonNameList.count
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        pWidth = screenSize.width
        pHeight = screenSize.height
        scrollView = UIScrollView()
        
        for i in 0 ..< pNum {
            let n:Int = i+1
            
            // UIImageViewのインスタンス
            let button:UIButton = UIButton()
            
            var rect:CGRect = button.frame
            rect.size.height = pHeight
            rect.size.width = pWidth/3
            button.frame = rect
            button.tag = n
            button.backgroundColor = UIColor.blackColor()
            button.setTitle(ButtonList.buttonNameList[n-1], forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            
            // UIScrollViewのインスタンスに画像を貼付ける
            self.scrollView.addSubview(button)
            
        }
        
        setupScrollImages()
        
    }
    
    
    func setupScrollImages(){
        
        // 描画開始の x,y 位置
        var px:CGFloat = 0.0
        let py:CGFloat = 0.0//pHeight*2
        
        let subviews:Array = scrollView.subviews
        
        for i in 0 ..< subviews.count {
            let subView: UIView
            subView = scrollView.subviews[i]
            if (subView.isKindOfClass(UIView) && subView.tag > 0){
                
                var viewFrame:CGRect = subView.frame
                viewFrame.origin = CGPointMake(px, py)
                subView.frame = viewFrame
                subView.backgroundColor = UIColor.cyanColor()
                self.view.bringSubviewToFront(subView)
                px += (pWidth)
                
            }
        }
//        var buttonFrame:CGRect = button.frame
//        buttonFrame.origin = CGPointMake(px, py)
//        button.frame = buttonFrame
        
        // UIScrollViewのコンテンツサイズを画像のtotalサイズに合わせる
        let nWidth:CGFloat = pWidth * CGFloat(pNum + 1)
        scrollView.contentSize = CGSizeMake(nWidth, pHeight)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}