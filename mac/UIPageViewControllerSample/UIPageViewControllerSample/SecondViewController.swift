//
//  SecondViewController.swift
//  UIPageViewControllerSample
//
//  Created by 酒井文也 on 2016/04/02.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

struct ButtonLabels {
    
    // ページの高さ
    var pHeight:CGFloat!
    // ページの幅
    var pWidth:CGFloat!
    
    static let buttonNavigationList: [String] = [
        "Start",
        "Save",
        "Album",
        "dummy1",
        "dummy2",
        "dummy3"
    ]
    
}

class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var subSecondView: UIView!
    @IBOutlet var subViewImage: UIImageView!
    @IBOutlet var scrollViewCon: scrollSecondViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // カメラの撮影開始
    func cameraStart(sender : AnyObject) {
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.presentViewController(cameraPicker, animated: true, completion: nil)
//            self.cameraView.addSubview(cameraPicker)
        }
    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            subSecondView.contentMode = .ScaleAspectFit
            subViewImage.image = pickedImage
        }
        
        //閉じる処理
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    // 撮影がキャンセルされた時に呼ばれる
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        picker.dismissViewControllerAnimated(true, completion: nil)
//        cameraLabel.text = "Canceled"
//    }
    
    
    // 写真を保存
    @IBAction func savePic(sender : AnyObject) {
        let image:UIImage! = subViewImage.image
        
        if image != nil {
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }
    }
    
    // 書き込み完了結果の受け取り
    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>) {
        print("1")
        
    }
    
//    // アルバムを表示
//    func showAlbum(sender : AnyObject) {
//        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
//            // インスタンスの作成
//            let cameraPicker = UIImagePickerController()
//            cameraPicker.sourceType = sourceType
//            cameraPicker.delegate = self
//            self.presentViewController(cameraPicker, animated: true, completion: nil)
//            
//        }
//        
//    }
    func setupScrollImages(){
        
        // 描画開始の x,y 位置
        var px:CGFloat = 0.0
        let py:CGFloat = 100.0
        
        for i in 0 ..< subviews.count {
            imgView = subviews[i] as! UIImageView
            if (imgView.isKindOfClass(UIImageView) && imgView.tag > 0){
                
                var viewFrame:CGRect = imgView.frame
                viewFrame.origin = CGPointMake(px, py)
                imgView.frame = viewFrame
                
                px += (pWidth)
                
            }
        }
        // UIScrollViewのコンテンツサイズを画像のtotalサイズに合わせる
        let nWidth:CGFloat = pWidth * CGFloat(pNum)
        scrollView.contentSize = CGSizeMake(nWidth, pHeight)
        

    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

class scrollSecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        // Totalのbutton数
        let bNum:Int  = ButtonLabels.buttonNavigationList.count
        
        ButtonLabels.pWidth = screenSize.width
        
        let buttonElement: UIButton! = UIButton()
        
        for i in 0 ..< bNum {
            let n:Int = i+1
            
            // UIButtonのインスタンス
            var rect:CGRect = buttonElement.frame
            rect.size.height = sHeight
            rect.size.width = sWidth
            buttonElement.frame = rect
            buttonElement.setTitle(PageSettings.buttonNavigationList[i], forState: .Normal)
            buttonElement.tag = n
            buttonElement.frame = CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
            // UIScrollViewのインスタンスに画像を貼付ける
            self.scrollView.addSubview(buttonElement)
            
        }
        
        setupScrollImages()
        
    }
}



