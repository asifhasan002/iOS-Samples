//
//  ParticleEffectCell.swift
//  anim-test

import UIKit
import SpriteKit

class ParticleEffectCell: UICollectionViewCell {
    private var skView: SKView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSKView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeSKView() {
        skView = SKView(frame: contentView.bounds)
        skView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let skView = skView {
            contentView.addSubview(skView)
        }
    }
    
    func configure(with effect: ParticleEffect, wordColor: WordColorPair, index: Int) {
        skView?.scene?.removeAllActions()
        skView?.scene?.removeAllChildren()
        skView?.presentScene(nil)
        skView?.removeFromSuperview()
        
        initializeSKView()
        
        if let skView = skView {
            let scene = ParticleEffectScene(size: skView.bounds.size)
            scene.effect = effect
            scene.wordColor = wordColor
            scene.index = index
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }
}
