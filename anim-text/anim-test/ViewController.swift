//
//  ViewController.swift
//  anim-test
//
//  Created by rootnext05 on 11/9/24.
//

import UIKit
//import CoreGraphics
import SpriteKit
//import GameplayKit


extension UIColor {
    func brighten(by percentage: CGFloat) -> UIColor {
        // Clamp percentage between 0 and 1
        let clampedPercentage = max(0, min(percentage, 1))
        
        // Extract current color components
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Calculate new color components
        let newRed = red + (1 - red) * clampedPercentage
        let newGreen = green + (1 - green) * clampedPercentage
        let newBlue = blue + (1 - blue) * clampedPercentage
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
    }
}

enum ParticleEffect: Int, CaseIterable {
    case fireflies0, fireflies1, fireflies2, bokeh1, bokeh2, fire, magic, rain, smoke, snow, spark, spark0
    
    var particleSettings: (name: String, birthRate: CGFloat, size: CGSize) {
        switch self {
        case .fireflies0:
            return (name: "fireflies", birthRate: 5000, size: CGSize(width: 20, height: 20))
        case .fireflies1:
            return (name: "fireflies", birthRate: 5000, size: CGSize(width: 20, height: 20))
        case .fireflies2:
            return (name: "fireflies", birthRate: 700, size: CGSize(width: 500, height: 5))
        case .bokeh1:
            return (name: "bokeh", birthRate: 500, size: CGSize(width: 500, height: 5))
        case .bokeh2:
            return (name: "bokeh", birthRate: 5000, size: CGSize(width: 5, height: 5))
        case .fire:
            return (name: "fire", birthRate: 0, size: CGSize(width: 20, height: 20))
        case .magic:
            return (name: "magic", birthRate: 10000, size: CGSize(width: 20, height: 5))
        case .rain:
            return (name: "rain", birthRate: 3000, size: CGSize(width: 10, height: 4000))
        case .smoke:
            return (name: "smoke", birthRate: 100, size: CGSize(width: 50, height: 5))
        case .snow:
            return (name: "snow", birthRate: 1000, size: CGSize(width: 10, height: 1300))
        case .spark:
            return (name: "spark", birthRate: 0, size: CGSize(width: 35, height: 35))
        case .spark0:
            return (name: "spark", birthRate: 0, size: CGSize(width: 35, height: 35))
        }
    }
}


class ParticleEffectScene: SKScene {
    var effect: ParticleEffect = .fireflies1
    var wordColor: WordColorPair = .word2
    var index: Int = 0
    
    override func didMove(to view: SKView) {
        print(index)
    
        if index == 0 {
            addNodes2(texts: "MASK", wordColor: [.word1, .word3, .word2, .word4], effect: [.fireflies1, .bokeh1, .fireflies2, .bokeh2])
        }else if index == 11 {
           addNodes2(texts: "MASK", wordColor: [.word5, .word6, .word8, .word9], effect: [.fire, .magic, .smoke, .snow])
        } else {
            addNodes(wordColor: wordColor, effect: effect)
        }
    }
    
    func addNodes2(texts: String, wordColor: [WordColorPair], effect: [ParticleEffect]) {
        backgroundColor = .black
        let fontSize: CGFloat = 100
        let spacing: CGFloat = 80
        let totalWidth: CGFloat = CGFloat(texts.count - 1) * spacing + fontSize

        let startX = frame.midX - totalWidth / 2 + fontSize / 2

        for i in 0..<texts.count {
            let index = texts.index(texts.startIndex, offsetBy: i)
            let character = texts[index]
            
            let cropNode = SKCropNode()
            cropNode.position = CGPoint(x: startX + CGFloat(i) * spacing, y: frame.midY)
            cropNode.zPosition = 1

            let mask = SKLabelNode(fontNamed: "ArialMT")
            mask.text = String(character)
            mask.fontColor = .green
            mask.fontSize = fontSize

            cropNode.maskNode = mask
            
            let nodeToMask = SKEmitterNode(fileNamed: effect[i].particleSettings.name)!
            
            if effect[i] != .fire && effect[i] != .spark {
                nodeToMask.particleBirthRate = effect[i].particleSettings.birthRate
                nodeToMask.numParticlesToEmit = 0
            }
            
            nodeToMask.particleLifetime = 10
            nodeToMask.particleAlpha = 1.0
            
            nodeToMask.particleColor = wordColor[i].wordAndColor.color
            nodeToMask.particleColorBlendFactor = 1.0
            nodeToMask.particleSize = CGSize(width: effect[i].particleSettings.size.width, height: effect[i].particleSettings.size.height)
            
            nodeToMask.position = CGPoint(x: 0, y: 0)
            nodeToMask.name = "character"
            
            cropNode.addChild(nodeToMask)
            addChild(cropNode)
        }
    }
    
    
    func addNodes(wordColor: WordColorPair, effect: ParticleEffect) {
        backgroundColor = .black
        let texts = wordColor.wordAndColor.word
        let fontSize: CGFloat = 100
        let spacing: CGFloat = 80
        let totalWidth: CGFloat = CGFloat(texts.count - 1) * spacing + fontSize

        let startX = frame.midX - totalWidth / 2 + fontSize / 2

        for i in 0..<texts.count {
            let index = texts.index(texts.startIndex, offsetBy: i)
            let character = texts[index]
            
            let cropNode = SKCropNode()
            cropNode.position = CGPoint(x: startX + CGFloat(i) * spacing, y: frame.midY)
            cropNode.zPosition = 1

            let mask = SKLabelNode(fontNamed: "ArialMT")
            mask.text = String(character)
            mask.fontColor = .green
            mask.fontSize = fontSize

            cropNode.maskNode = mask
            
            let nodeToMask = SKEmitterNode(fileNamed: effect.particleSettings.name)!
            
            if effect != .fire && effect != .spark {
                nodeToMask.particleBirthRate = effect.particleSettings.birthRate
                nodeToMask.numParticlesToEmit = 0
            }
            
            nodeToMask.particleLifetime = 10
            nodeToMask.particleAlpha = 1.0
            
            nodeToMask.particleColor = wordColor.wordAndColor.color
            nodeToMask.particleColorBlendFactor = 1.0
            nodeToMask.particleSize = CGSize(width: effect.particleSettings.size.width, height: effect.particleSettings.size.height)
            
            nodeToMask.position = CGPoint(x: 0, y: 0)
            nodeToMask.name = "character"
            
            cropNode.addChild(nodeToMask)
            addChild(cropNode)
        }
    }
}

enum WordColorPair: Int, CaseIterable {
    case word0, word1, word2, word3, word4, word5, word6, word7, word8, word9, word10, word11
    
    var wordAndColor: (word: String, color: UIColor) {
        switch self {
        case .word0:
            return ("PLAY", UIColor.orange)
        case .word1:
            return ("PLAY", UIColor.orange)
        case .word2:
            return ("PUSH", UIColor.green)
        case .word3:
            return ("KITE", UIColor.yellow)
        case .word4:
            return ("MAKE", UIColor.red)
        case .word5:
            return ("FIRE", UIColor(red: 1.0, green: 0.3, blue: 0.0, alpha: 1.0))
        case .word6:
            return ("MINT", UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0))
        case .word7:
            return ("BOLD", UIColor.blue.brighten(by: 0.3))
        case .word8:
            return ("GLOW", UIColor.magenta)
        case .word9:
            return ("WAVE", UIColor.magenta)
        case .word10:
            return ("FIZZ", UIColor.brown)
        case .word11:
            return ("FIZZ", UIColor.brown)
        }
    }
}


