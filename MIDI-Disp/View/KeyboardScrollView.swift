//
//  KeyboardScrollView.swift
//  MIDI-Disp
//
//  Created by CHEEBOW on 2019/08/20.
//  Copyright © 2019 CHEEBOW. All rights reserved.
//

import Cocoa

class KeyboardScrollView: NSScrollView {
    let keyWidth: CGFloat = 60
    let keyMargin: CGFloat = 1

    private var keyViews: [KeyView] = []

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        makeKeybord()
        hasHorizontalScroller = true
        autohidesScrollers = false
    }

    private func makeKeybord() {
        var keys: [Key] = []

        (0...10).forEach { octave in
            keys.append(Key(name: .c , number: 0  + 12 * octave))
            keys.append(Key(name: .cs, number: 1  + 12 * octave))
            keys.append(Key(name: .d , number: 2  + 12 * octave))
            keys.append(Key(name: .ds, number: 3  + 12 * octave))
            keys.append(Key(name: .e , number: 4  + 12 * octave))
            keys.append(Key(name: .f , number: 5  + 12 * octave))
            keys.append(Key(name: .fs, number: 6  + 12 * octave))
            keys.append(Key(name: .g , number: 7  + 12 * octave))
            keys.append(Key(name: .gs, number: 8  + 12 * octave))
            keys.append(Key(name: .a , number: 9  + 12 * octave))
            keys.append(Key(name: .as, number: 10 + 12 * octave))
            keys.append(Key(name: .b , number: 11 + 12 * octave))
        }

        let whiteKeys = keys.filter { $0.name.isWhiteKey }
        let blackKeys = keys.filter { !$0.name.isWhiteKey }

        let contentWidth: CGFloat = CGFloat(whiteKeys.count) * keyWidth

        let viewForContent = ContentView(frame: NSRect.zero)

        // white
        var x: CGFloat = 0
        whiteKeys.forEach { key in
            let keyView = KeyView(key: key)
            viewForContent.addSubview(keyView)
            keyViews.append(keyView)
            keyView.snp.makeConstraints { make in
                make.left.equalTo(x)
                make.width.equalTo(keyWidth - keyMargin)
                make.top.equalTo(0)
                make.bottom.equalTo(0)
            }
            x += keyWidth
        }

        // black
        x = keyWidth / 2
        blackKeys.forEach { key in
            let keyView = KeyView(key: key)
            viewForContent.addSubview(keyView)
            keyViews.append(keyView)
            keyView.snp.makeConstraints { make in
                make.left.equalTo(x)
                make.width.equalTo(keyWidth - keyMargin)
                make.top.equalTo(0)
                make.height.equalToSuperview().multipliedBy(0.5)
            }
            x += keyWidth
            switch key.name {
            case .ds, .as:
                x += keyWidth
            default:
                break
            }
        }

        keyViews = keyViews.sorted(by: { $0.key.number < $1.key.number })

        let scrollContentView = NSClipView(frame: NSRect.zero)
        scrollContentView.documentView = viewForContent
        viewForContent.snp.makeConstraints { make in
            make.width.equalTo(contentWidth)
            make.height.equalToSuperview()
        }

        contentView = scrollContentView
    }

    func defaultPosition() {
        // C2の位置を左端に
        let noteNumber = 0
        let whiteKeyNumber = 7
        let octaveIndex = 4
        let offset = CGFloat(noteNumber + octaveIndex * whiteKeyNumber) * keyWidth
        documentView?.scroll(NSPoint(x: offset, y: 0))
    }

    private func key(number: Int) -> KeyView? {
        return keyViews[number]
    }

    private func keyPressed(number: Int, pressed: Bool) {
        let keyView = key(number: number)
        keyView?.isPressed = pressed
    }

    func noteOn(number: Int) {
        keyPressed(number: number, pressed: true)
    }

    func noteOff(number: Int) {
        keyPressed(number: number, pressed: false)
    }
}
