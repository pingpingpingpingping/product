//
//  Button.swift
//  testGame1
//
//  Created by sugimon on 2016/06/06.
//  Copyright © 2016年 sugimon. All rights reserved.
//


import UIKit
import SpriteKit

class Button: SKSpriteNode {
    let afterTap: () -> ()
    
    init(text: String, rect: CGRect, afterTap: () -> ()) {
        self.afterTap = afterTap
        super.init(texture: nil, color: UIColor.clearColor(), size: rect.size)
        position = rect.origin
        
        let button = SKShapeNode(rect: CGRect(origin: CGPoint(), size: rect.size),
                                 cornerRadius: 4.0)
        button.fillColor = UIColor.darkGrayColor()
        button.strokeColor = UIColor.clearColor()
        addChild(button)
        let myLabel = SKLabelNode(fontNamed: "HiraginoSans-W6")
        myLabel.text = text
        myLabel.fontSize = 18
        myLabel.position = CGPoint(
            x:rect.width/2,
            y:rect.height/2-myLabel.frame.height/2+1)
        addChild(myLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
