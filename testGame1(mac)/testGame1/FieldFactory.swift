//
//  FieldFactory.swift
//  testGame1
//
//  Created by sugimon on 2016/06/04.
//  Copyright © 2016年 sugimon. All rights reserved.
//

import UIKit
import SpriteKit

class FieldFactory {
    private let fieldData = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1],
        [0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0],
        [0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0],
        [0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    ]
    
    func createField(viewSize: CGSize, fieldImageLength: CGFloat) -> Field {
        let field = Field()
        field.nodes = createFieldNodes(viewSize, fieldImageLength: fieldImageLength)
        field.start = CGPoint(x: fieldImageLength *  2, y: viewSize.height)
        field.end   = CGPoint(x: fieldImageLength * 13, y: viewSize.height - fieldImageLength * 9)
        
        return field
    }
    
    private func createFieldNodes(viewSize: CGSize, fieldImageLength: CGFloat) -> [SKSpriteNode] {
        var fieldNodes = [SKSpriteNode]()
        
        for (i, data) in fieldData.enumerate() {
            for (j, value) in data.enumerate() {
                let fieldNode = SKSpriteNode(imageNamed: "Field\(value)")
                fieldNode.name = "Field\(value)"
                fieldNode.size = CGSize(width: fieldImageLength, height: fieldImageLength)
                fieldNode.physicsBody = SKPhysicsBody(rectangleOfSize: fieldNode.size)
                fieldNode.physicsBody?.categoryBitMask = 0x0
                fieldNode.physicsBody?.collisionBitMask = 0x0
                fieldNode.position = CGPoint(
                    x: CGFloat(j) * fieldImageLength,
                    y: viewSize.height - CGFloat(i - 1) * fieldImageLength)
                fieldNode.zPosition = -1
                fieldNodes.append(fieldNode)
            }
        }
        return fieldNodes
    }
}

class Field {
    var nodes = [SKSpriteNode]()
    var start = CGPoint()
    var end   = CGPoint()
}