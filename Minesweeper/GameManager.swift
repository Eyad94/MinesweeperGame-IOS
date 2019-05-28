//
//  GameManager.swift
//  Minesweeper
//
//  Created by Eyad on 4/1/19.
//  Copyright © 2019 Afeka. All rights reserved.
//


import UIKit

class GameManager {
    // var numOfMeansRemaing: Int
    var numOfHihddenCells: Int
    let gameSize: Int
    let numOfMines: Int
    var pointsOfCells = [(row: Int, col: Int)]()
    var matrixCollectionViewCells = [[ItemInCollectionView]]()
    var isBoardSet = false
    var gameOver = false
    var winGame = false
    
    
    func randomElement(s: Set<Int>) -> Int {
        let n = Int(arc4random_uniform(UInt32(s.count)))
        for (i, e) in s.enumerated() {
            if i == n { return e }
        }
        fatalError("Error in random Elements")
    }
    
    
    func isCellMines(cellIndex: Int) -> Bool {
        let cellTuple = indexToTuple(index: cellIndex)
        let itemInCollectionView = matrixCollectionViewCells[cellTuple.row][cellTuple.col]
        
        if( itemInCollectionView.GetItemCurrentState() == ItemInCollectionView.itemState.HIDDEN_MINES){
            return true
        }
        return false
    }
    
    
    public func getCellDataAt(indexPath: IndexPath) -> ItemInCollectionView {
        return matrixCollectionViewCells[indexPath.section][indexPath.item];
    }
    
    
    func indexToTuple(index: Int) -> (row: Int, col: Int) {
        return (index / gameSize, index % gameSize);
    }
    
    
    
    func tupleToIndex(tuple: (row: Int, col: Int)) -> Int {
        return tuple.row * gameSize + tuple.col;
    }
    
    
    
    func iterateOnCellAreaWithBlock<T>(cellTuple: (row: Int, col: Int), block: (_ blockRow: Int, _ blockCol: Int) -> T) -> [T] {
        
        var genericArr = [T]();
        
        let cellLeftUpCorner = (row: cellTuple.row - 1, col: cellTuple.col - 1);
        let cellRightDownCorner = (row: cellTuple.row + 1, col: cellTuple.col + 1);
        
        for row in cellLeftUpCorner.row...cellRightDownCorner.row {
            for col in cellLeftUpCorner.col...cellRightDownCorner.col {
                if(isNotDefinedInArray(cellTuple: (row, col))) { continue; };
                
                genericArr.append(block(row, col));
            }
        }
        
        return genericArr;
    }
    
    
    func isNotDefinedInArray(cellTuple: (row: Int, col: Int)) -> Bool {
        return cellTuple.row < 0 || cellTuple.row >= gameSize
            || cellTuple.col < 0 || cellTuple.col >= gameSize;
    }
    
    
    public func setUpCollectionView(startCellIndex: Int) {
        var emptyCells = [Int]();
        let cellTuple = indexToTuple(index: startCellIndex);
        emptyCells += iterateOnCellAreaWithBlock(cellTuple: cellTuple, block: { (row, col)  -> Int in
            return tupleToIndex(tuple: (row, col));
        });
        
        setMinesInCells(emptyCells: emptyCells);
        for bomb in pointsOfCells {
            minesNeighbors(bombTuple: bomb);
        }
    }
    
    
    init(gameSize: Int, numOfMines: Int) {
        self.numOfHihddenCells = gameSize * gameSize
        self.gameSize = gameSize
        self.numOfMines = numOfMines
        initMatrixCells()

    }
    
    
    
    func setMinesInCells(emptyCells: [Int]) {
        let size = (gameSize * gameSize) - 1;
        var avaliablePositions = Set<Int>(0...size);
        
        for cell in emptyCells {
            avaliablePositions.remove(cell);
        }
        
        for _ in 0...numOfMines - 1 {
            let bombPos = randomElement(s: avaliablePositions);
            let bombTuple = indexToTuple(index: bombPos);
            matrixCollectionViewCells[bombTuple.row][bombTuple.col].setMine();
            pointsOfCells.append(bombTuple);
            avaliablePositions.remove(bombPos);
        }
    }
    
    
    
