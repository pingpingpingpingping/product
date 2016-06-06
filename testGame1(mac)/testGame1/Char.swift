//
//  Char.swift
//  testGame1
//
//  Created by sugimon on 2016/06/05.
//  Copyright © 2016年 sugimon. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class Char: SKSpriteNode {
    // stateMachineプロパティーがstateを保持する
    lazy var stateMachine: GKStateMachine = {
        let stateMachine = GKStateMachine(states: [
            AttackState(char: self),
            StayState(char: self)
            ])
        stateMachine.enterState(AttackState)
        return stateMachine
    }()
    
    // GKStateMachineが保持できるようにCharStateはGKStateのサブクラスにする
    class CharState: GKState {
        weak var char: Char?
        var power: Int {
            return char?.power ?? 0
        }
        
        init(char: Char?) {
            self.char = char
        }
        
        func enableToAttack() -> Bool {
            return false
        }
    }
    
    class AttackState: CharState {
        override func enableToAttack() -> Bool {
            return true
        }
    }
    
    class AngryState: CharState {
        var enteredDate = NSDate()
        override var power: Int {
            return char?.power ?? 0
        }
        
        override func enableToAttack() -> Bool {
            return true
        }
        
        override func didEnterWithPreviousState(previousState: GKState?) {
            enteredDate = NSDate()
        }
        
        override func updateWithDeltaTime(seconds: NSTimeInterval) {
            if NSDate().timeIntervalSinceDate(enteredDate) > 10 {
                // stateの変更はenterStateメソッドを利用する
                char?.stateMachine.enterState(AttackState)
            }
        }
    }
    
    class StayState: CharState {
        var enteredDate = NSDate()
        override func didEnterWithPreviousState(previousState: GKState?) {
            enteredDate = NSDate()
        }
        
        override func updateWithDeltaTime(seconds: NSTimeInterval) {
            if NSDate().timeIntervalSinceDate(enteredDate) > 0.2 {
                char?.stateMachine.enterState(AttackState)
            }
        }
        
        override func enableToAttack() -> Bool {
            return false
        }
    }
    //    var power = 1
    var power: Int {
        return 0
    }
    var cost: Int {
        return 10
    }
}
class Char1: Char {
    init() {
        super.init(texture: SKTexture(imageNamed: "Char1"), color: UIColor.clearColor(), size: CGSize(width: 32, height: 32))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var power: Int {
        return 1
    }
    override var cost: Int {
        return 10
    }
}

class Char2: Char {
    init() {
        super.init(texture: SKTexture(imageNamed: "Char2"), color: UIColor.clearColor(), size: CGSize(width: 32, height: 32))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var power: Int {
        return 2
    }
    override var cost: Int {
        return 20
    }
}

class Char3: Char {
    init() {
        super.init(texture: SKTexture(imageNamed: "Char3"), color: UIColor.clearColor(), size: CGSize(width: 32, height: 32))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var power: Int {
        return 3
    }
    override var cost: Int {
        return 30
    }
}