class ParticleEffectCell: UICollectionViewCell {
    var skView: SKView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Initialize the SKView
        initializeSKView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeSKView() {
        // Initialize and configure the SKView
        skView = SKView(frame: contentView.bounds)
        skView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let skView = skView {
            contentView.addSubview(skView)
        }
    }
    
    func configure(with effect: ParticleEffect, wordColor: WordColorPair, index: Int) {
        // Clear existing SKView if necessary
        if let skView = skView {
            skView.scene?.removeAllActions()
            skView.scene?.removeAllChildren()
            skView.presentScene(nil) // Ensure previous scene is completely removed
            skView.removeFromSuperview()
        }
        
        // Initialize and configure the SKView
        initializeSKView()
        
        // Configure and present a new scene
        if let skView = skView {
            let scene = ParticleEffectScene(size: skView.bounds.size)
            scene.effect = effect
            scene.wordColor = wordColor
            scene.index = index
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
//            skView.showsFPS = true
//            skView.showsNodeCount = true
        }
    }
}


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        collectionView.register(ParticleEffectCell.self, forCellWithReuseIdentifier: "ParticleEffectCell")
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ParticleEffect.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticleEffectCell", for: indexPath) as! ParticleEffectCell
        
        let effect = ParticleEffect(rawValue: indexPath.item)!
        let wordColor = WordColorPair(rawValue: indexPath.item)!
        
        cell.configure(with: effect, wordColor: wordColor, index: indexPath.row)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}


//class ParticleEffectCell: UICollectionViewCell {
//    private var skView: SKView!
//    let scene = ParticleEffectScene()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        skView = SKView(frame: contentView.bounds)
//        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        contentView.addSubview(skView)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func configure(with effect: ParticleEffect, wordColor: WordColorPair) {
//        skView.presentScene(nil)
//        let scene = ParticleEffectScene(size: skView.bounds.size)
//        scene.effect = effect
//        scene.wordColor = wordColor
//        scene.scaleMode = .aspectFill
//
//        skView.presentScene(scene)
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//    }
//}


//enum ParticleEffect {
//    case fireflies1
//    case fireflies2
//    case bokeh1
//    case bokeh2
//    case fire
//    case magic
//    case rain
//    case smoke
//    case snow
//    case spark
//
//    var particleSettings: (name: String, birthRate: CGFloat, size: CGSize) {
//        switch self {
//        case .fireflies1:
//            return (name: "fireflies", birthRate: 5000, size: CGSize(width: 20, height: 20))
//        case .fireflies2:
//            return (name: "fireflies", birthRate: 700, size: CGSize(width: 500, height: 5))
//        case .bokeh1:
//            return (name: "bokeh", birthRate: 500, size: CGSize(width: 500, height: 5))
//        case .bokeh2:
//            return (name: "bokeh", birthRate: 5000, size: CGSize(width: 5, height: 5))
//        case .fire:
//            return (name: "fire", birthRate: 0, size: CGSize(width: 20, height: 20)) 
//        case .magic:
//            return (name: "magic", birthRate: 10000, size: CGSize(width: 20, height: 5))
//        case .rain:
//            return (name: "rain", birthRate: 3000, size: CGSize(width: 10, height: 4000))
//        case .smoke:
//            return (name: "smoke", birthRate: 100, size: CGSize(width: 50, height: 5))
//        case .snow:
//            return (name: "snow", birthRate: 1000, size: CGSize(width: 10, height: 1300))
//        case .spark:
//            return (name: "spark", birthRate: 0, size: CGSize(width: 35, height: 35))
//        }
//    }
//}
//
//extension UIColor {
//    
//    // Generates a random color
//    static func random() -> UIColor {
//        let red = CGFloat(arc4random_uniform(256)) / 255.0
//        let green = CGFloat(arc4random_uniform(256)) / 255.0
//        let blue = CGFloat(arc4random_uniform(256)) / 255.0
//        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
//    }
//}
//
//class GameScene: SKScene {
//    override func didMove(to view: SKView) {
//        
//        addNodes(texts: "MASK", effect: .fireflies1)
//    }
//    
//    func addNodes(texts: String, effect: ParticleEffect) {
//        backgroundColor = .black
//        
//        let fontSize: CGFloat = 100
//        let spacing: CGFloat = 80
//        let totalWidth: CGFloat = CGFloat(texts.count - 1) * spacing + fontSize // Total width calculation
//
//        // Center position
//        let startX = frame.midX - totalWidth / 2 + fontSize / 2
//
//        for i in 0..<texts.count {
//            let index = texts.index(texts.startIndex, offsetBy: i)
//            let character = texts[index]
//            
//            let cropNode = SKCropNode()
//            cropNode.position = CGPoint(x: startX + CGFloat(i) * spacing, y: frame.midY)
//            cropNode.zPosition = 1
//
//            let mask = SKLabelNode(fontNamed: "ArialMT")
//            mask.text = String(character)
//            mask.fontColor = .green
//            mask.fontSize = fontSize
//
//            cropNode.maskNode = mask
//            
//            // Create a new SKEmitterNode for each character
//            let nodeToMask = SKEmitterNode(fileNamed: effect.particleSettings.name)!
//            
//            if effect != .fire && effect != .spark {
//                nodeToMask.particleBirthRate = effect.particleSettings.birthRate
//                nodeToMask.numParticlesToEmit = 0
//            }
//            
//            nodeToMask.particleLifetime = 10
//            nodeToMask.particleAlpha = 1.0
//            
//            
//            nodeToMask.particleColor = UIColor.red
//            nodeToMask.particleColorBlendFactor = 1.0
//            nodeToMask.particleSize = CGSize(width: effect.particleSettings.size.width, height: effect.particleSettings.size.height)
//            
//            nodeToMask.position = CGPoint(x: 0, y: 0)
//            nodeToMask.name = "character"
//            
//            cropNode.addChild(nodeToMask)
//            addChild(cropNode)
//        }
//    }
//}
//
//class ViewController: UIViewController {
//    var skView: SKView!
//        
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Create and configure the SKView
//        skView = SKView(frame: self.view.bounds)
//        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.view.addSubview(skView)
//        
//        // Create the GameScene and set its size
//        let gameScene = GameScene(size: skView.bounds.size)
//        
//        // Configure the scene
//        gameScene.scaleMode = .aspectFill
//        
//        // Present the scene
//        skView.presentScene(gameScene)
//        
//        // Optional: Configure SKView settings for debugging
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//    }
//}







//class GameScene: SKScene {
//    override func didMove(to view: SKView) {
//        
//        if let nodeToMask = SKEmitterNode(fileNamed: "smoke") {
//            
//            addNode(texts: "MASK", nodeToMask: nodeToMask)
//            
////            backgroundColor = .black
////            let cropNode = SKCropNode()
////            cropNode.position = CGPoint(x: frame.midX, y: frame.midY)
////            cropNode.zPosition = 1
////
////            let mask = SKLabelNode(fontNamed: "ArialMT")
////            mask.text = "MASK"
////            mask.fontColor = .green
////            mask.fontSize = 100
////
////            cropNode.maskNode = mask
////
////            
////            nodeToMask.particleBirthRate = 10
////            nodeToMask.numParticlesToEmit = 0
////            nodeToMask.particleLifetime = 10
////            nodeToMask.particleAlpha = 1.0
////            
////           // nodeToMask.particleSpeed = 30
////            
////            // Adjust particle color
////               nodeToMask.particleColor = UIColor.red
////               nodeToMask.particleColorBlendFactor = 1.0 // Fully apply the color
////
////               // Adjust particle size
////               nodeToMask.particleSize = CGSize(width: 500, height: 5) // Set the base size of the particles
////
////               // Example of creating a glow effect using multiple emitters or nodes
////               
////               // Add the emitter nodes to the scene
////               nodeToMask.position = CGPoint(x: 0, y: 0)
////               nodeToMask.name = "character"
////            
////            
////            
////            
////            cropNode.addChild(nodeToMask)
////
////            addChild(cropNode)
//        }
//    }
    
    

