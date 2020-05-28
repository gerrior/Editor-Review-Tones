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

    @IBOutlet private weak var listButtonLabel: UIButton!
    @IBOutlet private weak var recordButtonLabel: UIButton!
    @IBOutlet private weak var playButtonLabel: UIButton!
    @IBOutlet private weak var micButtonLabel: UIButton!

    @IBAction func recordButtonAction(_ sender: Any) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }

    @IBAction func playButtonAction(_ sender: Any) {
        playRecording()
    }

    @IBAction func clipButton(_ sender: Any) {
        print("Timestamp")
    }

    var recordButton: UIButton!
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

        // List Button: Increase size
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .large)
        var largeImage = UIImage(systemName: "list.bullet", withConfiguration: largeConfig)
        listButtonLabel.setImage(largeImage, for: .normal)

        // Record Button:
        largeImage = UIImage(systemName: "mic.circle.fill", withConfiguration: largeConfig)
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

    func loadRecordingUI() {
        recordButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64))
        recordButton.backgroundColor = .green
        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
// FIXME:        view.addSubview(recordButton)
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

            recordButtonLabel.setTitle("Tap to Stop", for: .normal)
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }

    func playRecording() {
        var audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        var path = Bundle.main.url(forResource: "wrong-number", withExtension: "mp3")!
        path = Bundle.main.url(forResource: "gong-sound", withExtension: "wav")!
        path = Bundle.main.url(forResource: "e-note.short", withExtension: "wav")!
        path = Bundle.main.url(forResource: "bike-bell", withExtension: "mp3")!
        path = Bundle.main.url(forResource: "ring-tone", withExtension: "mp3")!
        path = Bundle.main.url(forResource: "rooster", withExtension: "mp3")!
        //        audioFilename = URL(fileURLWithPath: path)
        audioFilename = path

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.play()
        } catch {
            // couldn't load file :(
        }
    }

    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }

}

extension ViewController: AVAudioRecorderDelegate {
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            recordButtonLabel.setTitle("Tap to Re-record", for: .normal)
            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordButtonLabel.setTitle("Tap to Record", for: .normal)
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
