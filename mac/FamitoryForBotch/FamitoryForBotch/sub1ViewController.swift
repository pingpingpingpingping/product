//
//  sub1ViewController.swift
//  FamitoryForBotch
//
//  Created by sugimon on 2016/06/12.
//  Copyright © 2016年 ping. All rights reserved.
//

import UIKit

class sub1ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var subViewImage: UIImageView!
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraStart(self)
        
    }
    
    @IBAction func tapButton(sender: AnyObject) {
        cameraStart(self)
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
//        
//        
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            self.contentMode = .ScaleAspectFit
//            subViewImage.image = pickedImage
//        }
        
        //閉じる処理
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //    // 撮影がキャンセルされた時に呼ばれる
    //    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    //        picker.dismissViewControllerAnimated(true, completion: nil)
    //        cameraLabel.text = "Canceled"
    //    }
    
    
//    // 写真を保存
//    func savePic(sender : AnyObject) {
//        let image:UIImage! = subViewImage.image
//        
//        if image != nil {
//            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
//        }
//    }
//    
//    // 書き込み完了結果の受け取り
//    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>) {
//        print("1")
//        
//    }
    
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
