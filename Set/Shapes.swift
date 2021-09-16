//
//  Shapes.swift
//  Set
//
//  Created by Андрей Гавриков on 16.09.2021.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        return path
    }
    
}
struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let x = rect.maxX
        let y = rect.maxY
        path.move(to: CGPoint(x: 1.00 * x, y: 0.15 * y))
        path.addCurve(to: CGPoint(x: 0.63 * x, y: 0.63 * y), control1: CGPoint(x: 1.00 * x, y: 0.36 * y), control2: CGPoint(x: 0.90 * x, y: 0.8 * y))
        path.addCurve(to: CGPoint(x: 0.27 * x, y: 0.53 * y), control1: CGPoint(x: 0.52 * x, y: 0.51 * y), control2: CGPoint(x: 0.42 * x, y: 0.42 * y))
        path.addCurve(to: CGPoint(x: 0.00 * x, y: 0.40 * y), control1: CGPoint(x: 0.09 * x, y: 0.65 * y), control2: CGPoint(x: 0.05 * x, y: 0.58 * y))
        path.addCurve(to: CGPoint(x: 0.36 * x, y: 0.12 * y), control1: CGPoint(x: 0.04 * x, y: 0.22 * y), control2: CGPoint(x: 0.19 * x, y: 0.10 * y))
        path.addCurve(to: CGPoint(x: 0.89 * x, y: 0.14 * y), control1: CGPoint(x: 0.59 * x, y: 0.15 * y), control2: CGPoint(x: 0.62 * x, y: 0.31 * y))
        path.addCurve(to: CGPoint(x: 1.00 * x, y: 0.15 * y), control1: CGPoint(x: 0.95 * x, y: 0.10 * y), control2: CGPoint(x: 1.00 * x, y: 0.07 * y))
        return path
    }
}
    
struct Stripes: Shape {
    let lineSpace: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        var nextX: CGFloat = 0
        for i in 0...(Int(rect.maxX / lineSpace)) {
            path.move(to: CGPoint(x: nextX, y: 0))
            path.addLine(to: CGPoint(x: nextX, y: rect.maxY))
            nextX = CGFloat(i) * lineSpace
        }
        return path
    }
    
    
    
}
    
extension Shape {
    public func stripped(spacing: CGFloat = 4.0) -> some View {
        return Stripes(lineSpace: spacing).stroke().clipShape(self)
    }
    
    @ViewBuilder
    public func style(with style: Int) -> some View {
                switch style {
                case 1:
                    self.stroke()
                case 2:
                    ZStack {
                        self.stripped()
                        self.stroke()
                    }
                default:
                    self.fill()
                }
    }
    
    
}
