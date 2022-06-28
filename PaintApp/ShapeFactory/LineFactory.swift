//
//  LineFactory.swift
//  PaintApp
//
//  Created by Olzhas Seiilkhanov on 28.06.2022.
//

import UIKit

final class LineFactory: ShapeFactory {
    func create(configuration: ShapeConfiguration) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: configuration.startPoint)
        path.addLine(to: configuration.endPoint)
        
        path.setup(
            with: configuration.color,
            linewidth: configuration.lineWidth,
            isFilled: configuration.isFilled
        )
        
        return path
    }
}
