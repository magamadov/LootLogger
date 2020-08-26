//
//  DetailViewController.swift
//  LootLogger
//
//  Created by ZELIMKHAN MAGAMADOV on 10.07.2020.
//  Copyright © 2020 ZELIMKHAN MAGAMADOV. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet var nameField: UITextField!
  @IBOutlet var serialField: UITextField!
  @IBOutlet var valueField: UITextField!
  @IBOutlet var dataLabel: UILabel!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var deletePhoto: UIBarButtonItem!
  
  var item: Item! {
    didSet {
      navigationItem.title = item.name
    }
  }
  
  var imageStore: ImageStore!
  
  let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }()
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
  }()  
  
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    print("вьюха появилась")
    
    nameField.text = item.name
    serialField.text = item.serialNumber
    valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
    dataLabel.text = dateFormatter.string(from: item.dateCreated)
    
    let key = item.itemKey
    let imageToDisplay = imageStore.image(forKey: key)
    //imageView.contentMode = .scaleAspectFit
    imageView.image = imageToDisplay
    
    deletePhoto.isEnabled = (imageView.image != nil) ? true : false
    
    print(UITraitCollection.current.userInterfaceStyle)
    
    //"\(item.dateCreated)"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //nameField.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    
    print("вьюха закрылась")
    
    // Убрать клавиатуру перед закрытием View
    
    view.endEditing(true)
    
    // Сохранение введенных данных пользователем
    
    item.name = nameField.text ?? "No item"
    item.serialNumber = serialField.text
    
    if let valueText = valueField.text,
       let value = numberFormatter.number(from: valueText) {
      item.valueInDollars = value.intValue
    } else {
      item.valueInDollars = 0
    }
  }
  
  @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  deinit {
    print("обьект уничтожен")
  }
  
  //MARK: Настройка перехода через сегу
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
      case "changeDate":
        let changeDateViewController = segue.destination as! DateChangeViewController
        changeDateViewController.item = item
      default:
        preconditionFailure("wrong segue id")
    }
  }
  
  
  
  
  @IBAction func choosePhotoSource(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
        let imagePicker = self.imagePicker(for: .camera)
        self.present(imagePicker, animated: true, completion: nil)
        print("Camera")
      }
      alertController.addAction(cameraAction)
    } else {
      let camerNotEnable = UIAlertAction(title: "You not have camera", style: .default, handler: nil)
      camerNotEnable.isEnabled = false
      alertController.addAction(camerNotEnable)
    }
    
    
    let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { _ in
      let imagePicker = self.imagePicker(for: .photoLibrary)
      imagePicker.modalPresentationStyle = .popover
      imagePicker.popoverPresentationController?.barButtonItem = sender
      self.present(imagePicker, animated: true, completion: nil)
      print("Photo Library")
    }
    
    alertController.addAction(photoLibrary)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    //    let destructiveCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    //    alertController.addAction(destructiveCancel)
    
    alertController.modalPresentationStyle = .popover
    alertController.popoverPresentationController?.barButtonItem = sender
    
    present(alertController, animated: true, completion: nil)
  }
  
  
  
  func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = sourceType
    imagePicker.allowsEditing = true
    imagePicker.delegate = self
    return imagePicker
  }
  
  @IBAction func deletePhoto(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: "Delete photo", message: "Do you want delete photo?", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "No!", style: .default, handler: nil)
    
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
      self.imageStore.deleteImage(for: self.item.itemKey)
      self.imageView.image = nil
      self.deletePhoto.isEnabled = false
    }
    
    alertController.addAction(cancelAction)
    alertController.addAction(deleteAction)
    self.present(alertController, animated: true, completion: nil)
  }
}

// MARK: - Extensions

// MARK: Скрывать клавиатуру по нажатию кнопки Return на клавиатуре

extension DetailViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    print("скрыли клавиатуру")
    return true
  }
}

extension DetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let editedImage = info[.editedImage] as? UIImage {
      imageStore.setImage(editedImage, forKey: item.itemKey)
      imageView.image = editedImage
    } else if let originalImage = info[.originalImage] as? UIImage {
      imageStore.setImage(originalImage, forKey: item.itemKey)
      imageView.image = originalImage
    }
    deletePhoto.isEnabled = true
    dismiss(animated: true, completion: nil)
  }
}

class MyButton: UIButton {
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    backgroundColor = .black
    setTitleColor(.white, for: .normal)
    titleLabel?.font = .boldSystemFont(ofSize: 16)
    layer.cornerRadius = frame.height / 2
  }
}
