//
//  ViewController.swift
//  slideshow

import UIKit
import PocketSVG

class ViewController: UIViewController {
    
    var birdsData: BirdsData!
    var dots: Dots!
    var label: Label!
    var birdShapeLayerSetup: BirdShapeLayer!
    var duration = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        dots = Dots(view: view)
        label = Label(view: self.view)
        birdsData = BirdsData()
        
        if let bird1Data = birdsData.bird1Data {
            birdShapeLayerSetup = BirdShapeLayer(view: self.view, birdData: bird1Data)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.startSequentialAnimation()
        }
    }
    
    func startSequentialAnimation() {
        guard let bird1Data = birdsData.bird1Data,
              let bird2Data = birdsData.bird2Data,
              let bird3Data = birdsData.bird3Data,
              let bird4Data = birdsData.bird4Data,
              let bird5Data = birdsData.bird5Data else {
            print("Bird data is not loaded.")
            return
        }

        let birdDataArray = [bird1Data, bird2Data, bird3Data, bird4Data, bird5Data]

        func animateNext(index: Int) {
            let currentIndex = index % birdDataArray.count
            let nextIndex = (index + 1) % birdDataArray.count

            let currentData = birdDataArray[currentIndex]
            let nextData = birdDataArray[nextIndex]

            label.animateTextChange(index: nextIndex, duration: duration)
            dots.animateDotChange(index: nextIndex, duration: duration)

            birdShapeLayerSetup.morph(from: currentData, to: nextData, duration: duration) {
                animateNext(index: nextIndex)
            }
        }

        animateNext(index: 0)
    }
}


