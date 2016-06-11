//
//  Conversation.swift
//  FamitoryForBotch
//
//  Created by Hayato Kihara on 2016/06/12.
//  Copyright © 2016年 ping. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var output: UILabel!
    @IBOutlet weak var input: UITextField!
    
    //APIのID
    let apiId: String = "52475953583451334f524d706c2f61665a39317462554f4a56564a4f4555697975456d624d2e446c586d30"
    //APIのURL
    //    let apiUrl: String = "https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?APIKEY=\(apiId)"
    let apiUrl: String = "https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?APIKEY=52475953583451334f524d706c2f61665a39317462554f4a56564a4f4555697975456d624d2e446c586d30"
    //パラメータ指定
    var params =
        [
            "utt": "",
            "t": 20,
            "context": ""
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapSend(sender: AnyObject) {
        let inputText = input.text
        if inputText?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            params["utt"] = inputText
            Alamofire.request(.POST, apiUrl, parameters: params, encoding: .JSON, headers: ["Content-Type": "application/json; charset=UTF-8"]).responseString { response in
                if let JSON = response.result.value {
                    print(JSON)
                    let decode1 = JSON.componentsSeparatedByString("\"utt\":\"")
                    let decode2 = decode1[1].componentsSeparatedByString("\"")
                    self.output.text = decode2[0]
                    let decode3 = JSON.componentsSeparatedByString("\"context\":\"")
                    let decode4 = decode3[1].componentsSeparatedByString("\"")
                    self.params["context"] = decode4[0]
                }
            }
        }
    }
    
}