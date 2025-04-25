# Minesweeper Game

This is a simple Minesweeper game built with SwiftUI. It features a customizable game board where the user can interact with cells, reveal mines, and flag cells.

> [!NOTE] 
> This project doesn't implement game logic.

## Features

- **Game Levels**: Choose between easy, medium, and hard levels.
- **Flagging**: Right-click or long press to flag a cell.
- **Cell States**: Cells can be hidden, revealed, or flagged.
- **Randomized Mines**: Mines are placed randomly on the game board.

## Game Levels

The game has three levels of difficulty:

- **Easy**: 9x9 grid, 10 mines
- **Medium**: 16x16 grid, 40 mines
- **Hard**: 16x30 grid, 99 mines

## How it Works

1. **GameBoard Initialization**: The `GameBoard` class initializes a grid of cells based on the selected level. Each cell is an instance of the `Cell` class, which holds the cell’s color, surrounding mine count, state (hidden or revealed), whether it contains a mine, and if it is flagged.

2. **Mines Setup**: Mines are placed randomly on the board when the game starts. The number of mines depends on the selected difficulty level.

3. **Cell Interaction**: 
   - **Tap Gesture**: Tap a cell to reveal it unless it is flagged.
   - **Long Press Gesture**: Long press a cell to flag it.

4. **Cell Rendering**: Each cell’s state (hidden, revealed, or flagged) is visually represented using SwiftUI’s `CellView`.

5. **Level Configuration**: The `GameLevel` enum allows for easy configuration of the game board's size and the number of mines for each difficulty level.

## Code Structure

### `CellView`
Responsible for displaying each individual cell on the board. It handles the logic for tapping and long-press gestures.

### `CellMapView`
Displays the full game board by looping through each row and column of the `GameBoard` object and rendering each cell using `CellView`.

### `GameBoard`
Manages the state of the game, including the grid of cells, mines, and game level. It also handles the logic for placing mines and rendering the board.

### `Cell`
Represents each individual cell in the grid, including its properties like color, state, surrounding mines, whether it has a mine, and whether it is flagged.

### `GameLevelEnum`
Defines the three difficulty levels (easy, medium, and hard), each with its respective grid size and mine count.

## How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/minesweeper.git
   cd minesweeper
   ```

2. Open the project in Xcode:
   ```bash
   open Minesweeper.xcodeproj
   ```

3. Build and run the project using Xcode's simulator.

## Future Enhancements

- Add a timer to track how long it takes to complete a game.
- Implement a "Game Over" state when a mine is revealed.
- Add difficulty settings that modify the grid size and mine placement.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
