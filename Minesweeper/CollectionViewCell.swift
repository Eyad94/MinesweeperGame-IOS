//
//  CollectionViewCell.swift
//  Minesweeper
//
//  Created by Eyad on 4/1/19.
//  Copyright © 2019 Afeka. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var labelCell: UILabel!
    
    
    
    
    func updateItemInCollectionView(item: ItemInCollectionView) -> Void {
        let itemState = item.GetItemCurrentState()
        let itemNumber = item.GetItemCurrentValue()
        
        if(itemState == ItemInCollectionView.itemState.MINES){
            imageViewCell.image = #imageLiteral(resourceName: "mine_image")
            labelCell.text = ""
            labelCell.textAlignment = .center;
        }
            
        else if(itemState == ItemInCollectionView.itemState.FLAG){
            imageViewCell.image = #imageLiteral(resourceName: "flag_image")
            labelCell.text = ""
            labelCell.textAlignment = .center;
        }
            
        else if(itemState == ItemInCollectionView.itemState.NUMBER && itemNumber > 0){
            labelCell.text = "\(itemNumber)"
            labelCell.textAlignment = .center;
            labelCell.textColor = (ItemInCollectionView.itemColor.NUMBER).color()
        }
        else{
            labelCell.text = ""
            labelCell.textAlignment = .center;
            labelCell.textColor = (ItemInCollectionView.itemColor.SPACE).color()
        }
        
    }
    
    
}