//class GameScene: SKScene {
//    
//    let CANVAS_WIDTH: CGFloat = 500
//    let CANVAS_HEIGHT: CGFloat = 500
//    let RESOLUTION: CGFloat = 10
//    let PEN_SIZE: CGFloat = 40
//    let SPECK_COUNT = 5000
//    
//    var vecCells: [[Cell]] = []
//    var particles: [Particle] = []
//    var mouseDown = false
//    var mouseX: CGFloat = 0
//    var mouseY: CGFloat = 0
//    var mousePX: CGFloat = 0
//    var mousePY: CGFloat = 0
//    
//    override func didMove(to view: SKView) {
//        self.size = CGSize(width: CANVAS_WIDTH, height: CANVAS_HEIGHT)
//        
//        let numCols = Int(CANVAS_WIDTH / RESOLUTION)
//        let numRows = Int(CANVAS_HEIGHT / RESOLUTION)
//        vecCells = createCells(numCols: numCols, numRows: numRows)
//        setupCells(numCols: numCols, numRows: numRows)
//        
//        particles = (0..<SPECK_COUNT).map { _ in
//            Particle(x: CGFloat.random(in: 0..<CANVAS_WIDTH), y: CGFloat.random(in: 0..<CANVAS_HEIGHT))
//        }
//        
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        view.addGestureRecognizer(panGestureRecognizer)
//    }
//    
//    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
//        let location = sender.location(in: self.view)
//        mouseX = location.x
//        mouseY = CANVAS_HEIGHT - location.y // Flip Y axis for SpriteKit
//        mouseDown = sender.state == .began || sender.state == .changed
//    }
//    
//    override func update(_ currentTime: TimeInterval) {
//        let mouseXV = mouseX - mousePX
//        let mouseYV = mouseY - mousePY
//        
//        if mouseDown {
//            for cellRow in vecCells {
//                for cell in cellRow {
//                    changeCellVelocity(cell: cell, mvelX: mouseXV, mvelY: mouseYV, penSize: PEN_SIZE)
//                }
//            }
//        }
//        
//        for cellRow in vecCells {
//            for cell in cellRow {
//                updatePressure(cell: cell)
//            }
//        }
//        
//        updateParticles()
//        
//        for cellRow in vecCells {
//            for cell in cellRow {
//                updateVelocity(cell: cell)
//            }
//        }
//        
//        mousePX = mouseX
//        mousePY = mouseY
//    }
//    
//    func createCells(numCols: Int, numRows: Int) -> [[Cell]] {
//        var cells = [[Cell]]()
//        for col in 0..<numCols {
//            var rowCells = [Cell]()
//            for row in 0..<numRows {
//                let cell = Cell(x: CGFloat(col) * RESOLUTION, y: CGFloat(row) * RESOLUTION, res: RESOLUTION)
//                rowCells.append(cell)
//            }
//            cells.append(rowCells)
//        }
//        return cells
//    }
//    
//    func setupCells(numCols: Int, numRows: Int) {
//        for col in 0..<numCols {
//            for row in 0..<numRows {
//                let cell = vecCells[col][row]
//                
//                let rowUp = (row - 1) >= 0 ? row - 1 : numRows - 1
//                let colLeft = (col - 1) >= 0 ? col - 1 : numCols - 1
//                let colRight = (col + 1) < numCols ? col + 1 : 0
//                
//                let up = vecCells[col][rowUp]
//                let left = vecCells[colLeft][row]
//                let upLeft = vecCells[colLeft][rowUp]
//                let upRight = vecCells[colRight][rowUp]
//                
//                cell.up = up
//                cell.left = left
//                cell.upLeft = upLeft
//                cell.upRight = upRight
//                
//                up.down = cell
//                left.right = cell
//                upLeft.downRight = cell
//                upRight.downLeft = cell
//            }
//        }
//    }
//    
//    func updateParticles() {
//        for p in particles {
//            if p.x >= 0 && p.x < CANVAS_WIDTH && p.y >= 0 && p.y < CANVAS_HEIGHT {
//                let col = Int(p.x / RESOLUTION)
//                let row = Int(p.y / RESOLUTION)
//                let cell = vecCells[col][row]
//                
//                let ax = (p.x.truncatingRemainder(dividingBy: RESOLUTION)) / RESOLUTION
//                let ay = (p.y.truncatingRemainder(dividingBy: RESOLUTION)) / RESOLUTION
//                
//                p.xv += (1 - ax) * cell.xv * 0.05
//                p.yv += (1 - ay) * cell.yv * 0.05
//                p.xv += ax * cell.right!.xv ?? 0 * 0.05
//                p.yv += ax * cell.right!.yv ?? 0 * 0.05
//                p.xv += ay * cell.down!.xv ?? 0 * 0.05
//                p.yv += ay * cell.down!.yv ?? 0 * 0.05
//                
//                p.x += p.xv
//                p.y += p.yv
//                
//                let dx = p.px - p.x
//                let dy = p.py - p.y
//                let dist = sqrt(dx * dx + dy * dy)
//                let limit = CGFloat.random(in: 0..<0.5)
//                
//                let line = SKShapeNode()
//                let path = UIBezierPath()
//                path.move(to: CGPoint(x: p.x, y: p.y))
//                if dist > limit {
//                    path.addLine(to: CGPoint(x: p.px, y: p.py))
//                } else {
//                    path.addLine(to: CGPoint(x: p.x + limit, y: p.y + limit))
//                }
//                line.path = path.cgPath
//                line.strokeColor = SKColor.cyan
//                line.lineWidth = 1
//                self.addChild(line)
//                
//                p.px = p.x
//                p.py = p.y
//            } else {
//                p.x = CGFloat.random(in: 0..<CANVAS_WIDTH)
//                p.y = CGFloat.random(in: 0..<CANVAS_HEIGHT)
//                p.px = p.x
//                p.py = p.y
//                p.xv = 0
//                p.yv = 0
//            }
//            
//            p.xv *= 0.5
//            p.yv *= 0.5
//        }
//    }
//    
//    func updatePressure(cell: Cell) {
//        let pressureX = (
//            (cell.upLeft?.xv ?? 0) * 0.5
//            + (cell.left?.xv ?? 0)
//            + (cell.downLeft?.xv ?? 0) * 0.5
//            - (cell.upRight?.xv ?? 0) * 0.5
//            - (cell.right?.xv ?? 0)
//            - (cell.downRight?.xv ?? 0) * 0.5
//        )
//        
//        let pressureY = (
//            (cell.upLeft?.yv ?? 0) * 0.5
//            + (cell.up?.yv ?? 0)
//            + (cell.upRight?.yv ?? 0) * 0.5
//            - (cell.downLeft?.yv ?? 0) * 0.5
//            - (cell.down?.yv ?? 0)
//            - (cell.downRight?.yv ?? 0) * 0.5
//        )
//        
//        cell.pressure = (pressureX + pressureY) * 0.25
//    }
//    
//    func updateVelocity(cell: Cell) {
//        cell.xv += (
//            (cell.upLeft?.pressure ?? 0) * 0.5
//            + (cell.left?.pressure ?? 0)
//            + (cell.downLeft?.pressure ?? 0) * 0.5
//            - (cell.upRight?.pressure ?? 0) * 0.5
//            - (cell.right?.pressure ?? 0)
//            - (cell.downRight?.pressure ?? 0) * 0.5
//        ) * 0.25
//        
//        cell.yv += (
//            (cell.upLeft?.pressure ?? 0) * 0.5
//            + (cell.up?.pressure ?? 0)
//            + (cell.upRight?.pressure ?? 0) * 0.5
//            - (cell.downLeft?.pressure ?? 0) * 0.5
//            - (cell.down?.pressure ?? 0)
//            - (cell.downRight?.pressure ?? 0) * 0.5
//        ) * 0.25
//        
//        cell.xv *= 0.99
//        cell.yv *= 0.99
//    }
//    
//    func changeCellVelocity(cell: Cell, mvelX: CGFloat, mvelY: CGFloat, penSize: CGFloat) {
//        let dx = cell.x - mouseX
//        let dy = cell.y - mouseY
//        let dist = sqrt(dy * dy + dx * dx)
//        
//        if dist < penSize {
//            let power = dist < 4 ? penSize : penSize / dist
//            cell.xv += mvelX * power
//            cell.yv += mvelY * power
//        }
//    }
//    
//}
//
//class Cell {
//    var x: CGFloat
//    var y: CGFloat
//    var r: CGFloat
//    var col: CGFloat = 0
//    var row: CGFloat = 0
//    var xv: CGFloat = 0
//    var yv: CGFloat = 0
//    var pressure: CGFloat = 0
//    var up: Cell?
//    var left: Cell?
//    var upLeft: Cell?
//    var upRight: Cell?
//    var down: Cell?
//    var right: Cell?
//    var downLeft: Cell?
//    var downRight: Cell?
//    
//    init(x: CGFloat, y: CGFloat, res: CGFloat) {
//        self.x = x
//        self.y = y
//        self.r = res
//    }
//}
//
//class Particle {
//    var x: CGFloat
//    var y: CGFloat
//    var px: CGFloat
//    var py: CGFloat
//    var xv: CGFloat = 0
//    var yv: CGFloat = 0
//    
//    init(x: CGFloat, y: CGFloat) {
//        self.x = x
//        self.y = y
//        self.px = x
//        self.py = y
//    }
//}


