//
//  ViewController.swift
//  Mustache_app
//
//  Created by Pavel Andreev on 3/10/23.
//

import UIKit
import RealityKit
import ARKit
import AVFoundation
import CoreData
import SCNRecorder


class ViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet weak var stopRecordButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!

    @IBOutlet weak var arView: ARView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let faceTrackingConfig = ARFaceTrackingConfiguration()
    
    var mustacheList: Array<HasAnchoring> = []
    
    var currentAnchor: HasAnchoring?
    
    var mustacheImages: [UIImage] = [#imageLiteral(resourceName: "mustache1"), #imageLiteral(resourceName: "mustache2"), #imageLiteral(resourceName: "mustache3"), #imageLiteral(resourceName: "mustache4")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        faceTrackingConfig.providesAudioData = true
        arView.prepareForRecording()
    
        collectionView.delegate = self
        collectionView.dataSource = self
        arView.session.delegate = self
        
        collectionView.register(MustacheCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        let mustache1 = try! MustacheImage1.loadScene()
        let mustache2 = try! MustacheImage2.loadScene()
        let mustache3 = try! MustacheImage3.loadScene()
        let mustache4 = try! MustacheImage4.loadScene()
        
        mustacheList.append(mustache1)
        mustacheList.append(mustache2)
        mustacheList.append(mustache3)
        mustacheList.append(mustache4)
        
        recordButton.addTarget(self, action: #selector(recordButtonPressed), for: .touchUpInside)
        stopRecordButton.addTarget(self, action: #selector(stopRecordButtonPressed), for: .touchUpInside)
        
        arView.session.run(faceTrackingConfig)
        currentAnchor = mustacheList[0].anchor
        arView.scene.anchors.append(mustacheList[0])
        stopRecordButton.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    
    
    
    @objc func recordButtonPressed() {
        collectionView.isHidden = true
        recordButton.isHidden = true
        stopRecordButton.isHidden = false
        startRecording()
    }
    
    
    @objc func stopRecordButtonPressed() {
        stopRecording()
        stopRecordButton.isHidden = true
        recordButton.isHidden = false
    }
    
  

    // Button Functionality
    func startRecording() {
        try! arView.startVideoRecording()
        print("SUCCESS RECORDING")
   
    }
        
    func stopRecording() {
        
        var videoData: VideoRecording.Info?
        arView.finishVideoRecording { videoFile in
            videoData = videoFile
        }
        
        let alertController = UIAlertController(title: "Record is finished", message: "Create name for your video", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "tag name"
        }
        let alertAction = UIAlertAction(title: "Save", style: .default) { alert in
            guard let saveText = alertController.textFields?.first?.text else { return }
            
            guard let saveVideoData = videoData else { return }
            
            let newVideo = DataManager.shared.saveVideo(url: saveVideoData.url,
                                                        duration: saveVideoData.duration,
                                                        tag: saveText)
            videoArray.append(newVideo)
            DataManager.shared.save()
            self.dismiss(animated: true)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
                                     
                                    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mustacheList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MustacheCollectionViewCell
        
        cell.imageContainer.image = mustacheImages[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        guard let saveAnchor = currentAnchor else { return }
        arView.scene.removeAnchor(saveAnchor)
        
        let selectedMustache = mustacheList[indexPath.row]
        arView.scene.addAnchor(selectedMustache)
        
        self.currentAnchor = selectedMustache.anchor
    }
    
}

