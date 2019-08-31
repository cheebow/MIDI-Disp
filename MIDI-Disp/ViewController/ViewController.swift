//
//  ViewController.swift
//  MIDI-Disp
//
//  Created by CHEEBOW on 2019/08/08.
//  Copyright © 2019 CHEEBOW. All rights reserved.
//

import Cocoa
import RxSwift

class ViewController: NSViewController {
    @IBOutlet weak var keyboardView: NSView!
    @IBOutlet weak var pitchWheelView: WheelView!
    @IBOutlet weak var modWheelView: WheelView!
    private let keyboardScrollView = KeyboardScrollView(frame: NSRect.zero)
    private let viewModel = MidiViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()

        makeKeybord()
        pitchWheelView.value = 0.5
        modWheelView.value = 0.0
    }

    private func bind() {
        viewModel.text.subscribe(onNext: { [weak self] text in
            self?.updateText(text)
        }).disposed(by: disposeBag)

        viewModel.noteOn.subscribe(onNext: { [weak self] number in
            self?.keyboardScrollView.noteOn(number: number)
        }).disposed(by: disposeBag)

        viewModel.noteOff.subscribe(onNext: { [weak self] number in
            self?.keyboardScrollView.noteOff(number: number)
        }).disposed(by: disposeBag)

        viewModel.pitch.subscribe(onNext: { [weak self] pitch in
            self?.pitchWheelView.value = CGFloat(pitch)
        }).disposed(by: disposeBag)

        viewModel.modulation.subscribe(onNext: { [weak self] modulation in
            self?.modWheelView.value = CGFloat(modulation)
        }).disposed(by: disposeBag)
    }

    private func makeKeybord() {
        keyboardView.addSubview(keyboardScrollView)

        keyboardScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        keyboardScrollView.updateConstraints()

        DispatchQueue.main.async(execute: { [weak self] in
            self?.keyboardScrollView.defaultPosition()
        })
    }

    func updateText(_ input: String) {
        DispatchQueue.main.async(execute: {
            print(input)
        })
    }

    override func viewDidLayout() {
        super.viewDidLayout()
    }
}
