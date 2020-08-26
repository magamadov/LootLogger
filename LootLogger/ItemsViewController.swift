//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by ZELIMKHAN MAGAMADOV on 28.06.2020.
//  Copyright © 2020 ZELIMKHAN MAGAMADOV. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
  
  var itemStore: ItemStore!
  var imageStore: ImageStore!
    
  
  // Главный вьев уже загрузился
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 65
  }
  
  // Главный вьев будет вот вот открыт
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    tableView.reloadData()
    // navBar.backButtonTitle = " "
  }
  
  // Акшин кнопки Add "+"
  
  @IBAction func addNewItem(_ sender: UIBarButtonItem) {
    let newItem = itemStore.createItem()
    
    if let index = itemStore.allItems.firstIndex(of: newItem) {
      let indexPath = IndexPath(row: index, section: 0)
      tableView.insertRows(at: [indexPath], with: .automatic)
    }
  }
  
  // Колличество строк в секции
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemStore.allItems.count
  }

  // Заполнение ячейки в строке
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
    let item = itemStore.allItems[indexPath.row]
        
    cell.nameLabel.text = item.name
    cell.valueLabel.text = String(item.valueInDollars)
    
    if item.valueInDollars > 50 {
      cell.valueLabel.textColor = .red
    } else {
      cell.valueLabel.textColor = .green
    }
    
    cell.seralNumber.text = item.serialNumber
    
    return cell
  }
  
  // Удаление ячейки
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    print("delete")
    
    if editingStyle == .delete {
      let item = itemStore.allItems[indexPath.row]
      itemStore.removeItem(item)
      imageStore.deleteImage(for: item.itemKey)
      tableView.deleteRows(at: [indexPath], with: .left)
    }
  }
  
  // Перемещение ячейки
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
  }
  
  // Настройка сеги для перехода в другой вьев контроллер
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
      case "showItem":
        if let row = tableView.indexPathForSelectedRow?.row {
          let item = itemStore.allItems[row]
          let detailedViewController = segue.destination as! DetailViewController
          detailedViewController.item = item
          detailedViewController.imageStore = imageStore
        }
      default:
        preconditionFailure("Unexpected segue id")
    }
  }
  
  // Добавление кнопки Edit в UINavigationBar
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    navigationItem.leftBarButtonItem = editButtonItem
    navigationItem.backBarButtonItem?.title = " "
  }
}