//import UIKit
//import PocketSVG
//
//class ViewController: UIViewController {
//    
//    var birdShapeLayer: CAShapeLayer!
//    var bird1Data: ([SVGBezierPath], [UIColor])? = nil
//    var bird2Data: ([SVGBezierPath], [UIColor])? = nil
//    var bird3Data: ([SVGBezierPath], [UIColor])? = nil
//    var bird4Data: ([SVGBezierPath], [UIColor])? = nil
//    var bird5Data: ([SVGBezierPath], [UIColor])? = nil
//    var duration = 1.0
//    
//    let texts = ["Great tit", "Bullfinch", "Dunnock", "Dove", "Mockingbird"]
//    private let textLabel = UILabel()
//    
//    private var dots: [UIView] = []
//    private let numberOfDots = 5
//    private var dotSize: CGFloat = 0.0
//    private var grayDotSize: CGFloat = 10.0
//    private var coloredDotSize: CGFloat = 15.0
//    private let dotSpacing: CGFloat = 15.0
//    private var dotYPosition: CGFloat = 370.0
//    let dotColors = [UIColor(red: 230/255.0, green: 197/255.0, blue: 131/255.0, alpha: 1.0),
//                     UIColor(red: 183/255.0, green: 73/255.0, blue: 53/255.0, alpha: 1.0),
//                     UIColor(red: 133/255.0, green: 87/255.0, blue: 49/255.0, alpha: 1.0),
//                     UIColor(red: 102/255.0, green: 143/255.0, blue: 141/255.0, alpha: 1.0),
//                     UIColor(red: 97/255.0, green: 104/255.0, blue: 114/255.0, alpha: 1.0)]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//       
//        setupDots()
//        setupLabel()
//        setupBirdData()
//        setupBirdShapeLayer()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.startSequentialAnimation()
//        }
//    }
//    
//    func setupBirdData() {
//        bird1Data = loadSVG(birdName: "bird1")
//        bird2Data = loadSVG(birdName: "bird2")
//        bird3Data = loadSVG(birdName: "bird3")
//        bird4Data = loadSVG(birdName: "bird4")
//        bird5Data = loadSVG(birdName: "bird5")
//    }
//    
//    func setupBirdShapeLayer() {
//        birdShapeLayer = CAShapeLayer()
//        let boundingBox = birdShapeLayer.path?.boundingBox ?? .zero
//        birdShapeLayer.frame = CGRect(x: view.bounds.width/4,
//                                      y: 33,
//                                      width: boundingBox.width,
//                                      height: boundingBox.height)
//        
//        let transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        birdShapeLayer.setAffineTransform(transform)
//                
//        view.layer.addSublayer(birdShapeLayer)
//        
//        for (index, path) in bird1Data!.0.enumerated() {
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.path = path.cgPath
//            shapeLayer.fillColor = bird1Data!.1[index % bird1Data!.1.count].cgColor
//            birdShapeLayer.addSublayer(shapeLayer)
//        }
//    }
//    
//    private func setupLabel() {
//        textLabel.frame = CGRect(x: 50, y: 60, width: view.frame.width - 40, height: 50)
//        textLabel.textAlignment = .left
//        textLabel.font = UIFont.boldSystemFont(ofSize: 36)
//        self.textLabel.text = self.texts[0]
//        view.addSubview(textLabel)
//   }
//    
//    @objc private func animateTextChange(index: Int) {
//        UIView.transition(with: textLabel, duration: duration + 1.0, options: .transitionCrossDissolve, animations: {
//           self.textLabel.text = self.texts[index]
//       })
//   }
//    
//    func loadSVG(birdName: String) -> ([SVGBezierPath], [UIColor]) {
//        let svgPathURL = Bundle.main.url(forResource: birdName, withExtension: "svg")
//        let paths = SVGBezierPath.pathsFromSVG(at: svgPathURL!)
//        let colors:[UIColor] = UIColorsFromHex(fromHexStrings: extractColorsFromSVG(named: birdName))
//        
//        return (paths, colors)
//    }
//    
//    func startSequentialAnimation() {
//        guard let bird1Data = bird1Data,
//              let bird2Data = bird2Data,
//              let bird3Data = bird3Data,
//              let bird4Data = bird4Data,
//              let bird5Data = bird5Data else {
//            print("Bird data is not loaded.")
//            return
//        }
//        
//        let birdDataArray = [bird1Data, bird2Data, bird3Data, bird4Data, bird5Data]
//
//        func animateNext(index: Int) {
//            let currentIndex = index % birdDataArray.count
//            let nextIndex = (index + 1) % birdDataArray.count
//            
//            let currentData = birdDataArray[currentIndex]
//            let nextData = birdDataArray[nextIndex]
//            
//            animateTextChange(index: nextIndex)
//            animateDotChange(index: nextIndex)
//            
//            morph(from: currentData, to: nextData) {
//                animateNext(index: nextIndex)
//            }
//        }
//        
//        animateNext(index: 0)
//    }
//    
//    
//    func morph(from startData: ([SVGBezierPath], [UIColor]), to nextData: ([SVGBezierPath], [UIColor]), completion: @escaping () -> Void) {
//        
//        let startPaths = startData.0
//        let endPaths = nextData.0
//        let startColors = startData.1
//        let endColors = nextData.1
//        
//        guard startPaths.count == endPaths.count else {
//            print("The start and end paths arrays do not match in length.")
//            return
//        }
//        
//        guard let birdShapeLayer = birdShapeLayer else {
//            print("birdShapeLayer is nil.")
//            return
//        }
//        
//        let sublayers = birdShapeLayer.sublayers ?? []
//        
//        for i in 0..<startPaths.count {
//            let startPath = startPaths[i]
//            let endPath = endPaths[i]
//            
//            let startColor = startColors[i]
//            let endColor = endColors[i]
//
//            let morphAnimation = CABasicAnimation(keyPath: "path")
//            morphAnimation.fromValue = startPath.cgPath
//            morphAnimation.toValue = endPath.cgPath
//            morphAnimation.duration = duration
//            morphAnimation.fillMode = .forwards
//            morphAnimation.isRemovedOnCompletion = false
//
//            let colorAnimation = CABasicAnimation(keyPath: "fillColor")
//            colorAnimation.fromValue = startColor.cgColor
//            colorAnimation.toValue = endColor.cgColor
//            colorAnimation.duration = duration
//            
//            if i < sublayers.count {
//                let shapeLayer = sublayers[i] as! CAShapeLayer
//                shapeLayer.fillColor = endColors[i % endColors.count].cgColor
//                shapeLayer.add(morphAnimation, forKey: "pathAnimation")
//                shapeLayer.add(colorAnimation, forKey: "colorAnimation")
//            }
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 3.0) {
//            completion()
//        }
//    }
//    
//    private func setupDots() {
//        let startX:CGFloat = 753
//           for i in 0..<numberOfDots {
//               
//               dotSize = i == 0 ? coloredDotSize : grayDotSize
//               
//               let dot = UIView(frame: CGRect(x: startX + CGFloat(i) * (dotSize + dotSpacing), y: dotYPosition - dotSize / 2, width: dotSize, height: dotSize))
//               
//               dot.backgroundColor = i == 0 ? dotColors[0] : .gray
//               
//               dot.layer.cornerRadius = i == 0 ? 0: dotSize / 2
//               
//               view.addSubview(dot)
//               dots.append(dot)
//           }
//       }
//    
//    private func animateDotChange(index: Int) {
//        UIView.animate(withDuration: duration+0.5, animations: {
//            self.dots.forEach { dot in
//                dot.backgroundColor = .gray
//                dot.layer.cornerRadius = self.dotSize / 2
//                dot.frame.size = CGSize(width: self.grayDotSize, height: self.grayDotSize)
//                dot.frame.origin.y = self.dotYPosition - self.grayDotSize / 2
//            }
//
//            let selectedDot = self.dots[index]
//            selectedDot.backgroundColor = self.dotColors[index]
//            selectedDot.layer.cornerRadius = 0 // Square shape
//            selectedDot.frame.size = CGSize(width: self.coloredDotSize, height: self.coloredDotSize)
//            selectedDot.frame.origin.y = self.dotYPosition - self.coloredDotSize / 2
//        })
//    }
//    
//    
//    func UIColorsFromHex(fromHexStrings hexStrings: [String]) -> [UIColor] {
//        return hexStrings.compactMap { UIColor(hex: $0) }
//    }
//    
//    func extractColorsFromSVG(named fileName: String) -> [String] {
//        // Locate the SVG file in the main bundle
//        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "svg") else {
//            print("SVG file not found")
//            return []
//        }
//
//        // Read the SVG file into Data
//        let fileURL = URL(fileURLWithPath: filePath)
//        guard let xmlData = try? Data(contentsOf: fileURL) else {
//            print("Failed to read SVG file")
//            return []
//        }
//        
//        var colors = Array<String>()
//
//        class SVGParserDelegate: NSObject, XMLParserDelegate {
//            var colors: Array<String>
//
//            init(colors: Array<String>) {
//                self.colors = colors
//            }
//
//            func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes: [String : String]) {
//                // Check for 'fill' attribute
//                if let fillColor = attributes["fill"] {
//                    colors.append(fillColor)
//                }
//
//                // Check for 'stroke' attribute if needed
//                if let strokeColor = attributes["stroke"] {
//                    colors.append(strokeColor)
//                }
//            }
//        }
//
//        let parserDelegate = SVGParserDelegate(colors: colors)
//        let parser = XMLParser(data: xmlData)
//        parser.delegate = parserDelegate
//        parser.parse()
//
//        return Array(parserDelegate.colors)
//    }
//}
//
//
//extension UIColor {
//    convenience init?(hex: String) {
//        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//        if hexSanitized.hasPrefix("#") {
//            hexSanitized.remove(at: hexSanitized.startIndex)
//        }
//        guard hexSanitized.count == 6 else {
//            return nil
//        }
//        var rgb: UInt64 = 0
//        Scanner(string: hexSanitized).scanHexInt64(&rgb)
//        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
//        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
//        let blue = CGFloat(rgb & 0xFF) / 255.0
//        self.init(red: red, green: green, blue: blue, alpha: 1.0)
//    }
//}
