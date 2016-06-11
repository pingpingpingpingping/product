//
//  ViewController.swift
//  UIPageViewControllerSample
//
//  Created by 酒井文也 on 2016/04/02.
//  Copyright © 2016年 just1factory. All rights reserved.
//
//
//  ViewController.swift
//  AVFoundation002
//

import UIKit

struct PageSettings {
    static let buttonNavigationList: [String] = [
        "Start",
        "Save",
        "Album",
        "dummy1",
        "dummy2",
        "dummy3"
    ]

}
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet var cameraView : UIImageView!
    
    @IBOutlet var label : UILabel!
    
    @IBOutlet weak var scrollView :UIScrollView!
    
    // ページの高さ
    var pHeight:CGFloat!
    // ページの幅
    var pWidth:CGFloat!
    
    // Totalのページ数
    let pNum:Int  = PageSettings.buttonNavigationList.count
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Tap the [Start] to take a picture"
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        pWidth = screenSize.width
        
        let buttonElement: UIButton! = UIButton()
        
        for i in 0 ..< pNum {
            let n:Int = i+1
            
            // UIButtonのインスタンス
            var rect:CGRect = buttonElement.frame
            rect.size.height = pHeight/10
            rect.size.width = pWidth/3
            buttonElement.frame = rect
            buttonElement.setTitle(PageSettings.buttonNavigationList[i], forState: .Normal)
            buttonElement.tag = n
            // UIScrollViewのインスタンスに画像を貼付ける
            self.scrollView.addSubview(buttonElement)
            
        }
        
        setupScrollImages()
        
    }
    
    func setupScrollImages(){
        
        // ダミー画像
        let imageDummy:UIImage = UIImage(named:"1.jpg")!
        var imgView = UIImageView(image:imageDummy)
        var subviews:Array = scrollView.subviews
        
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
        
    }
    // カメラの撮影開始
    @IBAction func cameraStart(sender : AnyObject) {
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.presentViewController(cameraPicker, animated: true, completion: nil)
            
        }
        else{
            label.text = "error"
            
        }
    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            cameraView.contentMode = .ScaleAspectFit
            cameraView.image = pickedImage
            
        }
        
        //閉じる処理
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        label.text = "Tap the [Save] to save a picture"
        
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        label.text = "Canceled"
    }
    
    
    // 写真を保存
    @IBAction func savePic(sender : AnyObject) {
        let image:UIImage! = cameraView.image
        
        if image != nil {
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }
        else{
            label.text = "image Failed !"
        }
        
    }
    
    // 書き込み完了結果の受け取り
    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>) {
        print("1")
        
        if error != nil {
            print(error.code)
            label.text = "Save Failed !"
        }
        else{
            label.text = "Save Succeeded"
        }
    }
    
    // アルバムを表示
    @IBAction func showAlbum(sender : AnyObject) {
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.presentViewController(cameraPicker, animated: true, completion: nil)
            
            label.text = "Tap the [Start] to save a picture"
        }
        else{
            label.text = "error"
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}