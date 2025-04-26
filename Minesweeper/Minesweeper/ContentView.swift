//
//  ContentView.swift
//  Minesweeper
//
//  Created by mac03 on 2025/4/25.
//

import SwiftUI
import UIKit

struct CellView: View {
    @ObservedObject var cell: Cell
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(cell.state.cellBackground)
                .frame(width: 25, height: 25)
            
            if cell.state == .revealed {
                if cell.hasMine {
                    Text("💣")
                } else {
                    Text("\(cell.mineSurround)")
                        .foregroundColor(cell.getTextColor())
                }
            } else if cell.state == .flagged {
                Text("🚩")
            }
        }
        .onTapGesture {
            if cell.state == .hidden {
                cell.state = .revealed
            }
        }
        .onLongPressGesture {
            switch cell.state {
            case .flagged:
                cell.state = .hidden
            case .hidden:
                cell.state = .flagged
            default:
                break
            }
        }
        .padding(5)
    }
}

struct CellMapView: View {
    @ObservedObject var gameboard: GameBoard
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<gameboard.row, id: \.self) { r in
                HStack(spacing: 0) {
                    ForEach(gameboard.board[r], id: \.id) { cell in
                        CellView(cell: cell)
                    }
                }
            }
        }
    }
}


class GameBoard: ObservableObject {
    var row: Int
    var col: Int
    var totalMines: Int
    var level: GameLevel
    
    @Published var board: [[Cell]]
    
    // default easy
    init(level: GameLevel = .easy) {
        self.row = level.row
        self.col = level.col
        self.totalMines = level.mineNum
        self.level = level
        
        self.board = []
        for _ in 0 ..< self.row {
            var rowArray: [Cell] = []
            for _ in 0 ..< self.col {
                rowArray.append(Cell(mineSurround: 2, state: .hidden, hasMine: false))
            }
            board.append(rowArray)
        }
        
        self.setUpMine()
    }
    
    func setUpMine() {
        for _ in 0 ..< self.totalMines {
            var r = Int.random(in: 0 ..< self.row)
            var c = Int.random(in: 0 ..< self.col)
            
            while board[r][c].hasMine {
                r = Int.random(in: 0 ..< self.row)
                c = Int.random(in: 0 ..< self.col)
            }
            
            board[r][c].hasMine = true
        }
    }
    
    func showBowrd() -> some View {
        return CellMapView(gameboard: self)
    }
}

class Cell: ObservableObject, Identifiable {
    let id = UUID()
    
    @Published var mineSurround: Int
    @Published var state: cellState
    @Published var hasMine: Bool
    
    init(mineSurround: Int = 0, state: cellState = .hidden, hasMine: Bool = false) {
        self.mineSurround = mineSurround
        self.state = state
        self.hasMine = hasMine
    }
    
    func getTextColor() -> Color {
        switch self.mineSurround {
        case 0:
            return Color.black
        case 1:
            return Color.blue
        case 2:
            return Color.green
        case 3:
            return Color.yellow
        case 4:
            return Color.purple
        default:
            return Color.red
        }
    }
}

struct ContentView: View {
    @StateObject var gameboard = GameBoard()
    
    var body: some View {
        gameboard.showBowrd()
    }
}

#Preview {
    ContentView()
}
