//
//  subSecondViewController.swift
//  combinedViewCon
//
//  Created by sugimon on 2016/06/11.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class subSecondViewController: SecondViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
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
//                self.cameraView.addSubview(cameraPicker)
            }
            else{
                cameraLabel.text = "error"
                
            }
        }
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
