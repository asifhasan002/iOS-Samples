//
//  BirdsData.swift
//  slideshow

import UIKit
import PocketSVG

class BirdsData {
    var bird1Data: ([SVGBezierPath], [UIColor])?
    var bird2Data: ([SVGBezierPath], [UIColor])?
    var bird3Data: ([SVGBezierPath], [UIColor])?
    var bird4Data: ([SVGBezierPath], [UIColor])?
    var bird5Data: ([SVGBezierPath], [UIColor])?

    init() {
        setupBirdData()
    }

    private func setupBirdData() {
        bird1Data = SVGHelper.loadSVG(birdName: "bird1")
        bird2Data = SVGHelper.loadSVG(birdName: "bird2")
        bird3Data = SVGHelper.loadSVG(birdName: "bird3")
        bird4Data = SVGHelper.loadSVG(birdName: "bird4")
        bird5Data = SVGHelper.loadSVG(birdName: "bird5")
    }
}
