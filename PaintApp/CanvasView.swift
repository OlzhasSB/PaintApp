//
//  CanvasView.swift
//  PaintApp
//
//  Created by Olzhas Seiilkhanov on 15.06.2022.
//

import UIKit

// MARK: - Momento

protocol Memento {
    var shapes: [ShapeViewModel] { get }
}

class PainterMemento: Memento {
    var shapes: [ShapeViewModel]

    init(shapes: [ShapeViewModel]) {
        self.shapes = shapes
    }
}

//
//class PainterManager {
//    static let shared = PainterManager()
//
//    var shapes = [ShapeViewModel]()
//
//    func save() -> PainterMemento {
//        return PainterMemento(shapes: self.shapes)
//    }
//
//    func load(state: PainterMemento) {
//        self.shapes = state.shapes
//    }
//
//    func printShapes(in view: UIView) {
//        for v in view.layer.sublayers! {
//            v.removeFromSuperlayer()
//        }
//        for shape in shapes {
//            let path = UIBezierPath()
//            path.move(to: )
//            path.addLine(to: )
//            drawShapeLayer()
//        }
//
//
//    }
//    private func drawShapeLayer() {
//
//    }
//}
//
//class CarrierState {
//    var state: PainterMemento?
//    var painterManager: PainterManager
//
//    init(painterManager: PainterManager) {
//        self.painterManager = painterManager
//    }
//
//    public func saveShape() {
//        state = painterManager.save()
//    }
//
//    func loadShape() {
//        guard state != nil else { return }
//        painterManager.load(state: state!)
//    }
//}
//


// MARK: - Caretaker

class Caretaker {
    
    var states: [Memento] = []
    var currentIndex: Int = 0
    var painter: CanvasView

    init(painter: CanvasView) {
        self.painter = painter
    }

    func save() {
//        let tail =  states.count - 1 - currentIndex
//        if tail > 0 { states.removeLast(tail) }
//
//        states.append(painter.saveState())
//        currentIndex = states.count - 1
//        print("Save. \(painter.description)")

        states.append(painter.saveState())
        currentIndex += 1
        print("Save. \(currentIndex)")
    }

    func undo(steps: Int) {
//        guard steps <= currentIndex else { return }
//        currentIndex -= steps
//        painter.restore(state: states[currentIndex])
//        print("Undo \(steps) steps. \(painter.description)")
        
        if currentIndex <= 0 || states.isEmpty { return }
        currentIndex -= 1
        painter.restore(state: states[currentIndex])
        print("Undo. \(currentIndex)")
    }

    func redo(steps: Int) {
//        let newIndex = currentIndex + steps
//        guard newIndex < states.count - 1 else { return }
//        currentIndex = newIndex
//        painter.restore(state: states[currentIndex])
//        print("Redo \(steps) steps. \(painter.description)")
        
        if currentIndex == states.count - 1 { return }
        currentIndex += 1
        painter.restore(state: states[currentIndex])
        print("Redo. \(currentIndex)")
    }
}

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
        guard let first = touches.first?.location(in: self) else { return }
        let viewModel = ShapeViewModel(
            color: strokeColor,
            points: [(first, CGPoint())],
            type: shapeType,
            isFilled: isFilled
        )
        shapes.append(viewModel)
        caretaker.save()
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
