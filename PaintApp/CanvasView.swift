//
//  CanvasView.swift
//  PaintApp
//
//  Created by Olzhas Seiilkhanov on 15.06.2022.
//

import UIKit

// MARK: - Originator

class CanvasView: UIView {

    private var shapes = [ShapeViewModel]()
    
    var strokeColor: UIColor = .black
    var shapeType: ShapeType = .pencil
    var isFilled: Bool = false
    
    lazy var caretaker = Caretaker(painter: self)
    
    func saveState() -> Memento {
        return PainterMemento(shapes: shapes)
    }

    func restore(state: Memento) {
        shapes = state.shapes
        setNeedsDisplay()
    }
    
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
        if shapes.isEmpty { caretaker.save() }
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        caretaker.save()
    }
    
    func redoDraw() {
//        shapes.removeAll()
        caretaker.redo(steps: 1)
        setNeedsDisplay()
    }
    
    func undoDraw() {
//        if shapes.count > 0 {
//            shapes.removeLast()
            
            caretaker.undo(steps: 1)
            setNeedsDisplay()
//        }
    }
}
