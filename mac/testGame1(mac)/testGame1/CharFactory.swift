//
//  CharFactory.swift
//  testGame1
//
//  Created by sugimon on 2016/06/06.
//  Copyright © 2016年 sugimon. All rights reserved.
//

import UIKit
//import SpriteKit

class CharFactory {
    func createChar() -> Char {
        return Char()
    }
}

class Char1Factory: CharFactory {
    override func createChar() -> Char {
        return Char1()
    }
}

class Char2Factory: CharFactory {
    override func createChar() -> Char {
        return Char2()
    }
}

class Char3Factory: CharFactory {
    override func createChar() -> Char {
        return Char3()
    }
}