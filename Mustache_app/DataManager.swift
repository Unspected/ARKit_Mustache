//
//  DataManager.swift
//  Mustache_app
//
//  Created by Pavel Andreev on 3/14/23.
//

import Foundation
import CoreData
import UIKit

class DataManager {
    static let shared = DataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveVideo(url: URL, duration: Double, tag: String) -> Video {
        let video = Video(context: persistentContainer.viewContext)
        video.url = url
        video.duration = duration
        video.tag = tag
        video.timestamp = Date()
        return video
       }
    
    
    func getVideos() -> [Video] {
           let request: NSFetchRequest<Video> = Video.fetchRequest()
           var fetchedSingers: [Video] = []
           
           do {
               fetchedSingers = try persistentContainer.viewContext.fetch(request)
           } catch let error {
               print("Error fetching videos \(error)")
           }
           return fetchedSingers
       }
    
  func save () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
          try context.save()
      } catch {
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
    
}
