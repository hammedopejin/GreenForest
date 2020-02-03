//
//  ItemTableViewCell.swift
//  GreenForest
//
//  Created by Hammed opejin on 2/2/20.
//  Copyright © 2020 Hammed opejin. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func generateCell(_ item: Item) {
        
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            
        }
    }

}
