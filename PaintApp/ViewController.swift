//
//  ViewController.swift
//  PaintApp
//
//  Created by Olzhas Seiilkhanov on 14.06.2022.
//

import UIKit

class ViewController: UIViewController {

    private let colors: [UIColor] = [.blue, .purple, .red, .green, .yellow, .brown, .gray]
    
    private let circleButton = UIButton()
    private let triangleButton = UIButton()
    private let lineButton = UIButton()
    private let rectangleButton = UIButton()
    private let pencilButton = UIButton()
    private let fillLabel = UILabel()
    private let fillSwitch = UISwitch()
    private let undoButton = UIButton()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .white
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()

    private let colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 25, height: 40)
        layout.minimumLineSpacing = 1
    
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        return collection
    }()
    
    private let canvasView = CanvasView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
        configureCanvasView()
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case "circle": canvasView.shapeType = .circle
        case "rectangle": canvasView.shapeType = .rectangle
        case "line": canvasView.shapeType = .line
        case "triangle": canvasView.shapeType = .triangle
        case "pencil": canvasView.shapeType = .pencil
        case "undo": canvasView.undoDraw()
        default: return
        }
    }
    
    @objc private func longPress(gesture: UILongPressGestureRecognizer) {
        canvasView.clearCanvasView()
    }

    @objc private func switchChanged() {
        if fillSwitch.isOn {
            canvasView.isFilled = true
        }
        else {
            canvasView.isFilled = false
        }
    }
    
    private func configureCanvasView() {
        view.addSubview(canvasView)
        canvasView.backgroundColor = UIColor(named: "background")
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        canvasView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        canvasView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func configureStackView() {
        view.addSubview(stackView)
        setStackViewConstraints()
        
        configureCircleButton()
        configureRectangleButton()
        configureLineButton()
        configureTriangleButton()
        configurePencilButton()
        configureFillLabel()
        configureSwitch()
        configureColorsCollectionView()
        configureUndoButton()
    }
    
    private func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func configureSwitch() {
        stackView.addArrangedSubview(fillSwitch)
        fillSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
    }
    
    private func configureColorsCollectionView() {
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        
        colorsCollectionView.isScrollEnabled = false
        stackView.addArrangedSubview(colorsCollectionView)
        
        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorsCollectionView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        colorsCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func configureFillLabel() {
        stackView.addArrangedSubview(fillLabel)
        fillLabel.text = "Fill"
    }
    
    private func configureCircleButton() {
        stackView.addArrangedSubview(circleButton)
        circleButton.setImage(UIImage(named: "circle.png"), for: .normal)
        circleButton.translatesAutoresizingMaskIntoConstraints = false
        circleButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        circleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        circleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        circleButton.titleLabel?.text = "circle"
        circleButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func configureRectangleButton() {
        stackView.addArrangedSubview(rectangleButton)
        rectangleButton.setImage(UIImage(named: "rectangle.png"), for: .normal)
        rectangleButton.translatesAutoresizingMaskIntoConstraints = false
        rectangleButton.widthAnchor.constraint(equalTo: circleButton.widthAnchor).isActive = true
        rectangleButton.heightAnchor.constraint(equalTo: circleButton.heightAnchor).isActive = true
        rectangleButton.titleLabel?.text = "rectangle"
        rectangleButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func configureLineButton() {
        stackView.addArrangedSubview(lineButton)
        lineButton.setImage(UIImage(named: "line.png"), for: .normal)
        lineButton.translatesAutoresizingMaskIntoConstraints = false
        lineButton.widthAnchor.constraint(equalTo: circleButton.widthAnchor).isActive = true
        lineButton.heightAnchor.constraint(equalTo: circleButton.heightAnchor).isActive = true
        lineButton.titleLabel?.text = "line"
        lineButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func configureTriangleButton() {
        stackView.addArrangedSubview(triangleButton)
        triangleButton.setImage(UIImage(named: "triangle.png"), for: .normal)
        triangleButton.translatesAutoresizingMaskIntoConstraints = false
        triangleButton.widthAnchor.constraint(equalTo: circleButton.widthAnchor).isActive = true
        triangleButton.heightAnchor.constraint(equalTo: circleButton.heightAnchor).isActive = true
        triangleButton.titleLabel?.text = "triangle"
        triangleButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func configurePencilButton() {
        stackView.addArrangedSubview(pencilButton)
        pencilButton.setImage(UIImage(named: "pen.png"), for: .normal)
        pencilButton.translatesAutoresizingMaskIntoConstraints = false
        pencilButton.widthAnchor.constraint(equalTo: circleButton.widthAnchor).isActive = true
        pencilButton.heightAnchor.constraint(equalTo: circleButton.heightAnchor).isActive = true
        pencilButton.titleLabel?.text = "pencil"
        pencilButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func configureUndoButton() {
        stackView.addArrangedSubview(undoButton)
        undoButton.setImage(UIImage(named: "undo.png"), for: .normal)
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        undoButton.widthAnchor.constraint(equalTo: circleButton.widthAnchor).isActive = true
        undoButton.heightAnchor.constraint(equalTo: circleButton.heightAnchor).isActive = true
        undoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        undoButton.titleLabel?.text = "undo"
        undoButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(gesture:)))
        longPress.minimumPressDuration = 0.5
        undoButton.addGestureRecognizer(longPress)
    }
}

// MARK: - UICollectionView delegates

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath)
        cell.contentView.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        canvasView.strokeColor = colors[indexPath.row]
    }
}