    func minesNeighbors(bombTuple: (row: Int, col: Int)) {
        let _ = iterateOnCellAreaWithBlock(cellTuple: bombTuple, block: { row, col -> (row: Int, col: Int) in
            let cell = matrixCollectionViewCells[row][col]
            if(cell.GetItemCurrentState() == ItemInCollectionView.itemState.HIDDEN_NUMBER) {
                cell.IncrementValue()
            }
            return (row, col)
        });
    }
    
    
    func initMatrixCells() -> Void {
        for _ in 0...gameSize - 1 {
            var tempArr = [ItemInCollectionView]()
            for _ in 0...gameSize - 1 {
                tempArr.append(ItemInCollectionView())
            }
            matrixCollectionViewCells.append(tempArr)
        }
    }
    
    
    func clickOnCell(cellIndexPath: IndexPath) -> [IndexPath] {
        
        let indexOfCell = tupleToIndex(tuple: (cellIndexPath.section, cellIndexPath.item))
        
        if(!isBoardSet) {
            self.isBoardSet = true
            setUpCollectionView(startCellIndex: indexOfCell)
        }
        
        let cellsChanged: [IndexPath];
       
        if(isCellMines(cellIndex: indexOfCell)){
            cellsChanged = openAllCells()
            self.gameOver = true
        }
        else {
            cellsChanged = openCell(indexOfCell: indexOfCell)
        }

        if(numOfHihddenCells == numOfMines){
            self.winGame = true
        }
        
        return cellsChanged
    }
    
    
    
    func openCell(indexOfCell: Int) -> [IndexPath] {
        var listOfIndexPath = [IndexPath]();
        let cellTuple = indexToTuple(index: indexOfCell);
        let cell = matrixCollectionViewCells[cellTuple.row][cellTuple.col];
        let cellType = cell.GetItemCurrentState();
        
        switch cellType {
            case ItemInCollectionView.itemState.HIDDEN_NUMBER:
            
                cell.UpdateAfterOpenCell();
                self.numOfHihddenCells -= 1
                listOfIndexPath.append(IndexPath(item: cellTuple.col, section: cellTuple.row));
                if(cell.GetItemCurrentValue() > 0) {
                    return listOfIndexPath;
                }
                else {
                    let blockIndexPathArr =
                        iterateOnCellAreaWithBlock(cellTuple: cellTuple, block: { row, col -> [IndexPath] in
                            let tempTuple = (row, col);
                            return openCell(indexOfCell: tupleToIndex(tuple: tempTuple));
                        });
                    for indexPathSubArr in blockIndexPathArr {
                        for indexPath in indexPathSubArr {
                            listOfIndexPath.append(indexPath);
                        }
                    }
                }
                return listOfIndexPath

            default:
                return listOfIndexPath
        }
    }
    
    
    
    func openAllCells() -> [IndexPath]{
        var indexPathArr = [IndexPath]();
        for (section, cellSubArr) in matrixCollectionViewCells.enumerated() {
            for (item, cell) in cellSubArr.enumerated() {
                cell.UpdateAfterOpenCell();
                indexPathArr.append(IndexPath(item: item, section: section));
            }
        }
        return indexPathArr;
    }
    
    
    
    func setFlagInCell(cellIndexPath: IndexPath) -> (cellsChanged: [IndexPath], flags: Int) {
        let cellIndex = tupleToIndex(tuple: (cellIndexPath.section, cellIndexPath.item));
        let cellTuple = indexToTuple(index: cellIndex);
        let cell = matrixCollectionViewCells[cellTuple.row][cellTuple.col];
        var cellsChanged = [IndexPath]();
        var flags = 0;
        
        if(!cell.IsCellOpen()) {
            if(cell.GetItemCurrentState() == ItemInCollectionView.itemState.FLAG) {
                cell.removeFlag()
                flags = -1;
            }
            else {
                cell.setFlag();
                flags = 1;
            }
            cellsChanged.append(cellIndexPath);
        }
        
        return (cellsChanged, flags);
    }
}

