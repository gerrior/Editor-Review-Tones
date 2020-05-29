//
//  ViewController.swift
//  Editor Review Tones
//
//  Created by Mark Gerrior on 5/26/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: Properties

    let clipController = ClipController()

    @IBOutlet private weak var listButtonLabel: UIButton!
    @IBOutlet private weak var recordButtonLabel: UIButton!
    @IBOutlet private weak var playButtonLabel: UIButton!
    @IBOutlet private weak var micButtonLabel: UIButton!

    @IBAction func recordButtonAction(_ sender: Any) {
        recordTapped()
    }

    @IBAction func playButtonAction(_ sender: Any) {
        playRecording()
    }

    @IBAction func clipButton(_ sender: Any) {
        print("Timestamp")
    }

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        print(getDocumentsDirectory().absoluteString)

        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // FIXME: failed to record!
                        print("Do: failed to record!")
                    }
                }
            }
        } catch {
            print("Catch: failed to record!")
        }
    }

    func loadRecordingUI() {
        // List Button: Increase size
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .large)
        var largeImage = UIImage(systemName: "list.bullet", withConfiguration: largeConfig)
        listButtonLabel.setImage(largeImage, for: .normal)

        // Record Button:
        largeImage = UIImage(systemName: "smallcircle.circle.fill", withConfiguration: largeConfig)
        recordButtonLabel.tintColor = UIColor.red
        recordButtonLabel.setImage(largeImage, for: .normal)

        largeImage = UIImage(systemName: "stop.circle.fill", withConfiguration: largeConfig)
        recordButtonLabel.setImage(largeImage, for: .selected)

        // Play Button:
        largeImage = UIImage(systemName: "play.fill", withConfiguration: largeConfig)
        playButtonLabel.setImage(largeImage, for: .normal)

        largeImage = UIImage(systemName: "pause.fill", withConfiguration: largeConfig)
        playButtonLabel.setImage(largeImage, for: .selected)


        // Mic Button:
        largeImage = UIImage(systemName: "mic.fill", withConfiguration: largeConfig)
        micButtonLabel.setImage(largeImage, for: .normal)

        largeImage = UIImage(systemName: "mic.slash.fill", withConfiguration: largeConfig)
        micButtonLabel.setImage(largeImage, for: .selected)

        // Mic button initially disabled
        micButtonLabel.isEnabled = false
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }

    func playRecording() {
        var audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

//        var path = Bundle.main.url(forResource: "wrong-number", withExtension: "mp3")!
//        path = Bundle.main.url(forResource: "gong-sound", withExtension: "wav")!
//        path = Bundle.main.url(forResource: "e-note.short", withExtension: "wav")!
//        path = Bundle.main.url(forResource: "bike-bell", withExtension: "mp3")!
//        path = Bundle.main.url(forResource: "ring-tone", withExtension: "mp3")!
//        path = Bundle.main.url(forResource: "rooster", withExtension: "mp3")!
//        //        audioFilename = URL(fileURLWithPath: path)
//        audioFilename = path

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.play()
        } catch {
            // couldn't load file :(
        }
    }

    @objc func recordTapped() {
        if audioRecorder == nil {
            recordButtonLabel.isSelected = true
            startRecording()
        } else {
            finishRecording(success: true)
            recordButtonLabel.isSelected = false
        }
    }

}

extension ViewController: AVAudioRecorderDelegate {
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
        } else {
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}