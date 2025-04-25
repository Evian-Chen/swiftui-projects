//
//  ContentView.swift
//  Minesweeper
//
//  Created by mac03 on 2025/4/25.
//

import SwiftUI

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
                }
            } else if cell.isFlagged {
                Text("🚩")
            }
        }
        .onTapGesture {
            if !cell.isFlagged {
                cell.state = .revealed
            }
        }
        .onLongPressGesture {
            cell.isFlagged.toggle()
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
                rowArray.append(Cell(color: .gray, mineSurround: 0, state: .hidden, hasMine: false))
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
    
    @Published var color: Color
    @Published var mineSurround: Int
    @Published var state: cellState
    @Published var hasMine: Bool
    @Published var isFlagged: Bool
    
    init(color: SwiftUICore.Color = Color.gray, mineSurround: Int = 0, state: cellState, hasMine: Bool = false, isFlagged: Bool = false) {
        self.color = color
        self.mineSurround = mineSurround
        self.state = state
        self.hasMine = hasMine
        self.isFlagged = isFlagged
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