//class ViewController: UIViewController {
//    var skView: SKView!
//        
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Create and configure the SKView
//        skView = SKView(frame: self.view.bounds)
//        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.view.addSubview(skView)
//        
//        // Create the GameScene and set its size
//        let gameScene = GameScene(size: skView.bounds.size)
//        
//        // Configure the scene
//        gameScene.scaleMode = .aspectFill
//        
//        // Present the scene
//        skView.presentScene(gameScene)
//        
//        // Optional: Configure SKView settings for debugging
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//    }
//
//}

//struct Mouse {
//    var x: CGFloat = 0
//    var y: CGFloat = 0
//    var px: CGFloat = 0
//    var py: CGFloat = 0
//    var down: Bool = false
//}
//
//class ViewController: UIViewController {
//    
//    // Define a struct to represent the mouse state
//    
//
//    // Set up the canvas dimensions and properties
//    let canvasWidth: CGFloat = 500 // Needs to be a multiple of the resolution value below.
//    let canvasHeight: CGFloat = 500 // This too.
//    let resolution: CGFloat = 10 // Width and height of each cell in the grid.
//    let penSize: CGFloat = 40 // Radius around the mouse cursor coordinates to reach when stirring
//
//    // Calculate number of columns and rows
//    var numCols: Int = 0 // This value is the number of columns in the grid.
//    var numRows: Int = 0 // This is number of rows.
//    let speckCount: Int = 5000 // This determines how many particles will be made.
//
//    // Arrays to hold the grid cells and particles
//    var vecCells: [[Cell]] = [] // Define `Cell` as needed, here we assume a placeholder
//    var particles: [Particle] = []
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let numCols: Int = Int(canvasWidth / resolution)
//        let numRows: Int = Int(canvasHeight / resolution)
//        
//        let canvas = UIView(frame: CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight))
//
//        // Add the canvas to your view hierarchy
//        self.view.addSubview(canvas)
//
//        // Create a graphics context for drawing
//        UIGraphicsBeginImageContext(canvas.bounds.size)
//        guard let context = UIGraphicsGetCurrentContext() else {
//            // Handle error if needed
//            return
//        }
//
//        // You can now use `context` to perform drawing operations
//        // For example, setting the fill color
//        context.setFillColor(UIColor.red.cgColor)
//        context.fill(canvas.bounds)
//
//        // Finish image context
//        UIGraphicsEndImageContext()
//        
//        for _ in 0..<speckCount {
//            let randomX = CGFloat.random(in: 0..<canvasWidth)
//            let randomY = CGFloat.random(in: 0..<canvasHeight)
//            let particle = Particle(x: randomX, y: randomY)
//            particles.append(particle)
//        }
//        
//        for col in 0..<numCols {
//            vecCells[col] = Array(repeating: Cell(x: 0, y: 0, size: resolution, col: col, row: 0), count: numRows)
//
//            for row in 0..<numRows {
//                let cellData = Cell(x: CGFloat(col) * resolution, y: CGFloat(row) * resolution, size: resolution, col: col, row: row)
//                vecCells[col][row] = cellData
//            }
//        }
//
//        // Set adjacent cells
//        for col in 0..<numCols {
//            for row in 0..<numRows {
//                let cellData = vecCells[col][row]
//                
//                let rowUp = (row - 1 >= 0) ? row - 1 : numRows - 1
//                let colLeft = (col - 1 >= 0) ? col - 1 : numCols - 1
//                let colRight = (col + 1 < numCols) ? col + 1 : 0
//                
//                let up = vecCells[col][rowUp]
//                let left = vecCells[colLeft][row]
//                let upLeft = vecCells[colLeft][rowUp]
//                let upRight = vecCells[colRight][rowUp]
//                
//                cellData.up = up
//                cellData.left = left
//                cellData.upLeft = upLeft
//                cellData.upRight = upRight
//                
//                up.down = cellData
//                left.right = cellData
//                upLeft.downRight = cellData
//                upRight.downLeft = cellData
//            }
//        }
//
//        let mouseDownRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(mouseDownHandler(_:)))
//               canvas.addGestureRecognizer(mouseDownRecognizer)
//
//               let touchStartRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchStartHandler(_:)))
//               canvas.addGestureRecognizer(touchStartRecognizer)
//
//               let mouseUpRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(mouseUpHandler(_:)))
//               canvas.addGestureRecognizer(mouseUpRecognizer)
//
//               let touchEndRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchEndHandler(_:)))
//               canvas.addGestureRecognizer(touchEndRecognizer)
//
//               let mouseMoveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(mouseMoveHandler(_:)))
//               canvas.addGestureRecognizer(mouseMoveRecognizer)
//
//               let touchMoveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(touchMoveHandler(_:)))
//               canvas.addGestureRecognizer(touchMoveRecognizer)
//        
//        draw()
//        
//        setupGestureRecognizers()
//    }
//    
//    func updateParticle() {
//        for p in particles {
//            // Check if the particle's coordinates are within bounds
//            if p.x >= 0 && p.x < canvasWidth && p.y >= 0 && p.y < canvasHeight {
//                let col = Int(p.x / resolution)
//                let row = Int(p.y / resolution)
//                
//                let cellData = vecCells[col][row]
//                
//                let ax = (p.x.truncatingRemainder(dividingBy: resolution)) / resolution
//                let ay = (p.y.truncatingRemainder(dividingBy: resolution)) / resolution
//                
//                p.xv += (1 - ax) * cellData.xv * 0.05
//                p.yv += (1 - ay) * cellData.yv * 0.05
//                
//                p.xv += ax * cellData.right.xv * 0.05
//                p.yv += ax * cellData.right.yv * 0.05
//                
//                p.xv += ay * cellData.down.xv * 0.05
//                p.yv += ay * cellData.down.yv * 0.05
//                
//                // Update position based on velocity
//                p.x += p.xv
//                p.y += p.yv
//                
//                let dx = p.px - p.x
//                let dy = p.py - p.y
//                let dist = sqrt(dx * dx + dy * dy)
//                
//                let limit = CGFloat.random(in: 0...0.5)
//                
//                // Drawing on the canvas (using a UIView subclass)
//                if let context = UIGraphicsGetCurrentContext() {
//                    context.setLineWidth(1.0)
//                    context.beginPath()
//                    context.move(to: CGPoint(x: p.x, y: p.y))
//                    
//                    if dist > limit {
//                        context.addLine(to: CGPoint(x: p.px, y: p.py))
//                    } else {
//                        context.addLine(to: CGPoint(x: p.x + limit, y: p.y + limit))
//                    }
//                    
//                    context.strokePath()
//                }
//                
//                // Update previous position
//                p.px = p.x
//                p.py = p.y
//            } else {
//                // If out of bounds, reset particle
//                p.x = CGFloat.random(in: 0...canvasWidth)
//                p.y = CGFloat.random(in: 0...canvasHeight)
//                p.px = p.x
//                p.py = p.y
//                p.xv = 0
//                p.yv = 0
//            }
//            
//            // Slow down the particle over time
//            p.xv *= 0.5
//            p.yv *= 0.5
//        }
//    }
//
//    
//    func draw() {
//        var mouse_xv = mouse.x - mouse.px;
//        var mouse_yv = mouse.y - mouse.py;
//
//        // Loops through all of the columns
//        for (i = 0; i < vec_cells.length; i++) {
//            var cell_datas = vec_cells[i];
//
//            // Loops through all of the rows
//            for (j = 0; j < cell_datas.length; j++) {
//                var cell_data = cell_datas[j];
//
//                // If the mouse button is down, update the cell velocity using the mouse velocity
//                if (mouse.down) {
//                    change_cell_velocity(cell_data, mouse_xv, mouse_yv, pen_size);
//                }
//
//                // This updates the pressure values for the cell
//                update_pressure(cell_data);
//            }
//        }
//
//        ctx.clearRect(0, 0, canvas.width, canvas.height);
//
//        // This sets the color to draw with
//        ctx.strokeStyle = "#00FFFF";
//
//        // This calls the function to update the particle positions
//        update_particle();
//
//        for (i = 0; i < vec_cells.length; i++) {
//            var cell_datas = vec_cells[i];
//
//            for (j = 0; j < cell_datas.length; j++) {
//                var cell_data = cell_datas[j];
//
//                update_velocity(cell_data);
//            }
//        }
//
//        // This replaces the previous mouse coordinates values with the current ones for the next frame
//        mouse.px = mouse.x;
//        mouse.py = mouse.y;
//
//        // This requests the next animation frame which runs the draw() function again
//        requestAnimationFrame(draw);
//    }
//
//    func changeCellVelocity(cellData: Cell, mvelX: CGFloat, mvelY: CGFloat, penSize: CGFloat) {
//        // Calculate the distance between the cell and the mouse cursor
//        let dx = cellData.x - mouse.x
//        let dy = cellData.y - mouse.y
//        var dist = sqrt(dy * dy + dx * dx)
//        
//        // If the distance is less than the radius
//        if dist < penSize {
//            
//            // If the distance is very small, set it to the penSize
//            if dist < 4 {
//                dist = penSize
//            }
//            
//            // Calculate the magnitude of the mouse's effect (closer is stronger)
//            let power = penSize / dist
//            
//            // Apply the velocity to the cell by multiplying the power by the mouse velocity and adding it to the cell velocity
//            cellData.xv += mvelX * power
//            cellData.yv += mvelY * power
//        }
//    }
//
//    func updatePressure(cellData: Cell) {
//        // Calculate the collective pressure on the X axis by summing the surrounding velocities
//        let pressureX = (
//            (cellData.upLeft?.xv ?? 0) * 0.5 // Divided in half because it's diagonal
//            + (cellData.left?.xv ?? 0)
//            + (cellData.downLeft?.xv ?? 0) * 0.5 // Same
//            - (cellData.upRight?.xv ?? 0) * 0.5 // Same
//            - (cellData.right?.xv ?? 0)
//            - (cellData.downRight?.xv ?? 0) * 0.5 // Same
//        )
//        
//        // Calculate the collective pressure on the Y axis
//        let pressureY = (
//            (cellData.upLeft?.yv ?? 0) * 0.5
//            + (cellData.up?.yv ?? 0)
//            + (cellData.upRight?.yv ?? 0) * 0.5
//            - (cellData.downLeft?.yv ?? 0) * 0.5
//            - (cellData.down?.yv ?? 0)
//            - (cellData.downRight?.yv ?? 0) * 0.5
//        )
//        
//        // Set the cell pressure to one-fourth the sum of both axis pressures
//        cellData.pressure = (pressureX + pressureY) * 0.25
//    }
//
//    func updateVelocity(cellData: Cell) {
//        // Calculate the change in velocity for the X axis
//        let deltaX = (
//            (cellData.upLeft?.pressure ?? 0) * 0.5
//            + (cellData.left?.pressure ?? 0)
//            + (cellData.downLeft?.pressure ?? 0) * 0.5
//            - (cellData.upRight?.pressure ?? 0) * 0.5
//            - (cellData.right?.pressure ?? 0)
//            - (cellData.downRight?.pressure ?? 0) * 0.5
//        ) * 0.25
//        
//        cellData.xv += deltaX
//        
//        // Calculate the change in velocity for the Y axis
//        let deltaY = (
//            (cellData.upLeft?.pressure ?? 0) * 0.5
//            + (cellData.up?.pressure ?? 0)
//            + (cellData.upRight?.pressure ?? 0) * 0.5
//            - (cellData.downLeft?.pressure ?? 0) * 0.5
//            - (cellData.down?.pressure ?? 0)
//            - (cellData.downRight?.pressure ?? 0) * 0.5
//        ) * 0.25
//        
//        cellData.yv += deltaY
//        
//        // Apply damping to the velocities
//        cellData.xv *= 0.99
//        cellData.yv *= 0.99
//    }
//
//    
//    // Mouse event handlers
//    func mouseDownHandler(_ sender: UIGestureRecognizer) {
//        mouse.down = true
//    }
//
//    func mouseUpHandler(_ sender: UIGestureRecognizer) {
//        mouse.down = false
//    }
//
//    func touchStartHandler(_ sender: UITouch) {
//        let location = sender.location(in: canvas)
//        mouse.x = location.x
//        mouse.y = location.y
//        mouse.px = mouse.x
//        mouse.py = mouse.y
//        mouse.down = true
//    }
//
//    func touchEndHandler(_ sender: UITouch) {
//        if sender.phase == .ended {
//            mouse.down = false
//        }
//    }
//
//    func mouseMoveHandler(_ sender: UIGestureRecognizer) {
//        let location = sender.location(in: canvas)
//        mouse.px = mouse.x
//        mouse.py = mouse.y
//        mouse.x = location.x
//        mouse.y = location.y
//    }
//
//    func touchMoveHandler(_ sender: UITouch) {
//        let location = sender.location(in: canvas)
//        mouse.px = mouse.x
//        mouse.py = mouse.y
//        mouse.x = location.x
//        mouse.y = location.y
//    }
//
//
//    // Add gesture recognizers to the canvas
//    func setupGestureRecognizers() {
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(mouseMoveHandler(_:)))
//        canvas.addGestureRecognizer(panGesture)
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mouseDownHandler(_:)))
//        canvas.addGestureRecognizer(tapGesture)
//
//        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(touchStartHandler(_:)))
//        canvas.addGestureRecognizer(touchGesture)
//    }
//
//    
//}
//
//class Cell {
//    var x: CGFloat // X position
//    var y: CGFloat // Y position
//    var r: CGFloat // Width and height of the cell
//    var col: Int // Column index
//    var row: Int // Row index
//    var xv: CGFloat // X velocity
//    var yv: CGFloat // Y velocity
//    var pressure: CGFloat // Pressure attribute
//
//    // Initializer to set up the cell's initial state
//    init(x: CGFloat, y: CGFloat, res: CGFloat) {
//        self.x = x
//        self.y = y
//        self.r = res
//        self.col = 0
//        self.row = 0
//        self.xv = 0
//        self.yv = 0
//        self.pressure = 0
//    }
//}
//
//
//class Particle {
//    var x: CGFloat
//    var px: CGFloat
//    var y: CGFloat
//    var py: CGFloat
//    var xv: CGFloat
//    var yv: CGFloat
//
//    init(x: CGFloat, y: CGFloat) {
//        self.x = x
//        self.px = x
//        self.y = y
//        self.py = y
//        self.xv = 0
//        self.yv = 0
//    }
//}




