//
//  ColorCell.swift
//  PaintApp
//
//  Created by Olzhas Seiilkhanov on 14.06.2022.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    static let identifier = "ColorCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
