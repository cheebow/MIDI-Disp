//
//  WheelView.swift
//  MIDI-Disp
//
//  Created by CHEEBOW on 2019/08/17.
//  Copyright © 2019 CHEEBOW. All rights reserved.
//

import Cocoa

class WheelView: NSView {
    var value: CGFloat = 0 {
        didSet {
            DispatchQueue.main.async(execute: {
                self.setNeedsDisplay(self.bounds)
            })
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        NSColor.black.setFill()
        dirtyRect.fill()
        
        let lineWidth: CGFloat = 2
        var y = bounds.height * min(max(value, 0), 1)
        y = min(max(y, 1), bounds.height - 1)
        NSColor.white.setStroke()
        NSBezierPath.defaultLineWidth = lineWidth
        NSBezierPath.strokeLine(from: NSPoint(x: 0, y: y) , to: NSPoint(x: bounds.width, y: y))

        let rectangle = NSBezierPath(rect: bounds)
        NSColor.darkGray.set()
        rectangle.lineWidth = 2
        rectangle.stroke()
    }
}