//class ViewController: UIViewController {
//
//    private var canvasView: UIView!
//    private var particles = [Particle]()
//    private var vecCells = [[Cell]]()
//    
//    private var mouse = Mouse()
//
//    private let canvasWidth: CGFloat = 500
//    private let canvasHeight: CGFloat = 500
//    private let resolution: CGFloat = 10
//    private let penSize: CGFloat = 40
//    private let speckCount: Int = 50
//
//    private var isDrawing = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupCanvas()
//        initializeCellsAndParticles()
//        setupGestureRecognizers()
//        startDrawing()
//    }
//
//    private func setupCanvas() {
//        canvasView = UIView(frame: CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight))
//        canvasView.backgroundColor = .black
//        canvasView.layer.borderColor = UIColor.white.cgColor
//        canvasView.layer.borderWidth = 2
//        view.addSubview(canvasView)
//    }
//
//    private func initializeCellsAndParticles() {
//        for _ in 0..<speckCount {
//            particles.append(Particle(x: CGFloat.random(in: 0..<canvasWidth), y: CGFloat.random(in: 0..<canvasHeight)))
//        }
//        
//        let numCols = Int(canvasWidth / resolution)
//        let numRows = Int(canvasHeight / resolution)
//        
//        for col in 0..<numCols {
//            var colCells = [Cell]()
//            for row in 0..<numRows {
//                let cell = Cell(x: CGFloat(col) * resolution, y: CGFloat(row) * resolution, resolution: resolution)
//                colCells.append(cell)
//            }
//            vecCells.append(colCells)
//        }
//        
//        for col in 0..<numCols {
//            for row in 0..<numRows {
//                let cell = vecCells[col][row]
//                
//                let rowUp = (row - 1 + numRows) % numRows
//                let colLeft = (col - 1 + numCols) % numCols
//                let colRight = (col + 1) % numCols
//                
//                let up = vecCells[col][rowUp]
//                let left = vecCells[colLeft][row]
//                let upLeft = vecCells[colLeft][rowUp]
//                let upRight = vecCells[colRight][rowUp]
//                
//                cell.up = up
//                cell.left = left
//                cell.upLeft = upLeft
//                cell.upRight = upRight
//                
//                up.down = cell
//                left.right = cell
//                upLeft.downRight = cell
//                upRight.downLeft = cell
//            }
//        }
//    }
//
//    private func setupGestureRecognizers() {
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        canvasView.addGestureRecognizer(panGestureRecognizer)
//        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        canvasView.addGestureRecognizer(tapGestureRecognizer)
//    }
//
//    private func startDrawing() {
//        Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
//            self.draw()
//        }
//    }
//
//    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
//        let point = gesture.location(in: canvasView)
//        mouse.x = point.x
//        mouse.y = point.y
//        mouse.down = gesture.state == .began || gesture.state == .changed
//    }
//
//    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
//        let point = gesture.location(in: canvasView)
//        mouse.x = point.x
//        mouse.y = point.y
//        mouse.down = true
//    }
//
//    private func draw() {
//        UIGraphicsBeginImageContext(canvasView.bounds.size)
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        
//        context.setFillColor(UIColor.black.cgColor)
//        context.fill(canvasView.bounds)
//        
//        let mouseXv = mouse.x - mouse.px
//        let mouseYv = mouse.y - mouse.py
//        
//        for col in vecCells {
//            for cell in col {
//                if mouse.down {
//                    changeCellVelocity(cell, mvelX: mouseXv, mvelY: mouseYv, penSize: penSize)
//                }
//                updatePressure(cell)
//            }
//        }
//        
//        updateParticle()
//        
//        for col in vecCells {
//            for cell in col {
//                updateVelocity(cell)
//            }
//        }
//        
//        mouse.px = mouse.x
//        mouse.py = mouse.y
//        
//        context.setStrokeColor(UIColor.cyan.cgColor)
//        context.setLineWidth(1)
//        
//        for p in particles {
//            context.beginPath()
//            context.move(to: CGPoint(x: p.px, y: p.py))
//            context.addLine(to: CGPoint(x: p.x, y: p.y))
//            context.strokePath()
//        }
//        
//        UIGraphicsEndImageContext()
//        canvasView.setNeedsDisplay()
//    }
//
//    private func changeCellVelocity(_ cell: Cell, mvelX: CGFloat, mvelY: CGFloat, penSize: CGFloat) {
//        let dx = cell.x - mouse.x
//        let dy = cell.y - mouse.y
//        let dist = sqrt(dx * dx + dy * dy)
//        
//        if dist < penSize {
//            let power = penSize / max(dist, 4)
//            cell.xv += mvelX * power
//            cell.yv += mvelY * power
//        }
//    }
//
//    private func updatePressure(_ cell: Cell) {
//        // Break down the calculations into simpler components
//
//        // Compute contributions from neighboring cells for X direction
//        let upLeftXv = cell.upLeft?.xv ?? 0
//        let leftXv = cell.left?.xv ?? 0
//        let downLeftXv = cell.downLeft?.xv ?? 0
//        let upRightXv = cell.upRight?.xv ?? 0
//        let rightXv = cell.right?.xv ?? 0
//        let downRightXv = cell.downRight?.xv ?? 0
//
//        let pressureX = (upLeftXv * 0.5 + leftXv + downLeftXv * 0.5
//                         - upRightXv * 0.5 - rightXv - downRightXv * 0.5)
//
//        // Compute contributions from neighboring cells for Y direction
//        let upLeftYv = cell.upLeft?.yv ?? 0
//        let upYv = cell.up?.yv ?? 0
//        let upRightYv = cell.upRight?.yv ?? 0
//        let downLeftYv = cell.downLeft?.yv ?? 0
//        let downYv = cell.down?.yv ?? 0
//        let downRightYv = cell.downRight?.yv ?? 0
//
//        let pressureY = (upLeftYv * 0.5 + upYv + upRightYv * 0.5
//                         - downLeftYv * 0.5 - downYv - downRightYv * 0.5)
//
//        // Set the pressure
//        cell.pressure = (pressureX + pressureY) * 0.25
//    }
//
//    private func updateVelocity(_ cell: Cell) {
//        // Calculate contributions from neighboring cells for X direction
//        let upLeftPressure = cell.upLeft?.pressure ?? 0
//        let leftPressure = cell.left?.pressure ?? 0
//        let downLeftPressure = cell.downLeft?.pressure ?? 0
//        let upRightPressure = cell.upRight?.pressure ?? 0
//        let rightPressure = cell.right?.pressure ?? 0
//        let downRightPressure = cell.downRight?.pressure ?? 0
//        
//        // Calculate velocity change based on pressure in X direction
//        let velocityChangeX = (upLeftPressure * 0.5
//                               + leftPressure
//                               + downLeftPressure * 0.5
//                               - upRightPressure * 0.5
//                               - rightPressure
//                               - downRightPressure * 0.5) * 0.25
//        
//        // Apply the velocity change to the cell's X velocity
//        cell.xv += velocityChangeX
//        
//        // Calculate contributions from neighboring cells for Y direction
//        let upLeftPressureY = cell.upLeft?.pressure ?? 0
//        let upPressure = cell.up?.pressure ?? 0
//        let upRightPressureY = cell.upRight?.pressure ?? 0
//        let downLeftPressureY = cell.downLeft?.pressure ?? 0
//        let downPressure = cell.down?.pressure ?? 0
//        let downRightPressureY = cell.downRight?.pressure ?? 0
//        
//        // Calculate velocity change based on pressure in Y direction
//        let velocityChangeY = (upLeftPressureY * 0.5
//                               + upPressure
//                               + upRightPressureY * 0.5
//                               - downLeftPressureY * 0.5
//                               - downPressure
//                               - downRightPressureY * 0.5) * 0.25
//        
//        // Apply the velocity change to the cell's Y velocity
//        cell.yv += velocityChangeY
//        
//        // Apply a damping factor to reduce velocity over time
//        cell.xv *= 0.99
//        cell.yv *= 0.99
//    }
//
//
//    private func updateParticle() {
//        for p in particles {
//            if p.x >= 0 && p.x < canvasWidth && p.y >= 0 && p.y < canvasHeight {
//                let col = Int(p.x / resolution)
//                let row = Int(p.y / resolution)
//                let cell = vecCells[col][row]
//                
//                let ax = (p.x.truncatingRemainder(dividingBy: resolution)) / resolution
//                let ay = (p.y.truncatingRemainder(dividingBy: resolution)) / resolution
//                
//                p.xv += (1 - ax) * cell.xv * 0.05
//                p.yv += (1 - ay) * cell.yv * 0.05
//                p.xv += ax * cell.right!.xv * 0.05
//                p.yv += ax * cell.right!.yv * 0.05
//                p.xv += ay * cell.down!.xv * 0.05
//                p.yv += ay * cell.down!.yv * 0.05
//                
//                p.x += p.xv
//                p.y += p.yv
//                
//                let dx = p.px - p.x
//                let dy = p.py - p.y
//                let dist = sqrt(dx * dx + dy * dy)
//                let limit = CGFloat.random(in: 0..<0.5)
//                
//                if dist > limit {
//                    canvasView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//                    let path = UIBezierPath()
//                    path.move(to: CGPoint(x: p.x, y: p.y))
//                    path.addLine(to: CGPoint(x: p.px, y: p.py))
//                    
//                    let shapeLayer = CAShapeLayer()
//                    shapeLayer.path = path.cgPath
//                    shapeLayer.strokeColor = UIColor.cyan.cgColor
//                    shapeLayer.lineWidth = 1
//                    canvasView.layer.addSublayer(shapeLayer)
//                } else {
//                    let path = UIBezierPath()
//                    path.move(to: CGPoint(x: p.x, y: p.y))
//                    path.addLine(to: CGPoint(x: p.x + limit, y: p.y + limit))
//                    
//                    let shapeLayer = CAShapeLayer()
//                    shapeLayer.path = path.cgPath
//                    shapeLayer.strokeColor = UIColor.cyan.cgColor
//                    shapeLayer.lineWidth = 1
//                    canvasView.layer.addSublayer(shapeLayer)
//                }
//                
//                p.px = p.x
//                p.py = p.y
//            } else {
//                p.x = CGFloat.random(in: 0..<canvasWidth)
//                p.y = CGFloat.random(in: 0..<canvasHeight)
//                p.px = p.x
//                p.py = p.y
//                p.xv = 0
//                p.yv = 0
//            }
//            
//            p.xv *= 0.5
//            p.yv *= 0.5
//        }
//    }
//}
//
//struct Mouse {
//    var x: CGFloat = 0
//    var y: CGFloat = 0
//    var px: CGFloat = 0
//    var py: CGFloat = 0
//    var down: Bool = false
//}
//
//class Cell {
//    var x: CGFloat
//    var y: CGFloat
//    var r: CGFloat
//    var col: Int = 0
//    var row: Int = 0
//    var xv: CGFloat = 0
//    var yv: CGFloat = 0
//    var pressure: CGFloat = 0
//    
//    var up: Cell?
//    var left: Cell?
//    var upLeft: Cell?
//    var upRight: Cell?
//    var down: Cell?
//    var right: Cell?
//    var downLeft: Cell?
//    var downRight: Cell?
//    
//    init(x: CGFloat, y: CGFloat, resolution: CGFloat) {
//        self.x = x
//        self.y = y
//        self.r = resolution
//    }
//}
//
//class Particle {
//    var x: CGFloat
//    var y: CGFloat
//    var px: CGFloat
//    var py: CGFloat
//    var xv: CGFloat = 0
//    var yv: CGFloat = 0
//    
//    init(x: CGFloat, y: CGFloat) {
//        self.x = x
//        self.y = y
//        self.px = x
//        self.py = y
//    }
//}

