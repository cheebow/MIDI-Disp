//
//  ContentView.swift
//  MIDI-Disp
//
//  Created by CHEEBOW on 2019/08/20.
//  Copyright © 2019 CHEEBOW. All rights reserved.
//

import Cocoa

class ContentView : NSView {
    override var isFlipped: Bool {
        return true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.black.setFill()
        dirtyRect.fill()
    }
}
