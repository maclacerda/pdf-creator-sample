//
//  ViewController.swift
//  PDFCreatorSample
//
//  Created by Marcos Lacerda on 30/08/19.
//  Copyright © 2019 Marcos Lacerda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak fileprivate var titleField: UITextField!
  @IBOutlet weak fileprivate var bodyField: UITextView!
  @IBOutlet weak fileprivate var contactInfoField: UITextField!
  @IBOutlet weak fileprivate var imagePreview: UIImageView!
  
  fileprivate var imagePicked: UIImage?
  fileprivate let imagePicker = UIImagePickerController()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Custom PDF Builder"
    
    // Add border to body field
    bodyField.layer.borderColor = UIColor.systemGroupedBackground.cgColor
    bodyField.layer.borderWidth = 2.0
    bodyField.layer.cornerRadius = 10
    bodyField.layer.masksToBounds = true
    
    // Config image picker
    imagePicker.delegate = self
    imagePicker.sourceType = .photoLibrary
  }
  
  @IBAction fileprivate func previewPDFClick() {
    // Force the keyboard hide
    self.view.endEditing(true)
    
    // Verify if all information provide
    guard let _ = self.titleField.text, let _ = bodyField.text, let _ = contactInfoField.text, let _ = imagePicked else {
      self.showError()
      return
    }
    
    // Create a PDF creator object
    let creator = PDFCreator(title: titleField.text!, body: bodyField.text!, image: imagePicked!, info: contactInfoField.text!)

    // Generate PDF data representation
    let data = creator.createPDF()

    // Show the prview
    let viewerController = PDFPreviewViewController()
    viewerController.pdfData = data

    self.navigationController?.pushViewController(viewerController, animated: true)
  }

  @IBAction fileprivate func sharePDFClick() {
    // Verify if all information provide
    guard let title = self.titleField.text, let body = bodyField.text, let info = contactInfoField.text, let image = imagePicked else {
      self.showError()
      return
    }
    
    // Create an creator
    let creator = PDFCreator(title: title, body: body, image: image, info: info)
    
    let data = creator.createPDF()
    let shareAction = UIActivityViewController(activityItems: [data], applicationActivities: [])
    
    self.navigationController?.present(shareAction, animated: true, completion: nil)
  }
  
  fileprivate func showError() {
    let alert = UIAlertController(title: "Error", message: "Provide all information to create a custom PDF", preferredStyle: .alert)
    
    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)

    alert.addAction(ok)
    
    self.navigationController?.present(alert, animated: true, completion: nil)
  }
  
  @IBAction fileprivate func chooseImageClick() {
    self.navigationController?.present(imagePicker, animated: true, completion: nil)
  }
  
}

extension ViewController: UIImagePickerControllerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

    self.imagePreview.image = image
    self.imagePicked = image
    
    picker.dismiss(animated: true, completion: nil)
  }
  
}

extension ViewController: UINavigationControllerDelegate {}
