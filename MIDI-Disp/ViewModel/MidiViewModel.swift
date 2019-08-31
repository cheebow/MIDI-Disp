//
//  MidiViewModel.swift
//  MIDI-Disp
//
//  Created by CHEEBOW on 2019/08/20.
//  Copyright © 2019 CHEEBOW. All rights reserved.
//

import AudioKit
import RxSwift

class MidiViewModel: NSObject {
    var midi = AudioKit.midi

    private let noteOnSubject = PublishSubject<Int>()
    var noteOn: Observable<Int> { return noteOnSubject }
    
    private let noteOffSubject = PublishSubject<Int>()
    var noteOff: Observable<Int> { return noteOffSubject }
    
    private let pitchSubject = PublishSubject<Float>()
    var pitch: Observable<Float> { return pitchSubject }
    
    private let modulationSubject = PublishSubject<Float>()
    var modulation: Observable<Float> { return modulationSubject }
    
    private let textSubject = PublishSubject<String>()
    var text: Observable<String> { return textSubject }

    override init() {
        super.init()
        midi.openInput(name: "Session1")
        midi.addListener(self)
    }

    func updateText(_ input: String) {
        DispatchQueue.main.async(execute: { [weak self] in
            self?.textSubject.onNext(input)
        })
    }
}

extension MidiViewModel: AKMIDIListener {
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        updateText("Channel: \(channel + 1) noteOn: \(noteNumber) velocity: \(velocity) ")
        noteOnSubject.onNext(Int(noteNumber))
    }

    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        updateText("Channel: \(channel + 1) noteOff: \(noteNumber) velocity: \(velocity) ")
        noteOffSubject.onNext(Int(noteNumber))
    }

    func receivedMIDIController(_ controller: MIDIByte, value: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        updateText("Channel: \(channel + 1) controller: \(controller) value: \(value) ")
        if controller == 1 {
            modulationSubject.onNext(Float(value) / 127)
        }
    }

    func receivedMIDIPitchWheel(_ pitchWheelValue: MIDIWord, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        updateText("Pitch Wheel on Channel: \(channel + 1) value: \(pitchWheelValue) ")
        pitchSubject.onNext(Float(pitchWheelValue) / 16383)
    }

    func receivedMIDIAftertouch(noteNumber: MIDINoteNumber, pressure: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        updateText("Channel: \(channel + 1) midiAftertouchOnNote: \(noteNumber) pressure: \(pressure) ")
    }

    func receivedMIDIAfterTouch(_ pressure: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        updateText("Channel: \(channel + 1) midiAfterTouch pressure: \(pressure) ")
    }

    func receivedMIDIProgramChange(_ program: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        updateText("Channel: \(channel + 1) programChange: \(program)")
    }

    func receivedMIDISystemCommand(_ data: [MIDIByte], portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        if let command = AKMIDISystemCommand(rawValue: data[0]) {
            updateText("")
            var newString = "MIDI System Command: \(command) \n"
            for i in 0 ..< data.count {
                let hexValue = String(format: "%02x", data[i])
                newString.append("\(hexValue) ")
            }
            updateText(newString)
        }
        updateText("received \(data.count) bytes of data")
    }
}
