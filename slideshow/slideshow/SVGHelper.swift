//
//  SVGHelper.swift
//  slideshow


import UIKit
import PocketSVG

struct SVGHelper {

    static func loadSVG(birdName: String) -> ([SVGBezierPath], [UIColor]) {
        let svgPathURL = Bundle.main.url(forResource: birdName, withExtension: "svg")
        let paths = SVGBezierPath.pathsFromSVG(at: svgPathURL!)
        let colors: [UIColor] = UIColorsFromHex(fromHexStrings: extractColorsFromSVG(named: birdName))
        
        return (paths, colors)
    }
    
    static func UIColorsFromHex(fromHexStrings hexStrings: [String]) -> [UIColor] {
        return hexStrings.compactMap { UIColor(hex: $0) }
    }

    static func extractColorsFromSVG(named fileName: String) -> [String] {
        // Locate the SVG file in the main bundle
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "svg") else {
            print("SVG file not found")
            return []
        }

        // Read the SVG file into Data
        let fileURL = URL(fileURLWithPath: filePath)
        guard let xmlData = try? Data(contentsOf: fileURL) else {
            print("Failed to read SVG file")
            return []
        }

        var colors = Array<String>()

        class SVGParserDelegate: NSObject, XMLParserDelegate {
            var colors: Array<String>

            init(colors: Array<String>) {
                self.colors = colors
            }

            func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes: [String : String]) {
                // Check for 'fill' attribute
                if let fillColor = attributes["fill"] {
                    colors.append(fillColor)
                }

                // Check for 'stroke' attribute if needed
                if let strokeColor = attributes["stroke"] {
                    colors.append(strokeColor)
                }
            }
        }

        let parserDelegate = SVGParserDelegate(colors: colors)
        let parser = XMLParser(data: xmlData)
        parser.delegate = parserDelegate
        parser.parse()

        return Array(parserDelegate.colors)
    }
}
