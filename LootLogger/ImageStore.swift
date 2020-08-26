//
//  ImageStore.swift
//  LootLogger
//
//  Created by ZELIMKHAN MAGAMADOV on 28.07.2020.
//  Copyright © 2020 ZELIMKHAN MAGAMADOV. All rights reserved.
//

import UIKit

class ImageStore {
  
  let cache = NSCache<NSString, UIImage>()
  
  func setImage(_ image: UIImage, forKey key: String) {
    cache.setObject(image, forKey: key as NSString)
    let url = imageURL(for: key)
    
    if let data = image.jpegData(compressionQuality: 0.5) {
      try? data.write(to: url)
    }
  }
  
  func image(forKey key: String) -> UIImage? {
    if let existingImage = cache.object(forKey: key as NSString) {
      return existingImage
    }
    
    let url = imageURL(for: key)
    
    guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
      return nil
    }
    
    cache.setObject(imageFromDisk, forKey: key as NSString)
    return imageFromDisk
  }
  
  func deleteImage(for key: String) {
    cache.removeObject(forKey: key as NSString)
    
    let url = imageURL(for: key)
    do {
      try FileManager.default.removeItem(at: url)
    } catch {
      print("Error removing the image from disk: \(error)")
    }
  }

  func imageURL(for key: String) -> URL {
    let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = documentsDirectories.first!
    return documentDirectory.appendingPathComponent(key)
  }
}
