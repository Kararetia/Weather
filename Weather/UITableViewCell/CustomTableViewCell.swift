//
//  CustomTableViewCell.swift
//  Weather
//
//  Created by Dima  on 15.07.2022.
//

import Foundation
import UIKit

class CustomTableViewCell:UITableViewCell {
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override var reuseIdentifier: String? {
        return "CustomTableViewCell"
    }
    
    
}

