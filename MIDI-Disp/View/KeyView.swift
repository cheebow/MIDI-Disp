//
//  Key.swift
//  MIDI-Disp
//
//  Created by CHEEBOW on 2019/08/09.
//  Copyright © 2019 CHEEBOW. All rights reserved.
//

import Cocoa
import SnapKit

class KeyView: NSView {
    let key: Key
    let label: NSTextField = {
        let label = NSTextField(frame: NSRect.zero)
        label.drawsBackground = false
        label.isBordered = false
        label.isEditable = false
        label.isSelectable = false
        label.font = NSFont.boldSystemFont(ofSize: 20)
        return label
    }()

    var isPressed: Bool {
        didSet {
            DispatchQueue.main.async(execute: {
                self.setNeedsDisplay(self.bounds)
            })
        }
    }
    
    init(key: Key) {
        self.key = key
        self.isPressed = false
        super.init(frame: CGRect.zero)
        setup()
    }

    required init?(coder decoder: NSCoder) {
        self.key = Key(name: .c, number: 0)
        self.isPressed = false
        super.init(coder: decoder)
        setup()
    }

    private func setup() {
        addSubview(label)
        label.stringValue = key.name.name
        label.sizeToFit()
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
        label.alphaValue = 0.0
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if key.name.isWhiteKey {
            NSColor.white.setFill()
        } else {
            NSColor.black.setFill()
        }
        if isPressed {
            NSColor.lightGray.setFill()
        }
        label.alphaValue = isPressed ? 1.0 : 0.0
        let path = NSBezierPath(roundedRect: bounds, xRadius: 8.0, yRadius: 8.0)
        path.fill()
    }
}
