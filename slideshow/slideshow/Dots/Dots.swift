//
//  Dots.swift
//  slideshow

import UIKit

class Dots {
    private var dots: [UIView] = []
    private let numberOfDots = 5
    private let dotSize: CGFloat = 10.0
    private let coloredDotSize: CGFloat = 15.0
    private let dotSpacing: CGFloat = 15.0
    private let dotYPosition: CGFloat = 370.0
    private let dotColors = DotColors.colors
    private let view: UIView
    
    init(view: UIView) {
        self.view = view
        setupDots()
    }

    private func setupDots() {
        let startX: CGFloat = 753
        for i in 0..<numberOfDots {
            let currentDotSize = i == 0 ? coloredDotSize : dotSize
            let dot = UIView(frame: CGRect(x: startX + CGFloat(i) * (currentDotSize + dotSpacing), y: dotYPosition - currentDotSize / 2, width: currentDotSize, height: currentDotSize))
            dot.backgroundColor = i == 0 ? dotColors[0] : .gray
            dot.layer.cornerRadius = i == 0 ? 0 : currentDotSize / 2
            view.addSubview(dot)
            dots.append(dot)
        }
    }

    func animateDotChange(index: Int, duration: Double) {
        UIView.animate(withDuration: duration + 0.5, animations: {
            self.dots.forEach { dot in
                dot.backgroundColor = .gray
                dot.layer.cornerRadius = self.dotSize / 2
                dot.frame.size = CGSize(width: self.dotSize, height: self.dotSize)
                dot.frame.origin.y = self.dotYPosition - self.dotSize / 2
            }

            let selectedDot = self.dots[index]
            selectedDot.backgroundColor = self.dotColors[index]
            selectedDot.layer.cornerRadius = 0 // Square shape
            selectedDot.frame.size = CGSize(width: self.coloredDotSize, height: self.coloredDotSize)
            selectedDot.frame.origin.y = self.dotYPosition - self.coloredDotSize / 2
        })
    }
}
