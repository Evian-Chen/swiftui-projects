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
                .fill(cell.color)
                .frame(width: 25, height: 25)
            
            if cell.isShowing {
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
                cell.isShowing.toggle()
                cell.color = .red
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
                rowArray.append(Cell())
            }
            board.append(rowArray)
        }
    }
    
    func setUpMine() {
        for i in 0 ..< self.totalMines {
            var r = Int.random(in: 0 ..< self.row)
            var c = Int.random(in: 0 ..< self.col)
            
            while board[r][c].hasMine {
                var r = Int.random(in: 0 ..< self.row)
                var c = Int.random(in: 0 ..< self.col)
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
    
    @Published var color = Color.gray
    @Published var mineSurround = 0
    @Published var isShowing = false
    @Published var isFlagged = false
    @Published var hasMine = false
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
