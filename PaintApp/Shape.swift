//
//  Shape.swift
//  PaintApp
//
//  Created by Olzhas Seiilkhanov on 28.06.2022.
//

import UIKit

enum ShapeType {
    case circle
    case rectangle
    case line
    case triangle
    case pencil
    
    var factory: ShapeFactory {
        switch self {
        case .line: return LineFactory()
        case .circle: return CircleFactory()
        case .pencil: return LineFactory()
        case .rectangle: return RectangleFactory()
        case .triangle: return TriangleFactory()
        }
    }
}

struct ShapeViewModel {
    var color: UIColor
    var points: [(fromPoint: CGPoint, toPoint: CGPoint)]
    var type: ShapeType
    var isFilled: Bool
}

struct ShapeConfiguration {
    let startPoint: CGPoint
    let endPoint: CGPoint
    let isFilled: Bool
    let lineWidth: CGFloat = 2.0
    let color: UIColor
}
