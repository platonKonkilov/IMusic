//
//  TrackDetailView.swift
//  IMusic
//
//  Created by Платон Конкилов on 11.04.2020.
//  Copyright © 2020 Платон Конкилов. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

protocol TrackMovingDelegate: class {
    func moveBackFoPreviousTrack() -> SearchViewModel.Cell?
    func moveForwardFoPreviousTrack() -> SearchViewModel.Cell?
}

class TrackDetailView: UIView {
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var authorTitle: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var maximazedTrackView: UIStackView!
    
    @IBOutlet weak var mimTrackView: UIView!
    @IBOutlet weak var miniGoforwardButton: UIView!
    @IBOutlet weak var miniTrackTitleLabel: UILabel!
    @IBOutlet weak var miniTrackImageView: UIImageView!
    @IBOutlet weak var miniPlayPauseButton: UIButton!
    
    
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    
    weak var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageView.layer.cornerRadius = 5
    }
    // MARK: - Setup
    func set(viewModel: SearchViewModel.Cell) {
        
        miniTrackTitleLabel.text = viewModel.trackName
        
        trackTitle.text = viewModel.trackName
        authorTitle.text = viewModel.artistName
        playTack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        oservePlayerCurrentTime()
        playPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        
        trackImageView.sd_setImage(with: url, completed: nil)
        miniTrackImageView.sd_setImage(with: url, completed: nil)
        
    }
    
    private func playTack(previewUrl: String?) {
        print("пытаюсь включить трек по ссылке: \(previewUrl ?? "отсутствует")")
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    // MARK: - Time setup
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackImageView()
        }
    }
    
    private func oservePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            let currentDurationTimeText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.durationLabel.text = "-\(currentDurationTimeText)"
            self?.updateCurrentTimeSleder()
        }
    }
    
    private func updateCurrentTimeSleder() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentSlider.value = Float(percentage)
        
    }
    // MARK: - Animation
    
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.trackImageView.transform = .identity
        }, completion: nil)
    }
    
    private func reduceTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let scale: CGFloat = 0.8
            self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    
    // MARK: - @IBAction
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        let percentage = Float64(currentSlider.value)
        guard let duration = player.currentItem?.duration  else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeSeconds = percentage * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        self.tabBarDelegate?.minimizedTrackDetailController()
//        self.removeFromSuperview()
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func reviousTrack(_ sender: Any) {
        let cellViewModel = delegate?.moveBackFoPreviousTrack()
        guard let cellInFo = cellViewModel else { return }
        self.set(viewModel: cellInFo)
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        let cellViewModel = delegate?.moveForwardFoPreviousTrack()
        guard let cellInFo = cellViewModel else { return }
        self.set(viewModel: cellInFo)
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            enlargeTrackImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "Play Button"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "Play Button"), for: .normal)
            reduceTrackImageView()
//            playPauseButton.tintColor = #colorLiteral(red: 1, green: 0.3137254902, blue: 0.4117647059, alpha: 1)
        }
    }
}
