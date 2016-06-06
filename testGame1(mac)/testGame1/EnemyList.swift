//
//  EnemyList.swift
//  testGame1
//
//  Created by sugimon on 2016/06/04.
//  Copyright © 2016年 sugimon. All rights reserved.
//

import UIKit
import SpriteKit

class EnemyList {
    private var enemies = [Enemy]()
    
    func appendEnemy(enemy: Enemy) {
        enemies.append(enemy)
    }
    
    func isAllEnemyRemoved() -> Bool {
        return enemies.filter { $0.parent != nil }.count == 0
    }
    func enemiesCloseToPoint(point: CGPoint, distance: Double) -> [Enemy] {
        return enemies.filter {
            let dx = Double(point.x - $0.frame.origin.x)
            let dy = Double(point.y - $0.frame.origin.y)
            let distanceFromEnemy = sqrt(dx*dx + dy*dy)
            
            return distanceFromEnemy < distance
        }
    }
}
