//
//  PDFCreator.swift
//  PDFCreatorSample
//
//  Created by Marcos Lacerda on 30/08/19.
//  Copyright © 2019 Marcos Lacerda. All rights reserved.
//

import PDFKit

class PDFCreator {
  
  let title: String
  let body: String
  let image: UIImage
  let info: String
  
  init(title: String, body: String, image: UIImage, info: String) {
    self.title = title
    self.body = body
    self.image = image
    self.info = info
  }
  
  func createPDF() -> Data {
    // Create PDF Meta Data
    let metaData = [
      kCGPDFContextCreator: "PDF Creator",
      kCGPDFContextAuthor: "Marcos Lacerda",
      kCGPDFContextTitle: title
    ]
    
    let format = UIGraphicsPDFRendererFormat()
    format.documentInfo = metaData as [String: Any]
    
    // Define the pages params
    let width = 8.5 * 72
    let height = 11.0 * 72
    let frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
    
    // Creating a page render
    let renderer = UIGraphicsPDFRenderer(bounds: frame, format: format)

    // Generating PDF data
    let data = renderer.pdfData { context in
      // Start new page
      context.beginPage()

      // Draw the title
      let titleEnds = self.addTitle(frame)

      let imageEnds = self.addImage(frame, yPosition: titleEnds + 18)

      // Draw the body
      self.addBody(frame, yPosition: imageEnds + 18)
      
      // Retrieve the context of draw
      let drawContext = context.cgContext
      
      // Draw footer
      self.addFooter(drawContext, frame: frame, yPosition: frame.height * 4.0 / 5.0, tabs: 8)
      
      // Draw contact info
      self.addInfo(drawContext, frame: frame, tabs: 8)
    }
    
    return data
  }
  
  func addTitle(_ frame: CGRect) -> CGFloat {
    // Create a title font
    let font = UIFont.systemFont(ofSize: 18, weight: .bold)
    
    // Define the title attributes
    let attributes: [NSAttributedString.Key: Any] = [.font: font]
    
    // Create attributed title
    let title = NSAttributedString(string: self.title, attributes: attributes)
    
    // Get the title size
    let titleSize = title.size()
    
    // Define title frame
    let titleFrame = CGRect(x: (frame.width - titleSize.width) / 2, y: 36, width: titleSize.width, height: titleSize.height)
    
    // Draw the title at the position
    title.draw(in: titleFrame)
    
    // Calculate the y position to next item
    return titleFrame.origin.y + titleFrame.size.height
  }
  
  func addBody(_ frame: CGRect, yPosition: CGFloat) {
    // Defines the body font
    let font = UIFont.systemFont(ofSize: 12, weight: .regular)
    
    // Creating paragraph style
    let paragraph = NSMutableParagraphStyle()
    
    paragraph.alignment = .natural
    paragraph.lineBreakMode = .byWordWrapping
    
    // Define body attributes
    let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraph]
    
    // Create attributed text
    let body = NSAttributedString(string: self.body, attributes: attributes)
    
    // Define body frame
    let bodyFrame = CGRect(x: 10, y: yPosition, width: frame.width - 20, height: frame.height - yPosition - frame.height / 5)
    
    // Draw the body at the position
    body.draw(in: bodyFrame)
  }
  
  func addImage(_ frame: CGRect, yPosition: CGFloat) -> CGFloat {
    // Define the limits
    let maxWidth = frame.width * 0.8
    let maxHeight = frame.height * 0.4
    
    // Calculate image aspect ratio
    let aspectWidth = maxWidth / self.image.size.width
    let aspectHeight = maxHeight / self.image.size.height
    let aspectRatio = min(aspectWidth, aspectHeight)
    
    // Calculate image scale
    let scaleWidth = image.size.width * aspectRatio
    let scaleHeight = image.size.height * aspectRatio
    
    // Calculate x position
    let x = (frame.width - scaleWidth) / 2.0
    let imageFrame = CGRect(x: x, y: yPosition, width: scaleWidth, height: scaleHeight)
    
    // Draw image
    image.draw(in: imageFrame)
    
    // Calculate the y position to next item
    return imageFrame.origin.y + imageFrame.size.height
  }
  
  func addFooter(_ context: CGContext, frame: CGRect, yPosition: CGFloat, tabs: Int) {
    // Save state
    context.saveGState()
    
    // Draw top line
    context.setLineWidth(2.0)
    
    context.move(to: CGPoint(x: 0, y: yPosition))
    context.addLine(to: CGPoint(x: frame.width, y: yPosition))
    context.strokePath()
    
    // Restore state
    context.restoreGState()
    
   // Re-save context
    context.saveGState()
    
    let dashLength = CGFloat(72 * 0.2)
    context.setLineDash(phase: 0, lengths: [dashLength, dashLength])

    let width = frame.width / CGFloat(tabs)

    for index in 1 ..< tabs {
      let x = CGFloat(index) * width
      
      context.move(to: CGPoint(x: x, y: yPosition))
      context.addLine(to: CGPoint(x: x, y: frame.height))
      context.strokePath()
    }
    
    context.restoreGState()
  }
  
  func addInfo(_ context: CGContext, frame: CGRect, tabs: Int) {
    let font = UIFont.systemFont(ofSize: 10, weight: .regular)
    let paragraph = NSMutableParagraphStyle()

    paragraph.alignment = .natural
    paragraph.lineBreakMode = .byWordWrapping
    
    let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraph]
    
    let text = NSAttributedString(string: info, attributes: attributes)
    
    // Retrieve text height
    let height = text.size().height
    
    // Calculate tab width
    let tabWidth = frame.width / CGFloat(tabs)
    let offset = (tabWidth - height) / 2.0
    
    context.saveGState()
    
    // Rotating and drawing text
    context.rotate(by: -90.0 * .pi / 180.0)
    
    for index in 0 ..< tabs {
      let x = CGFloat(index) * tabWidth + offset
      
      // Draw text
      text.draw(at: CGPoint(x: -frame.height + 5.0, y: x))
    }
    
    context.restoreGState()
  }

}
