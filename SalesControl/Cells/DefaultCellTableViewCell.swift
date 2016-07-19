//
//  DefaultCellTableViewCell.swift
//  SalesControl
//
//  Created by Juan Balderas on 7/9/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit

class DefaultCellTableViewCell: UITableViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scrollView.contentSize = CGSizeMake(500, 150)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
