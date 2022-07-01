//
//  Memento.swift
//  PaintApp
//
//  Created by Olzhas Seiilkhanov on 29.06.2022.
//

import UIKit

// MARK: - Memento

protocol Memento {
    var shapes: [ShapeViewModel] { get }
}

class PainterMemento: Memento {
    var shapes: [ShapeViewModel]

    init(shapes: [ShapeViewModel]) {
        self.shapes = shapes
    }
}

// MARK: - Caretaker

class Caretaker {
    
    var states: [Memento] = []
    var currentIndex: Int = 0
    var painter: CanvasView

    init(painter: CanvasView) {
        self.painter = painter
    }

    func save() {
        let tail = states.count - 1 - currentIndex
        if tail > 0 { states.removeLast(tail) }
        states.append(painter.saveState())
        currentIndex = states.count - 1
        print("Save. \(painter.description)")
    }

    func undo(steps: Int) {
        guard steps <= currentIndex else { return }
        currentIndex -= steps
        painter.restore(state: states[currentIndex])
        print("Undo \(steps) steps. \(painter.description)")
    }

    func redo(steps: Int) {
        let newIndex = currentIndex + steps
        guard newIndex < states.count else { return }
        currentIndex = newIndex
        painter.restore(state: states[currentIndex])
        print("Redo \(steps) steps. \(painter.description)")
    }
}
