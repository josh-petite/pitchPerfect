//
//  SelectSoundFilterViewController.swift
//  Pitch Perfect
//
//  Created by Josh Petite on 5/11/15.
//  Copyright (c) 2015 Josh Petite. All rights reserved.
//

import UIKit
import AVFoundation

class SelectSoundFilterViewController: UIViewController {
    var receivedAudio: RecordedAudio!
    var engine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine = AVAudioEngine()
        
        if (receivedAudio != nil) {
            audioFile = AVAudioFile(forReading: receivedAudio.getUrl(), error: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        stopEngine()
    }
    
    @IBAction func playSlowAudio() {
        executeRatePitchAwarePlayback(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        executeRatePitchAwarePlayback(2.0)
    }
    @IBAction func playChipmunkFilteredAudio(sender: UIButton) {
        executeRatePitchAwarePlayback(1.0, pitch: 1200.0)
    }
    
    @IBAction func playVaderFilteredAudio(sender: UIButton) {
        executeRatePitchAwarePlayback(1.0, pitch: -500.0)
    }
    
    @IBAction func playEchoFilteredAudio(sender: UIButton) {
        executeEchoedPlayback()
    }
    
    @IBAction func playReverbFilteredAudio(sender: UIButton) {
        executeReverbPlayback()
    }
    
    @IBAction func playDistortionFilteredAudio(sender: UIButton) {
        executeDistoredPlayback()
    }
    
    func stopEngine() {
        engine.stop()
        engine.reset()
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        stopEngine()
    }
    
    func executeDistoredPlayback() {
        stopEngine()
        
        var audioPlayer = AVAudioPlayerNode()
        audioPlayer.volume = 1.0;
        engine.attachNode(audioPlayer)
        
        var distortion = AVAudioUnitDistortion()
        distortion.wetDryMix = 50
        distortion.preGain = 0
        engine.attachNode(distortion)
        
        engine.connect(audioPlayer, to: distortion, format: nil)
        engine.connect(distortion, to: engine.outputNode, format: nil)
        
        audioPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        engine.startAndReturnError(nil)
        audioPlayer.play()
    }
    
    func executeEchoedPlayback() {
        stopEngine()

//        var audioPlayer = AVAudioPlayer(contentsOfURL: audioFile.url, error: nil)
//        
//        var audioPlayer2 = AVAudioPlayer(contentsOfURL: audioFile.url, error: nil)
//        
//        audioPlayer.prepareToPlay()
//        audioPlayer.play()
//        
//        audioPlayer2.prepareToPlay()
//        audioPlayer2.playAtTime(audioPlayer.deviceCurrentTime + 0.1)
    }
    
    func executeReverbPlayback() {
        stopEngine()
        
        var audioPlayer = AVAudioPlayerNode()
        audioPlayer.volume = 1.0;
        engine.attachNode(audioPlayer)
        
        var reverb = AVAudioUnitReverb()
        reverb.wetDryMix = 50
        engine.attachNode(reverb)
        
        engine.connect(audioPlayer, to: reverb, format: nil)
        engine.connect(reverb, to: engine.outputNode, format: nil)
        
        audioPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        engine.startAndReturnError(nil)
        audioPlayer.play()
    }
    
    func executeRatePitchAwarePlayback(rate: Float, pitch: Float = 1.0) {
        stopEngine()
        
        var audioPlayer = AVAudioPlayerNode()
        audioPlayer.volume = 1.0;
        engine.attachNode(audioPlayer)
        
        var unitTimePitch = AVAudioUnitTimePitch()
        unitTimePitch.rate = rate
        unitTimePitch.pitch = pitch
        engine.attachNode(unitTimePitch)
        
        engine.connect(audioPlayer, to: unitTimePitch, format: nil)
        engine.connect(unitTimePitch, to: engine.outputNode, format: nil)
        
        audioPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        engine.startAndReturnError(nil)
        audioPlayer.play()
    }
}
