//
//  GameScene.swift
//  testGame1
//
//  Created by sugimon on 2016/06/04.
//  Copyright (c) 2016年 sugimon. All rights reserved.
//

import SpriteKit
import Foundation
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    enum State {
        case Playing
        case GameClear
        case GameOver
    }
    var state = State.Playing
    //    var enemies = SKSpriteNode()
    var enemyList = EnemyList()
    //    let char = Char(imageNamed: "Char")
    var chars = [Char]()
    var routes = [float2]()
    
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        // ↓ ここにあったField生成処理をFieldFactoryに移動
        let fieldImageLength = view.frame.width / 10
        let field = FieldFactory().createField(view.frame.size, fieldImageLength: fieldImageLength)
        field.nodes.forEach {
            addChild($0)
        }
        
        //        let pi = CGFloat(M_PI)
        //        let start:CGFloat = 0.0 // 開始の角度
        //        let end :CGFloat = 2.0*pi // 終了の角度
        //        var path: UIBezierPath = UIBezierPath();
        //        path.moveToPoint(CGPointMake(char.position.x, char.position.y))
        //        path.addArcWithCenter(CGPointMake(char.position.x, char.position.y), radius: 50, startAngle: start, endAngle: end, clockwise: true) // 円弧
        //        addChild(SKSpriteNode(path))
        
        routes = routesWithField(field)
        
        (0...10).forEach{
            performSelector(#selector(GameScene.createEnemy), withObject: nil, afterDelay: Double($0))
        }
    }
    
    func createEnemy(){
        guard let view = view else{
            return
        }
        
        let enemy = Enemy(imageNamed: "Enemy")
        var routes = self.routes
        var prevPosition = routes.removeFirst()
        let actions = routes.map { p->SKAction in
            let dx = p.x - prevPosition.x
            let dy = p.y - prevPosition.y
            let duration = Double(sqrt(dx*dx + dy*dy)/100)
            prevPosition = p
            return SKAction.moveTo(CGPoint(x: Double(p.x), y: Double(p.y)), duration: duration)
        }
        let fieldImageLength = view.frame.width / 10
        enemy.name = "enemy"
        enemy.position = CGPoint(x: fieldImageLength * 2, y: view.frame.height)
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.runAction(SKAction.sequence(actions)) {
            self.state = .GameOver
            
            let myLabel = SKLabelNode(fontNamed: "HiraginoSans-W6")
            myLabel.text = "ゲームオーバー"
            myLabel.fontSize = 45
            myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 20)
            self.addChild(myLabel)
        }
        addChild(enemy)
        
        //        enemies.append(enemy)
        enemyList.appendEnemy(enemy)
    }
    func createChars(charData: [(factory: CharFactory, position: CGPoint)]) {
        charData.forEach {
            let char = $0.factory.createChar()
            char.position = $0.position
            char.physicsBody = SKPhysicsBody(rectangleOfSize: char.size)
            char.physicsBody?.contactTestBitMask = 0x1
            addChild(char)
            chars.append(char)
        }
    }
    func didBeginContact(contact: SKPhysicsContact) {
        [contact.bodyA, contact.bodyB].forEach {
            if $0.node?.name == "enemy" {
                $0.node?.removeFromParent()
                $0.node?.removeAllActions()
            }
        }
        
        //    if enemies.filter({ $0.parent != nil }).count == 0 {
        if enemyList.isAllEnemyRemoved(){
            state = .GameClear
            
            let myLabel = SKLabelNode(fontNamed: "HiraginoSans-W6")
            myLabel.text = "ゲームクリア"
            myLabel.fontSize = 45
            myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 20)
            addChild(myLabel)
        }
    }
    private func routesWithField(field: Field) -> [vector_float2]{
        // 障害物情報を取得
        let fields = children.filter { $0.name == "Field0" }
        let obstacles = SKNode.obstaclesFromNodePhysicsBodies(fields)
        // ルート情報を取得
        let graph = GKObstacleGraph(obstacles: obstacles, bufferRadius: 10)
        let start = GKGraphNode2D(point: vector_float2(Float(field.start.x), Float(field.start.y)))
        let end = GKGraphNode2D(point: vector_float2(Float(field.end.x), Float(field.end.y)))
        graph.connectNodeUsingObstacles(start)
        graph.connectNodeUsingObstacles(end)
        let nodes = graph.findPathFromNode(start, toNode: end)
        return nodes.flatMap{$0 as? GKGraphNode2D}.map {$0.position}
    }
    override func update(currentTime: NSTimeInterval) {
        chars.forEach{char in
            char.stateMachine.updateWithDeltaTime(currentTime)
            if let charState = char.stateMachine.currentState as? Char.CharState where charState.enableToAttack() {
                enemyList.enemiesCloseToPoint(char.frame.origin, distance: 50).forEach {
                    $0.life -= charState.power
                    char.stateMachine.enterState(Char.StayState.self)
                    if $0.life <= 0 {
                        $0.physicsBody?.node?.removeFromParent()
                        $0.physicsBody?.node?.removeAllActions()
                        
                        if enemyList.isAllEnemyRemoved() {
                            state = .GameClear
                            
                            let myLabel = SKLabelNode(fontNamed: "HiraginoSans-W6")
                            myLabel.text = "ゲームクリア"
                            myLabel.fontSize = 45
                            myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 20)
                            addChild(myLabel)
                        }
                    }
                }
            }
        }
    }
    //    override func update(currentTime: NSTimeInterval) {
    //        if state == .Playing {
    //            enemy.position.x += 5
    //
    //            if frame.width < enemy.position.x {
    //                state = .GameOver
    //
    //                let myLabel = SKLabelNode(fontNamed: "HiraginoSans-W6")
    //                myLabel.text = "ゲームオーバー"
    //                myLabel.fontSize = 45
    //                myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 20)
    //                addChild(myLabel)
    //            }
    //        }
    //    }
}