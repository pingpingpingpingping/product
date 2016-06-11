//
//  SecondViewController.swift
//  UIPageViewControllerSample
//
//  Created by 酒井文也 on 2016/04/02.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /////////////////////////
    @IBOutlet var cameraView : UIImageView!
    
    @IBOutlet var bCameraStart : UIButton!
    @IBOutlet var bSavePic : UIButton!
    @IBOutlet var bAlbum : UIButton!
    
    @IBOutlet var cameraLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // カメラの撮影開始
//    @IBAction func cameraStart(sender : AnyObject) {
//        
//        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
//        // カメラが利用可能かチェック
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
//            // インスタンスの作成
//            let cameraPicker = UIImagePickerController()
//            cameraPicker.sourceType = sourceType
//            cameraPicker.delegate = self
//            self.presentViewController(cameraPicker, animated: true, completion: nil)
////            self.cameraView.addSubview(cameraPicker)
//        }
//        else{
//            cameraLabel.text = "error"
//            
//        }
//    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            cameraView.contentMode = .ScaleAspectFit
            cameraView.image = pickedImage
            
        }
        
        //閉じる処理
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        cameraLabel.text = "Tap the [Save] to save a picture"
        
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        cameraLabel.text = "Canceled"
    }
    
    
    // 写真を保存
    @IBAction func savePic(sender : AnyObject) {
        let image:UIImage! = cameraView.image
        
        if image != nil {
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }
        else{
            cameraLabel.text = "image Failed !"
        }
        
    }
    
    // 書き込み完了結果の受け取り
    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>) {
        print("1")
        
        if error != nil {
            print(error.code)
            cameraLabel.text = "Save Failed !"
        }
        else{
            cameraLabel.text = "Save Succeeded"
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
            
            cameraLabel.text = "Tap the [Start] to save a picture"
        }
        else{
            cameraLabel.text = "error"
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
