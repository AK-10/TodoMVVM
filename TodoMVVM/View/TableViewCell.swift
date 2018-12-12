//
//  TableViewCell.swift
//  TodoMVVM
//
//  Created by Atsushi KONISHI on 2018/12/09.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(text: String) {
        self.label.text = text
    }
    
}
