//
//  ItemInCollectionView.swift
//  Minesweeper
//
//  Created by Eyad on 4/1/19.
//  Copyright © 2019 Afeka. All rights reserved.
//

import UIKit

class ItemInCollectionView {
    
    enum itemState { case NUMBER, MINES, FLAG, HIDDEN_NUMBER, HIDDEN_MINES }
    var itemCurrentState: itemState = itemState.HIDDEN_NUMBER
    var itemCurrentValue: Int = 0
    var isCellOpen = false
    
    
    enum itemColor : Int {
        case NUMBER = 1, MINES, SPACE
        
        func color() -> UIColor {
            switch (self) {
            case .NUMBER:
                return UIColor(rgb: 0x800000)
                
            case .MINES:
                return UIColor(rgb: 0xFF0000)
                
            case .SPACE:
                return UIColor(rgb: 0x2B77BD)
            }
        }
    }
    

    
    func UpdateAfterOpenCell() {
        switch itemCurrentState {
            case .HIDDEN_NUMBER:
                self.itemCurrentState = itemState.NUMBER
                break
            case .HIDDEN_MINES:
                self.itemCurrentState = itemState.MINES
                break
            default:
                break
        }
        
        self.isCellOpen = true
    }
    

    
    func setMine() {
        self.itemCurrentValue = -1
        self.itemCurrentState = itemState.HIDDEN_MINES
    }
    
    
    
    public static func cellColor(isCellOpen: Bool)  -> UIColor {
        if(isCellOpen){
            return UIColor(rgb: 0x9FC5E8)
            }
        return UIColor(rgb: 0xCCCCCC)
    }
    
    
    func IncrementValue() {
        self.itemCurrentValue += 1
    }
    
    
    
    func GetItemCurrentState() -> itemState {
        return self.itemCurrentState;
    }
    
    
    
    func GetItemCurrentValue() -> Int {
        return self.itemCurrentValue;
    }
    
    
    func removeFlag() {
        if (itemCurrentValue == -1) {
            itemCurrentState = itemState.HIDDEN_MINES;
        }
        else {
            itemCurrentState = itemState.HIDDEN_NUMBER;
        }
    }
    
    
    func IsCellOpen() -> Bool {
        return self.isCellOpen;
    }
    
    
    func setFlag() {
        self.itemCurrentState = itemState.FLAG
    }
    
    
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: a)
    }
    
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: (rgb) & 0xFF, a: a)
    }
 
    
}

