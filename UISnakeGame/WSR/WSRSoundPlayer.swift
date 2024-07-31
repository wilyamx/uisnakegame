//
//  WSRSound.swift
//  UISnakeGame
//
//  Created by William Rena on 7/27/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import AVFoundation

class WSRSoundPlayer {
    struct WSRSound {
        let fileName: String
        let fileExtension: String

        init(name: String, withExtension fileExtension: String) {
            self.fileName = name
            self.fileExtension = fileExtension
        }

        var url: URL? {
            return Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        }
    }

    private var sound: WSRSound
    private var audioPlayer: AVAudioPlayer?
    private var enabled: Bool

    init(sound: WSRSound, enabled: Bool = true, numberOfLoops: Int = 0) {
        self.sound = sound
        self.enabled = enabled

        self.audioPlayer = try! AVAudioPlayer(contentsOf: sound.url!)
        self.audioPlayer?.numberOfLoops = numberOfLoops
    }

    func play() {
        guard enabled else { return }

        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }

    func stop() {
        audioPlayer?.stop()
    }
}
