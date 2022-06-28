//
//  RectangleFactory.swift
//  PaintApp
//
//  Created by Olzhas Seiilkhanov on 28.06.2022.
//

import UIKit

final class RectangleFactory: ShapeFactory {
    func create(configuration: ShapeConfiguration) -> UIBezierPath {
        let rect = CGRect(
            x: configuration.startPoint.x,
            y: configuration.startPoint.y,
            width: configuration.endPoint.x - configuration.startPoint.x,
            height: configuration.endPoint.y - configuration.startPoint.y
        )
        let path = UIBezierPath(rect: rect)
        
        path.setup(
            with: configuration.color,
            linewidth: configuration.lineWidth,
            isFilled: configuration.isFilled
        )
        
        return path
    }
}
