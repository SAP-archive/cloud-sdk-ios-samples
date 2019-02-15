//
//  BikeStationAnnotationView.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/15/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import MapKit

class BikeStationAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        var numBikes = 0
        var numEBikes = 0
        if let bikeStationAnnotation = annotation as? BikeStationAnnotation {
            numBikes = bikeStationAnnotation.numBikes
            numEBikes = bikeStationAnnotation.numEBikes

        } else if let bikeStationClusterAnnotation = annotation as? MKClusterAnnotation {
            let members = bikeStationClusterAnnotation.memberAnnotations.compactMap({ return $0 as? BikeStationAnnotation })
            numBikes = members.reduce(0) { (result, next) in
                result + next.numBikes
            }
            numEBikes = members.reduce(0) { (result, next) in
                result + next.numEBikes
            }
        }
        let totalBikes = numBikes + numEBikes
        if totalBikes == 0 {
            image = drawRatio(0, to: totalBikes, fractionColor: nil, wholeColor: Colors.red, annotation as? MKClusterAnnotation != nil)
        } else {
            image = drawRatio(numBikes, to: totalBikes, fractionColor: Colors.green, wholeColor: Colors.darkBlue, annotation as? MKClusterAnnotation != nil)
        }
        displayPriority = .defaultLow
    }
    
    private func drawRatio(_ fraction: Int, to whole: Int, fractionColor: UIColor?, wholeColor: UIColor?, _ isCluster: Bool) -> UIImage {
        let squarelength: CGFloat = 35
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: squarelength, height: squarelength))
        return renderer.image { _ in
            // Fill full circle with wholeColor
            wholeColor?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: squarelength, height: squarelength)).fill()
            
            // Fill pie with fractionColor
            fractionColor?.setFill()
            let piePath = UIBezierPath()
            piePath.addArc(withCenter: CGPoint(x: squarelength/2, y: squarelength/2), radius: squarelength/2,
                           startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(fraction)) / CGFloat(whole),
                           clockwise: true)
            piePath.addLine(to: CGPoint(x: squarelength/2, y: squarelength/2))
            piePath.close()
            piePath.fill()
            
            // Fill inner circle with white color
            UIColor.white.setFill()
            UIBezierPath(arcCenter: CGPoint(x: squarelength/2, y: squarelength/2), radius: squarelength/4, startAngle: 0, endAngle: 360, clockwise: true).fill()
            
            // Finally draw count text vertically and horizontally centered
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black/*,
                 NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)*/]
            let text = "\(whole)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: squarelength/2 - size.width / 2, y: squarelength/2 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
    
}
