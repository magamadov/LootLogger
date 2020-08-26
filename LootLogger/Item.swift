//
//  Item.swift
//  LootLogger
//
//  Created by ZELIMKHAN MAGAMADOV on 28.06.2020.
//  Copyright © 2020 ZELIMKHAN MAGAMADOV. All rights reserved.
//

import UIKit

class Item: Codable {
  var name: String
  var valueInDollars: Int
  var serialNumber: String?
  var dateCreated: Date
  let itemKey: String
  
  init(name: String, valueInDollars: Int, serialNumber: String?) {
    self.name = name
    self.valueInDollars = valueInDollars
    self.serialNumber = serialNumber
    self.dateCreated = Date()
    self.itemKey = UUID().uuidString
  }
  
  convenience init(random: Bool = false) {
    if random {
      let adjectives = ["Fluffy", "Rusty", "Shiny"]
      let nouns = ["Bear", "Spork", "Mac"]
      
      let randomAdjective = adjectives.randomElement()!
      let randomNoun = nouns.randomElement()!
      
      let randomName = "\(randomAdjective) \(randomNoun)"
      let randomValue = Int.random(in: 1..<100)
      let randomSerialNumber = UUID().uuidString.components(separatedBy: "-").first!
      
      self.init(name: randomName, valueInDollars: randomValue, serialNumber: randomSerialNumber)
    } else {
      self.init(name: "", valueInDollars: 0, serialNumber: nil)
    }
  }
}

extension Item: Equatable {
  static func == (lhs: Item, rhs: Item) -> Bool {
    return lhs.name == rhs.name
      && lhs.dateCreated == rhs.dateCreated
      && lhs.serialNumber == rhs.serialNumber
      && lhs.valueInDollars == rhs.valueInDollars
  }
}

