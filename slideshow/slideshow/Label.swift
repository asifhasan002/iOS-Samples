//
//  Labels.swift
//  slideshow

import UIKit

class Label {
    private let textLabel: UILabel = UILabel()
    private let texts = ["Great tit", "Bullfinch", "Dunnock", "Dove", "Mockingbird"]
    private let view: UIView

    init(view: UIView) {
        self.view = view
        setupLabel()
    }

    private func setupLabel() {
        textLabel.frame = CGRect(x: 50, y: 60, width: view.frame.width - 40, height: 50)
        textLabel.textAlignment = .left
        textLabel.font = UIFont.boldSystemFont(ofSize: 36)
        textLabel.text = texts[0]
        view.addSubview(textLabel)
    }

    func animateTextChange(index: Int, duration: Double) {
        UIView.transition(with: textLabel, duration: duration + 1.0, options: .transitionCrossDissolve, animations: {
            self.textLabel.text = self.texts[index]
        })
    }
}
