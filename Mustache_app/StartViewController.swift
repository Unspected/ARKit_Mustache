//
//  StartViewController.swift
//  Mustache_app
//
//  Created by Pavel Andreev on 3/14/23.
//

import UIKit
import AVKit

var videoArray = [Video]()

class StartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let tableViewCellId = "videoCell"
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        let nibName = UINib(nibName: "VideoFileTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: tableViewCellId)
        videoArray = DataManager.shared.getVideos()
        tableView.reloadData()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.reloadData()
    }

}

extension StartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath) as! VideoFileTableViewCell
        let videoInfo = videoArray[indexPath.row]
        cell.setupCell(duration: videoInfo.duration, tagName: videoInfo.tag!)
        cell.backgroundColor = UIColor.gray
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectedVideo = videoArray[indexPath.row].url {

            let player = AVPlayer(url: selectedVideo)

            let playerViewController = AVPlayerViewController()
            playerViewController.player = player

            present(playerViewController, animated: true) {
                player.play()
            }
        }
        
        
    }
    
    
}
