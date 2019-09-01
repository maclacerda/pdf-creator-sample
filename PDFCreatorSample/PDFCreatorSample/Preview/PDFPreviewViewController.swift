//
//  PDFPreviewViewController.swift
//  PDFCreatorSample
//
//  Created by Marcos Lacerda on 31/08/19.
//  Copyright © 2019 Marcos Lacerda. All rights reserved.
//

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
  
  @IBOutlet weak fileprivate var pdfViewer: PDFView!
  
  var pdfData: Data?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    guard let data = self.pdfData else { return }
    
    pdfViewer.document = PDFDocument(data: data)
    pdfViewer.autoScales = true
  }


}
