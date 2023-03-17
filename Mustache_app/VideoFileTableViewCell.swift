//
//  VideoFileTableViewCell.swift
//  Mustache_app
//
//  Created by Pavel Andreev on 3/16/23.
//

import UIKit
import AVFoundation
import AssetsLibrary



class VideoFileTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageViewSection: UIImageView!
    
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
   
    @IBOutlet weak var playVideoButton: UIButton!
    
    var currentURL: URL?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    
    }
    
    func setupCell(duration: Double, tagName: String) {
        durationLabel.text = "duration: \(NSString(format: "%.1f", duration))"
        tagLabel.text = "tag: \(tagName)"
        
    }

    func getFilePath(completion: @escaping(URL) -> Void ) {
        if let saveURL = currentURL {
            completion(saveURL)
        }
        
    }
    
    
    
}
