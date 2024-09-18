//
//  BirdShapeLayerSetup.swift
//  slideshow

import UIKit
import PocketSVG

class BirdShapeLayer {
    private var birdShapeLayer: CAShapeLayer!
    private let view: UIView
    private let birdData: ([SVGBezierPath], [UIColor])

    init(view: UIView, birdData: ([SVGBezierPath], [UIColor])) {
        self.view = view
        self.birdData = birdData
        setupBirdShapeLayer()
    }

    private func setupBirdShapeLayer() {
        birdShapeLayer = CAShapeLayer()
        let boundingBox = birdShapeLayer.path?.boundingBox ?? .zero
        birdShapeLayer.frame = CGRect(x: view.bounds.width / 4, y: 33, width: boundingBox.width, height: boundingBox.height)

        let transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        birdShapeLayer.setAffineTransform(transform)

        view.layer.addSublayer(birdShapeLayer)

        for (index, path) in birdData.0.enumerated() {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = birdData.1[index % birdData.1.count].cgColor
            birdShapeLayer.addSublayer(shapeLayer)
        }
    }

    func morph(from startData: ([SVGBezierPath], [UIColor]), to nextData: ([SVGBezierPath], [UIColor]), duration: Double, completion: @escaping () -> Void) {
        let startPaths = startData.0
        let endPaths = nextData.0
        let startColors = startData.1
        let endColors = nextData.1

        guard startPaths.count == endPaths.count else {
            print("The start and end paths arrays do not match in length.")
            return
        }

        guard let birdShapeLayer = birdShapeLayer else {
            print("birdShapeLayer is nil.")
            return
        }

        let sublayers = birdShapeLayer.sublayers ?? []

        for i in 0..<startPaths.count {
            let startPath = startPaths[i]
            let endPath = endPaths[i]
            
            let morphAnimation = CABasicAnimation(keyPath: "path")
            morphAnimation.fromValue = startPath.cgPath
            morphAnimation.toValue = endPath.cgPath
            morphAnimation.duration = duration
            morphAnimation.fillMode = .forwards
            morphAnimation.isRemovedOnCompletion = false

            let colorAnimation = CABasicAnimation(keyPath: "fillColor")
            colorAnimation.fromValue = startColors[i].cgColor
            colorAnimation.toValue = endColors[i].cgColor
            colorAnimation.duration = duration

            if i < sublayers.count {
                let shapeLayer = sublayers[i] as! CAShapeLayer
                shapeLayer.fillColor = endColors[i % endColors.count].cgColor
                shapeLayer.add(morphAnimation, forKey: "pathAnimation")
                shapeLayer.add(colorAnimation, forKey: "colorAnimation")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 3.0) {
            completion()
        }
    }
}
