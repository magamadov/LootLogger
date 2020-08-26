//
//  ItemStore.swift
//  LootLogger
//
//  Created by ZELIMKHAN MAGAMADOV on 29.06.2020.
//  Copyright © 2020 ZELIMKHAN MAGAMADOV. All rights reserved.
//

import UIKit

class ItemStore {
  var allItems = [Item]()
  
  let itemArchiveURL: URL = {
    let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = documentsDirectories.first!
    return documentDirectory.appendingPathComponent("items.plist")
  }()
  
  @discardableResult func createItem() -> Item {
    let newItem = Item(random: true)
    allItems.append(newItem)
    return newItem
  }
  
  func removeItem(_ item: Item) {
    if let index = allItems.firstIndex(of: item) {
      allItems.remove(at: index)
    }
  }
  
  func moveItem(from fromIndex: Int, to toIndex: Int) {
    if fromIndex == toIndex {
      print("Фром и ту одинаковы!")
      return
    }
    let movedItem = allItems.remove(at: fromIndex)
    allItems.insert(movedItem, at: toIndex)
  }
  
  @objc func saveChanges() throws {
    
    print("Saving to: \(itemArchiveURL)")
    
    do {
      let encoder = PropertyListEncoder()
      let data = try encoder.encode(allItems)
      try data.write(to: itemArchiveURL, options: .atomic)
      print("save data!")
    } catch let encodingError {
      print("Error: \(encodingError)")
      throw encodingError
    }
  }
  
  init() {
    do {
      let data = try Data(contentsOf: itemArchiveURL)
      let unarchiver = PropertyListDecoder()
      let items = try unarchiver.decode([Item].self, from: data)
      allItems = items
    } catch {
      print("что то пошло не так! А именно: \(error)")
    }
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didDisconnectNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
  }
}

