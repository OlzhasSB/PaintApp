//
//  TriangleFactory.swift
//  PaintApp
//
//  Created by Olzhas Seiilkhanov on 28.06.2022.
//

import UIKit

final class TriangleFactory: ShapeFactory {
    func create(configuration: ShapeConfiguration) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: configuration.startPoint)
        path.addLine(to: CGPoint(x: configuration.startPoint.x, y: configuration.endPoint.y))
        path.addLine(to: configuration.endPoint)
        path.close()
        
        path.setup(
            with: configuration.color,
            linewidth: configuration.lineWidth,
            isFilled: configuration.isFilled
        )
        
        return path
    }
}
