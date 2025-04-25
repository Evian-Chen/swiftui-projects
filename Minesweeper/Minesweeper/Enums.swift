//
//  GameLevelEnum.swift
//  Minesweeper
//
//  Created by mac03 on 2025/4/25.
//

enum cellState {
    case hidden
    case revealed
    
    var cellBackground: Color {
        switch self {
        case .hidden:
            return .gray
        case .revealed:
            return .red
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
