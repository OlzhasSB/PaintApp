//
//  ShapeFactory.swift
//  PaintApp
//
//  Created by Olzhas Seiilkhanov on 28.06.2022.
//

import UIKit

protocol ShapeFactory {
    func create(configuration: ShapeConfiguration) -> UIBezierPath
}

extension UIBezierPath {
    func setup(with color: UIColor, linewidth: CGFloat, isFilled: Bool) {
        color.setStroke()
        if isFilled {
            color.setFill()
            fill()
        }
        self.lineWidth = linewidth
    }
}