//class ViewController: UIViewController {
//    
//    //private var canvasView: UIView!
//    private var context: CGContext!
//    
//    private var mouse = Mouse()
//    
//    private let canvasWidth: CGFloat = 500
//    private let canvasHeight: CGFloat = 500
//    private let resolution: CGFloat = 10
//    private let penSize: CGFloat = 40
//    private let speckCount: Int = 5000
//    
//    private var vecCells = [[Cell]]()
//    private var particles = [Particle]()
//
//    private var canvasView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .black
//        view.layer.borderColor = UIColor.white.cgColor
//        view.layer.borderWidth = 2
//        return view
//    }()
//    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Click and drag!"
//        label.textColor = .white
//        label.textAlignment = .center
//        return label
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Add the canvas view and title label to the view
//        view.addSubview(canvasView)
//        view.addSubview(titleLabel)
//        
//        // Set up constraints
//        setupConstraints()
//        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//            canvasView.addGestureRecognizer(panGesture)
//        
//        setupCanvas()
//        initializeCellsAndParticles()
//        setupGestureRecognizers()
//        startDrawing()
//
//    }
//    
////    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
////        let location = gesture.location(in: canvasView)
////        // Handle drag action here
////    }
//    
//    private func setupConstraints() {
//        canvasView.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            // Title Label constraints
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            
//            // Canvas View constraints
//            canvasView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
//            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ])
//    }
//
//    private func setupCanvas() {
//            canvasView = UIView(frame: CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight))
//            canvasView.backgroundColor = .black
//            canvasView.layer.borderColor = UIColor.white.cgColor
//            canvasView.layer.borderWidth = 2
//            view.addSubview(canvasView)
//            
//            let contextSize = canvasView.bounds.size
//            UIGraphicsBeginImageContext(contextSize)
//            context = UIGraphicsGetCurrentContext()
//            context?.setStrokeColor(UIColor.cyan.cgColor)
//            context?.setLineWidth(1)
//            UIGraphicsEndImageContext()
//        }
//        
//        private func initializeCellsAndParticles() {
//            for _ in 0..<speckCount {
//                particles.append(Particle(x: CGFloat.random(in: 0..<canvasWidth), y: CGFloat.random(in: 0..<canvasHeight)))
//            }
//            
//            let numCols = Int(canvasWidth / resolution)
//            let numRows = Int(canvasHeight / resolution)
//            
//            for col in 0..<numCols {
//                var colCells = [Cell]()
//                for row in 0..<numRows {
//                    let cell = Cell(x: CGFloat(col) * resolution, y: CGFloat(row) * resolution, resolution: resolution)
//                    colCells.append(cell)
//                }
//                vecCells.append(colCells)
//            }
//            
//            for col in 0..<numCols {
//                for row in 0..<numRows {
//                    let cell = vecCells[col][row]
//                    
//                    let rowUp = (row - 1 + numRows) % numRows
//                    let colLeft = (col - 1 + numCols) % numCols
//                    let colRight = (col + 1) % numCols
//                    
//                    let up = vecCells[col][rowUp]
//                    let left = vecCells[colLeft][row]
//                    let upLeft = vecCells[colLeft][rowUp]
//                    let upRight = vecCells[colRight][rowUp]
//                    
//                    cell.up = up
//                    cell.left = left
//                    cell.upLeft = upLeft
//                    cell.upRight = upRight
//                    
//                    up.down = cell
//                    left.right = cell
//                    upLeft.downRight = cell
//                    upRight.downLeft = cell
//                }
//            }
//        }
//        
//        private func setupGestureRecognizers() {
//            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//            canvasView.addGestureRecognizer(panGestureRecognizer)
//            
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//            canvasView.addGestureRecognizer(tapGestureRecognizer)
//        }
//        
//        private func startDrawing() {
//            Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
//                self.draw()
//            }
//        }
//        
//        @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
//            let point = gesture.location(in: canvasView)
//            mouse.x = point.x
//            mouse.y = point.y
//            mouse.down = gesture.state == .began || gesture.state == .changed
//        }
//        
//        @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
//            let point = gesture.location(in: canvasView)
//            mouse.x = point.x
//            mouse.y = point.y
//            mouse.down = true
//        }
//        
//        private func draw() {
//            guard let context = UIGraphicsGetCurrentContext() else { return }
//            context.clear(canvasView.bounds)
//            
//            let mouseXv = mouse.x - mouse.px
//            let mouseYv = mouse.y - mouse.py
//            
//            for col in vecCells {
//                for cell in col {
//                    if mouse.down {
//                        changeCellVelocity(cell, mvelX: mouseXv, mvelY: mouseYv, penSize: penSize)
//                    }
//                    updatePressure(cell)
//                }
//            }
//            
//            updateParticle()
//            
//            for col in vecCells {
//                for cell in col {
//                    updateVelocity(cell)
//                }
//            }
//            
//            mouse.px = mouse.x
//            mouse.py = mouse.y
//            
//            canvasView.setNeedsDisplay()
//        }
//        
//        private func changeCellVelocity(_ cell: Cell, mvelX: CGFloat, mvelY: CGFloat, penSize: CGFloat) {
//            let dx = cell.x - mouse.x
//            let dy = cell.y - mouse.y
//            let dist = sqrt(dx * dx + dy * dy)
//            
//            if dist < penSize {
//                let power = penSize / max(dist, 4)
//                cell.xv += mvelX * power
//                cell.yv += mvelY * power
//            }
//        }
//        
//        private func updatePressure(_ cell: Cell) {
//            let pressureX = (cell.upLeft.xv * 0.5 + cell.left.xv + cell.downLeft.xv * 0.5
//                             - cell.upRight.xv * 0.5 - cell.right.xv - cell.downRight.xv * 0.5)
//            let pressureY = (cell.upLeft.yv * 0.5 + cell.up.yv + cell.upRight.yv * 0.5
//                             - cell.downLeft.yv * 0.5 - cell.down.yv - cell.downRight.yv * 0.5)
//            cell.pressure = (pressureX + pressureY) * 0.25
//        }
//        
//        private func updateVelocity(_ cell: Cell) {
//            cell.xv += (cell.upLeft.pressure * 0.5 + cell.left.pressure + cell.downLeft.pressure * 0.5
//                        - cell.upRight.pressure * 0.5 - cell.right.pressure - cell.downRight.pressure * 0.5) * 0.25
//            cell.yv += (cell.upLeft.pressure * 0.5 + cell.up.pressure + cell.upRight.pressure * 0.5
//                        - cell.downLeft.pressure * 0.5 - cell.down.pressure - cell.downRight.pressure * 0.5) * 0.25
//            cell.xv *= 0.99
//            cell.yv *= 0.99
//        }
//        
//        private func updateParticle() {
//            for p in particles {
//                if p.x >= 0 && p.x < canvasWidth && p.y >= 0 && p.y < canvasHeight {
//                    let col = Int(p.x / resolution)
//                    let row = Int(p.y / resolution)
//                    let cell = vecCells[col][row]
//                    
//                    let ax = (p.x.truncatingRemainder(dividingBy: resolution)) / resolution
//                    let ay = (p.y.truncatingRemainder(dividingBy: resolution)) / resolution
//                    
//                    p.xv += (1 - ax) * cell.xv * 0.05
//                    p.yv += (1 - ay) * cell.yv * 0.05
//                    p.xv += ax * cell.right.xv * 0.05
//                    p.yv += ax * cell.right.yv * 0.05
//                    p.xv += ay * cell.down.xv * 0.05
//                    p.yv += ay * cell.down.yv * 0.05
//                    
//                    p.x += p.xv
//                    p.y += p.yv
//                    
//                    let dx = p.px - p.x
//                    let dy = p.py - p.y
//                    let dist = sqrt(dx * dx + dy * dy)
//                    let limit = CGFloat.random(in: 0..<0.5)
//                    
//                    if dist > limit {
//                        context?.beginPath()
//                        context?.move(to: CGPoint(x: p.x, y: p.y))
//                        context?.addLine(to: CGPoint(x: p.px, y: p.py))
//                        context?.strokePath()
//                    } else {
//                        context?.beginPath()
//                        context?.move(to: CGPoint(x: p.x, y: p.y))
//                        context?.addLine(to: CGPoint(x: p.x + limit, y: p.y + limit))
//                        context?.strokePath()
//                    }
//                    
//                    p.px = p.x
//                    p.py = p.y
//                } else {
//                    p.x = CGFloat.random(in: 0..<canvasWidth)
//                    p.y = CGFloat.random(in: 0..<canvasHeight)
//                    p.xv = 0
//                    p.yv = 0
//                }
//                p.xv *= 0.5
//                p.yv *= 0.5
//            }
//        }
//    }
//    struct Mouse {
//        var x: CGFloat = 0
//        var y: CGFloat = 0
//        var px: CGFloat = 0
//        var py: CGFloat = 0
//        var down: Bool = false
//    }
//
//    class Cell {
//        var x: CGFloat
//        var y: CGFloat
//        var r: CGFloat
//        var col: Int = 0
//        var row: Int = 0
//        var xv: CGFloat = 0
//        var yv: CGFloat = 0
//        var pressure: CGFloat = 0
//        
//        var up: Cell!
//        var left: Cell!
//        var upLeft: Cell!
//        var upRight: Cell!
//        var down: Cell!
//        var right: Cell!
//        var downLeft: Cell!
//        var downRight: Cell!
//        
//        init(x: CGFloat, y: CGFloat, resolution: CGFloat) {
//            self.x = x
//            self.y = y
//            self.r = resolution
//        }
//    }
//
//    class Particle {
//        var x: CGFloat
//        var y: CGFloat
//        var px: CGFloat
//        var py: CGFloat
//        var xv: CGFloat = 0
//        var yv: CGFloat = 0
//        
//        init(x: CGFloat, y: CGFloat) {
//            self.x = x
//            self.y = y
//            self.px = x
//            self.py = y
//        }
//    }



