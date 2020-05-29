//
//  RecordViewController.swift
//  Editor Review Tones
//
//  Created by Mark Gerrior on 5/26/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {

    // MARK: - Properites

    let clipController = ClipController()
    var clip: Clip?

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?

    // MARK: - Outlets

    @IBOutlet private weak var listButtonLabel: UIButton!
    @IBOutlet private weak var recordButtonLabel: UIButton!
    @IBOutlet private weak var playButtonLabel: UIButton!
    @IBOutlet private weak var micButtonLabel: UIButton!

    @IBOutlet private weak var eventOneButtonLable: UIButton!
    @IBOutlet private weak var eventTwoButtonLable: UIButton!
    @IBOutlet private weak var eventThreeButtonLable: UIButton!
    @IBOutlet private weak var eventFourButtonLable: UIButton!

    // MARK: - Actions

    @IBAction func recordButtonAction(_ sender: Any) {
        recordTapped()
    }

    @IBAction func playButtonAction(_ sender: Any) {
        playRecording()
    }

    @IBAction func eventButton(_ sender: UIButton) {
        let eventName = sender.titleLabel?.text ?? "Unknown Event"

        if let clip = clip {
            clipController.create(eventWithName: eventName, clip: clip)
        } else {
            print("Event: \(eventName) - No clip, throw bits on the floor.")
        }
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Location of *.sqlite database:")
        print(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last! as String)

        print("Location of audio clips:")
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

    // MARK: - Private

    private func loadRecordingUI() {
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
        micButtonLabel.isHidden = true // TODO: Not needed at the moment so hiding
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func startRecording() {
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

    private func playRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

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
            let now = Date()
            let df = DateFormatter()
            df.dateStyle = .short
            df.timeStyle = .short
            let date = df.string(from: now)

            clip = clipController.create(clipWithTitle: "Clip from \(date)", startTimestamp: now, audioFile: nil)

            recordButtonLabel.isSelected = true
            startRecording()
        } else {
            finishRecording(success: true)
            recordButtonLabel.isSelected = false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClipSegue" {
            guard let vc = segue.destination as? ClipsTableViewController else { return }

            vc.clipController = clipController
            vc.clip = clip
            clip = nil
        }
    }
}

extension RecordViewController: AVAudioRecorderDelegate {
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
