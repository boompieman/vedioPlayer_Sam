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
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    var isPlaying: Bool = false
    var isRotated: Bool = false
    @IBOutlet weak var fullScreenButton: UIButton!


    var timeObserver: Any!

    @IBOutlet weak var fastFowardButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var avPlayerView: UIView!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    var player: AVPlayer!

    var playerLayer: AVPlayerLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setUpImageButton()

        view.backgroundColor = UIColor.white
        self.title = "Video Player"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]



        NotificationCenter.default.addObserver(self, selector: #selector(self.screenDidRotate(note:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }


    func setUpImageButton() {

        let voiceOnImage = UIImage(named: "volume_up")?.withRenderingMode(.alwaysTemplate)
        self.voiceButton.setImage(voiceOnImage, for: .normal)

        let rewindImage = UIImage(named: "rewind")?.withRenderingMode(.alwaysTemplate)
        self.rewindButton.setImage(rewindImage, for: .normal)

        let playImage = UIImage(named:"play_button")?.withRenderingMode(.alwaysTemplate)
        self.playButton.setImage(playImage, for: .normal)

        let fastForwardImage = UIImage(named:"fast_forward")?.withRenderingMode(.alwaysTemplate)
        self.fastFowardButton.setImage(fastForwardImage, for: .normal)


        let fullScreenImage = UIImage(named: "full_screen_button")?.withRenderingMode(.alwaysTemplate)
        self.fullScreenButton.setImage(fullScreenImage, for: .normal)
    }

    func changeButtonColorToBlack() {
        self.voiceButton.tintColor = UIColor.black
        self.rewindButton.tintColor = UIColor.black
        self.playButton.tintColor = UIColor.black
        self.fastFowardButton.tintColor = UIColor.black
        self.fullScreenButton.tintColor = UIColor.black
        currentTimeLabel.textColor = UIColor.black
        endTimeLabel.textColor = UIColor.black
    }

    func changeButtonColorToWhite() {
        self.voiceButton.tintColor = UIColor.white
        self.rewindButton.tintColor = UIColor.white
        self.playButton.tintColor = UIColor.white
        self.fastFowardButton.tintColor = UIColor.white
        self.fullScreenButton.tintColor = UIColor.white
        currentTimeLabel.textColor = UIColor.white
        endTimeLabel.textColor = UIColor.white
    }


    @objc fileprivate func screenDidRotate(note : Notification) {


        if (player != nil) {
            let orientation = UIDevice.current.orientation
            switch orientation {
            case .portrait:
                print("portrait")

                let fullScreenImage = UIImage(named: "full_screen_button")?.withRenderingMode(.alwaysTemplate)
                fullScreenButton.setImage(fullScreenImage, for: .normal)
                rotateToPortrait()
                break
            case .portraitUpsideDown:
                break
            case .landscapeLeft:
                let fullScreenExitImage = UIImage(named: "full_screen_exit")?.withRenderingMode(.alwaysTemplate)
                fullScreenButton.setImage(fullScreenExitImage, for: .normal)
                rotateToLandscapeLeft()
            case .landscapeRight:

                let fullScreenExitImage = UIImage(named: "full_screen_exit")?.withRenderingMode(.alwaysTemplate)
                fullScreenButton.setImage(fullScreenExitImage, for: .normal)
                rotateToLandscapeRight()
            default:
                break
            }
        }
    }
    func rotateToLandscapeRight() {

        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width

        print("sss",UIScreen.main.bounds)

        UIView.animate(withDuration: 0.4, animations: {



            self.avPlayerView.frame = CGRect(x: 0, y: (height - ((9 * width) / 16)) / 2, width: width, height: (9 * width) / 16)
            self.playerLayer.frame = self.avPlayerView.frame
        })

        self.changeButtonColorToWhite()

        UIApplication.shared.isStatusBarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.searchTextField.isHidden = true
        self.searchButton.isHidden = true

    }

    func rotateToPortrait() {

        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height

        UIView.animate(withDuration: 0.4, animations: {
            self.avPlayerView.frame = CGRect(x: 0, y: (height - ((9 * width) / 16)) / 2, width: width, height: (9 * width) / 16)
            self.playerLayer.frame = self.avPlayerView.bounds
        })

        self.changeButtonColorToBlack()
        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.isNavigationBarHidden = false
        self.searchTextField.isHidden = false
        self.searchButton.isHidden = false
    }

    func rotateToLandscapeLeft() {


        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width

            UIView.animate(withDuration: 0.4, animations: {
                self.avPlayerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                self.playerLayer.frame = self.avPlayerView.frame
            })

        self.changeButtonColorToWhite()

        UIApplication.shared.isStatusBarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.searchTextField.isHidden = true
        self.searchButton.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playButtonPressed(_ sender: Any) {

        if (player != nil) {
            if (isPlaying) {
                let playImage = UIImage(named:"play_button")?.withRenderingMode(.alwaysTemplate)
                self.playButton.setImage(playImage, for: .normal)
                isPlaying = false
                print(isPlaying)
                player.pause()
            }
            else {
                let stopImage = UIImage(named:"stop")?.withRenderingMode(.alwaysTemplate)
                self.playButton.setImage(stopImage, for: .normal)
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

        guard !(seconds.isNaN || seconds.isInfinite) else {
            return "00:00" // or do some error handling
        }

        let min = Int(seconds / 60)

        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))

        return String(format: "%02i:%02i", min, sec)
    }

    func addProgressObserver() {
        self.timeObserver = self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(Int64(1.0), Int32(1.0)), queue: DispatchQueue.main, using: { (time) in
            var current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds((self.player.currentItem?.duration)!)

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

                let voiceOnImage = UIImage(named: "volume_up")?.withRenderingMode(.alwaysTemplate)
                self.voiceButton.setImage(voiceOnImage, for: .normal)
                self.player.isMuted = false
            }

            else {
                let voiceOffImage = UIImage(named: "volume_off")?.withRenderingMode(.alwaysTemplate)
                self.voiceButton.setImage(voiceOffImage, for: .normal)
                self.player.isMuted = true
            }
        }
    }
    @IBAction func changeVideoTime(_ sender: Any) {

        let totalTime = CMTimeGetSeconds((self.player.currentItem?.duration)!)

        var newTime = totalTime * Float64(self.progressSlider.value)

        let time2 = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)

        player.seek(to: time2, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }



    @IBAction func fullScreenButtonPressed(_ sender: Any) {

        if self.player != nil {

            if (isRotated) {
                let value = UIInterfaceOrientation.portrait.rawValue

                UIDevice.current.setValue(value, forKey: "orientation")
                isRotated = false
            }

            else {

                let value = UIInterfaceOrientation.landscapeLeft.rawValue

                UIDevice.current.setValue(value, forKey: "orientation")
                isRotated = true
            }
        }
    }

    @IBAction func searchButtonPressed(_ sender: Any) {

        if player != nil {
            self.player.pause()
            self.player.removeTimeObserver(self.timeObserver)
        }

        guard let urlString = self.searchTextField.text else {
            return
        }

        guard let videoURL = URL(string: urlString) else {
            return
        }
//        let videoURL = URL(string: "https://s3-ap-northeast-1.amazonaws.com/mid-exam/Video/taeyeon.mp4")
        let playerItem = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)

//        let playerWidth = self.view.bounds.width
//        let playerHeight = 9 * playerWidth / 16

        playerLayer.frame = self.avPlayerView.bounds


        self.avPlayerView.layer.addSublayer(playerLayer)

        addProgressObserver()

        //ready to play
        player.play()

        let stopImage = UIImage(named:"stop")?.withRenderingMode(.alwaysTemplate)
        self.playButton.setImage(stopImage, for: .normal)
        self.isPlaying = true


        print(self.searchTextField.text)
    }

}

