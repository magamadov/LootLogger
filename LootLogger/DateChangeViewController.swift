//
//  DateChangeViewController.swift
//  LootLogger
//
//  Created by ZELIMKHAN MAGAMADOV on 23.07.2020.
//  Copyright © 2020 ZELIMKHAN MAGAMADOV. All rights reserved.
//

import UIKit

class DateChangeViewController: UIViewController {

  var item: Item!
  
  
  @IBOutlet var dataPicker: UIDatePicker!
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    dataPicker.date = item.dateCreated
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    item.dateCreated = dataPicker.date
  }
  
  
}
