//
//  CanvasView.swift
//  PaintApp
//
//  Created by Olzhas Seiilkhanov on 15.06.2022.
//

import UIKit

class CanvasView: UIView {
    private var shapes = [ShapeViewModel]()
    var strokeColor: UIColor = .black
    var shapeType: ShapeType = .pencil
    var isFilled: Bool = false
    
    override func draw(_ rect: CGRect) {
        shapes.forEach { shape in
            shape.color.setStroke()
            shape.points.forEach { first, last in
                let factory = shape.type.factory
                
                let configuration = ShapeConfiguration(
                    startPoint: first,
                    endPoint: last,
                    isFilled: shape.isFilled,
                    color: shape.color
                )
                
                let path = factory.create(configuration: configuration)
                path.stroke()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let first = touches.first?.location(in: self) else { return }
        let viewModel = ShapeViewModel(
            color: strokeColor,
            points: [(first, CGPoint())],
            type: shapeType,
            isFilled: isFilled
        )
        shapes.append(viewModel)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let last = touches.first?.location(in: self) else { return }
    
        guard var lastPoint = shapes.popLast() else { return }
        guard var endPoint = lastPoint.points.popLast() else { return }
        endPoint.toPoint = last
        lastPoint.points.append(endPoint)

        if lastPoint.type == .pencil {
            lastPoint.points.append((last, last))
        }
        shapes.append(lastPoint)
        setNeedsDisplay()
    }
    
    func clearCanvasView() {
        shapes.removeAll()
        setNeedsDisplay()
    }
    
    func undoDraw() {
        if shapes.count > 0 {
            shapes.removeLast()
            setNeedsDisplay()
        }
    }
}
