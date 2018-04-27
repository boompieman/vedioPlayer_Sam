//
//  ViewController.swift
//  vedioPlayer_Sam
//
//  Created by MACBOOK on 2018/4/27.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import UIKit
import Foundation
import AVKit


class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    var isPlaying: Bool = false
    var isVolumeOn: Bool = true

    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    var player: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        view.backgroundColor = UIColor.white
        self.title = "Video Player"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playButtonPressed(_ sender: Any) {

        if (player != nil) {
            if (isPlaying) {
                self.playButton.setImage(UIImage(named: "stop"), for: .normal)
                isPlaying = false
                print(isPlaying)
                player.pause()
            }
            else {
                self.playButton.setImage(UIImage(named: "play_button"), for: .normal)
                isPlaying = true
                print(isPlaying)
                player.play()
            }
        }
    }

    @IBAction func fastForwardPressed(_ sender: Any) {

        if (player != nil) {

            let seekDuration: Float64 = 5
            guard let duration  = self.player.currentItem?.duration else{
                return
            }

            let currentTime = CMTimeGetSeconds(player.currentTime())
            let newTime  = currentTime + seekDuration

            if newTime < (CMTimeGetSeconds(duration) - seekDuration) {

                let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
                player.seek(to: time2, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            }
        }
    }

    @IBAction func rewindPressed(_ sender: Any) {

        if (player != nil) {
            let seekDuration: Float64 = 5
            let currentTime = CMTimeGetSeconds(player.currentTime())
            var newTime = currentTime - seekDuration

            if newTime < 0 {
                newTime = 0
            }

            let time2 = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
            player.seek(to: time2, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }

    func transferSecondsToMMSS(seconds: Float64) -> String {
        let min = Int(seconds / 60)

        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))

        return String(format: "%02i:%02i", min, sec)
    }

    func addProgressObserver() {
        self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(Int64(1.0), Int32(1.0)), queue: DispatchQueue.main, using: { (time) in
            var current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds((self.player.currentItem?.duration)!)

            

            print("已經播放\(current) seconds")

            self.currentTimeLabel.text = self.transferSecondsToMMSS(seconds: current)
            self.endTimeLabel.text = self.transferSecondsToMMSS(seconds: total)

            if (current != nil) {
                self.progressSlider.setValue(Float(current / total), animated: true)
            }
        })
    }

    @IBAction func voiceButtonPressed(_ sender: Any) {


        if self.player != nil {

            if (self.player.isMuted) {
                self.voiceButton.setImage(UIImage(named: "volume_up"), for: .normal)
                self.player.isMuted = false
            }

            else {
                self.voiceButton.setImage(UIImage(named: "volume_off"), for: .normal)
                self.player.isMuted = true
            }
        }
    }

    @IBAction func searchButtonPressed(_ sender: Any) {
//        let videoURL = URL(string: self.searchTextField.text)
        let videoURL = URL(string: "https://s3-ap-northeast-1.amazonaws.com/mid-exam/Video/taeyeon.mp4")
        let playerItem = AVPlayerItem(url: videoURL!)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)

        let playerWidth = self.view.bounds.width
        let playerHeight = 9 * playerWidth / 16

        playerLayer.frame = CGRect(x: 0, y: (self.view.bounds.height - playerHeight) / 2 , width: playerWidth, height: playerHeight)
        self.view.layer.addSublayer(playerLayer)

        addProgressObserver()
        player.play()
        self.isPlaying = true


        print(self.searchTextField.text)
    }

}

