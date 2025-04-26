//
//  GameLevelEnum.swift
//  Minesweeper
//
//  Created by mac03 on 2025/4/25.
//

import SwiftUICore
import UIKit

enum cellState {
    case hidden
    case revealed
    case flagged
    
    var cellBackground: Color {
        switch self {
        case .hidden:
            return Color(UIColor.systemGray2)
        case .revealed:
            return Color(UIColor.systemGray4)
        case .flagged:
            return Color(UIColor.systemGray6)
        }
    }
}

enum GameLevel {
    case easy
    case medium
    case hard
    
    var row: Int {
        switch self{
        case .easy:
            return 9
        case .medium:
            return 16
        case .hard:
            return 16
        }
    }
    
    var col: Int {
        switch self{
        case .easy:
            return 9
        case .medium:
            return 16
        case .hard:
            return 30
        }
    }
    
    var mineNum: Int {
        switch self {
        case .easy:
            return 10
        case .medium:
            return 40
        case .hard:
            return 99
        }
    }
}
