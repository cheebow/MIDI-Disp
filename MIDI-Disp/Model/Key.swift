//
//  Key.swift
//  MIDI-Disp
//
//  Created by CHEEBOW on 2019/08/09.
//  Copyright © 2019 CHEEBOW. All rights reserved.
//

import Foundation

struct Key {
    let name: KeyName
    let number: Int

    enum KeyName {
        case c
        case cs
        case d
        case ds
        case e
        case f
        case fs
        case g
        case gs
        case a
        case `as`
        case b

        var name: String {
            switch self {
            case .c:
                return "C"
            case .cs:
                return "C#\nDb"
            case .d:
                return "D"
            case .ds:
                return "D#\nEb"
            case .e:
                return "E"
            case .f:
                return "F"
            case .fs:
                return "F#\nGb"
            case .g:
                return "G"
            case .gs:
                return "G#\nAb"
            case .a:
                return "A"
            case .as:
                return "A#\nBb"
            case .b:
                return "B"
            }
        }

        var isWhiteKey: Bool {
            switch self {
            case .c, .d, .e, .f, .g, .a, .b:
                return true
            case .cs, .ds, .fs, .gs, .as:
                return false
            }
        }
    }
}
