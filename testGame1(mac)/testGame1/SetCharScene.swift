//
//  SetCharScene.swift
//  testGame1
//
//  Created by sugimon on 2016/06/06.
//  Copyright © 2016年 sugimon. All rights reserved.
//

import UIKit
import SpriteKit

class SetCharScene: SKScene {
//    var chars = [Char]()
    var coin = 100
    var charData = [(factory: CharFactory, position: CGPoint)]()
    
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVectorMake(0, 0)
        let fieldImageLength = view.frame.width / 10
        let field = FieldFactory().createField(view.frame.size, fieldImageLength: fieldImageLength)
        field.nodes.forEach {
            addChild($0)
        }
        
        let buttonRect = CGRect(x: CGRectGetMaxX(self.frame) - 115,
                                y: CGRectGetMaxY(self.frame) - 49,
                                width: 110, height: 34)
        let button = Button(text: "ゲーム開始", rect: buttonRect, afterTap: {
            let scene = GameScene(fileNamed: "GameScene")
            scene?.scaleMode = .ResizeFill
            view.presentScene(scene)
            scene?.createChars(self.charData)
        })
        addChild(button)
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.count == 1, let point = touches.first?.locationInNode(self) {
            let alert = UIAlertController(title: nil, message: "どのキャラクターを設置しますか?",
                                          preferredStyle: .Alert)
            let rootViewController = UIApplication.sharedApplication().delegate?.window??.rootViewController
            alert.addAction(UIAlertAction(title: "Char1を設置", style: .Default, handler: { _ in
                let factory = Char1Factory()
                let char = factory.createChar()
                char.position = point
                self.coin -= char.cost
                self.addChild(char)
                self.charData.append((factory: factory, position: point))
            }))
            alert.addAction(UIAlertAction(title: "Char2を設置", style: .Default, handler: { _ in
                let factory = Char2Factory()
                let char = factory.createChar()
                char.position = point
                self.coin -= char.cost
                self.addChild(char)
                self.charData.append((factory: factory, position: point))
            }))
            alert.addAction(UIAlertAction(title: "Char3を設置", style: .Default, handler: { _ in
                let factory = Char3Factory()
                let char = factory.createChar()
                char.position = point
                self.coin -= char.cost
                self.addChild(char)
                self.charData.append((factory: factory, position: point))
            }))
            alert.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
            rootViewController?.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
