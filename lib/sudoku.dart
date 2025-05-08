import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'back_button_to_activity_center.dart';
// Import the back button
import 'gradient_theme.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  @override
  SudokuScreenState createState() => SudokuScreenState();
}

class SudokuScreenState extends State<SudokuScreen> {
  List<List<String>> board = List.generate(
    9,
    (_) => List.generate(9, (_) => ''),
  );
  List<List<Set<String>>> notes = List.generate(
    9,
    (_) => List.generate(9, (_) => {}),
  );
  List<List<bool>> fixedCells = List.generate(
    9,
    (_) => List.generate(9, (_) => false),
  );
  int? selectedRow;
  int? selectedCol;
  String? selectedNumber;
  bool pencilMode = false;
  List<Map<String, dynamic>> actionHistory = [];

  @override
  void initState() {
    super.initState();
    generatePuzzle();
  }

  void generatePuzzle() {
    List<List<String>> newBoard = List.generate(
      9,
      (_) => List.generate(9, (_) => ''),
    );
    List<List<int>> grid = List.generate(9, (_) => List.generate(9, (_) => 0));

    fillDiagonal(grid);

    if (solveSudoku(grid)) {
      newBoard =
          grid.map((row) => row.map((e) => e.toString()).toList()).toList();

      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (Random().nextBool()) {
            newBoard[i][j] = '';
          } else {
            fixedCells[i][j] = true;
          }
        }
      }
    }

    setState(() {
      board = newBoard;
    });
  }

  void fillDiagonal(List<List<int>> grid) {
    for (int i = 0; i < 9; i += 3) {
      List<int> nums = List.generate(9, (index) => index + 1);
      nums.shuffle(Random());
      for (int j = 0; j < 9; j++) {
        grid[i + j ~/ 3][(i + j % 3)] = nums[j];
      }
    }
  }

  bool solveSudoku(List<List<int>> grid) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (isSafe(grid, row, col, num)) {
              grid[row][col] = num;
              if (solveSudoku(grid)) {
                return true;
              }
              grid[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  bool isSafe(List<List<int>> grid, int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (grid[row][i] == num || grid[i][col] == num) {
        return false;
      }
    }
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[i + startRow][j + startCol] == num) {
          return false;
        }
      }
    }
    return true;
  }

  void selectCell(int row, int col) {
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  void selectNumber(String number) {
    setState(() {
      selectedNumber = number;
      if (selectedRow != null &&
          selectedCol != null &&
          !fixedCells[selectedRow!][selectedCol!]) {
        if (pencilMode) {
          Set<String> currentNotes = notes[selectedRow!][selectedCol!];
          if (currentNotes.contains(number)) {
            currentNotes.remove(number);
          } else {
            currentNotes.add(number);
          }
        } else {
          actionHistory.add({
            'row': selectedRow,
            'col': selectedCol,
            'prev': board[selectedRow!][selectedCol!],
            'notes': Set<String>.from(notes[selectedRow!][selectedCol!]),
          });
          board[selectedRow!][selectedCol!] = number;
          notes[selectedRow!][selectedCol!] = {};
        }
      }
    });
  }

  void togglePencil() {
    setState(() {
      pencilMode = !pencilMode;
    });
  }

  void erase() {
    if (selectedRow != null &&
        selectedCol != null &&
        !fixedCells[selectedRow!][selectedCol!]) {
      setState(() {
        actionHistory.add({
          'row': selectedRow,
          'col': selectedCol,
          'prev': board[selectedRow!][selectedCol!],
          'notes': Set<String>.from(notes[selectedRow!][selectedCol!]),
        });
        board[selectedRow!][selectedCol!] = '';
        notes[selectedRow!][selectedCol!] = {};
      });
    }
  }

  void undo() {
    if (actionHistory.isNotEmpty) {
      var last = actionHistory.removeLast();
      setState(() {
        board[last['row']][last['col']] = last['prev'];
        notes[last['row']][last['col']] = last['notes'];
      });
    }
  }

  bool isConflict(int row, int col, String value) {
    for (int i = 0; i < 9; i++) {
      if ((i != col && board[row][i] == value) ||
          (i != row && board[i][col] == value)) {
        return true;
      }
    }
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        int r = startRow + i;
        int c = startCol + j;
        if ((r != row || c != col) && board[r][c] == value) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gridSize = screenWidth * 0.9;
    gridSize = gridSize.clamp(300.0, 360.0);
    double cellSize = gridSize / 9;

    final gradient =
        Theme.of(context).extension<GradientTheme>()!.containerGradient;

    return Scaffold(
      appBar: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient, // Your gradient here
        ),
        child: AppBar(
          backgroundColor: Colors.transparent, // Needed to show the gradient
          elevation: 0,
          leading: BackToActivityCenterButton(), // 🟣 Custom back button
        ),
      ),
    ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(gradient: gradient),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "MindMend",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sudoku",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                SizedBox(height: 20),
                Container(
                  width: gridSize,
                  height: gridSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(blurRadius: 6, color: Colors.black26),
                    ],
                  ),
                  child: Column(
                    children: List.generate(9, (row) {
                      return Row(
                        children: List.generate(9, (col) {
                          bool isSelected =
                              selectedRow == row && selectedCol == col;
                          bool isConflictCell =
                              board[row][col] != '' &&
                              isConflict(row, col, board[row][col]);
                          return GestureDetector(
                            onTap: () => selectCell(row, col),
                            child: Container(
                              width: cellSize,
                              height: cellSize,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.black,
                                    width: row % 3 == 0 ? 1.5 : 0.5,
                                  ),
                                  left: BorderSide(
                                    color: Colors.black,
                                    width: col % 3 == 0 ? 1.5 : 0.5,
                                  ),
                                  right: BorderSide(
                                    color: Colors.black,
                                    width: (col + 1) % 3 == 0 ? 1.5 : 0.5,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: (row + 1) % 3 == 0 ? 1.5 : 0.5,
                                  ),
                                ),
                                color:
                                    isConflictCell
                                        ? Colors.red[100]
                                        : isSelected
                                        ? Colors.purple[100]
                                        : Colors.white,
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      board[row][col],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            fixedCells[row][col]
                                                ? Colors.black
                                                : Colors.blue,
                                      ),
                                    ),
                                  ),
                                  if (board[row][col] == '' &&
                                      notes[row][col].isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Wrap(
                                          spacing: 2,
                                          runSpacing: 2,
                                          children:
                                              notes[row][col].map((note) {
                                                return Text(
                                                  note,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey[700],
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(9, (i) {
                    String num = (i + 1).toString();
                    return GestureDetector(
                      onTap: () => selectNumber(num),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          num,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        LucideIcons.pencil,
                        color: pencilMode ? Colors.purple[200] : Colors.white,
                      ),
                      onPressed: togglePencil,
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.eraser, color: Colors.white),
                      onPressed: erase,
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.undo, color: Colors.white),
                      onPressed: undo,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
