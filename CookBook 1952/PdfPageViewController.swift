//
//  PdfPageViewController.swift
//  CookBook 1952
//
//  Created by OLK Macbook Pro on 09.03.17.
//  Copyright © 2017 Oleg Kalinkin. All rights reserved.
//

import UIKit

class PdfPageView: UIView {
    
    var pdfDocument: CGPDFDocument? = nil
    var pageNumber: Int? = nil
    
    // Для работы с CoreGraphik вызываем метод draw rect:
    override func draw(_ rect: CGRect) {
        if pdfDocument != nil {
            let ctx = UIGraphicsGetCurrentContext()
            
            UIColor.white.set()
            
            ctx?.fill(rect)
            
            _ = ctx?.ctm // вызываем CGAffineTransform
            _ = ctx?.scaleBy(x: 1, y: -1)
            _ = ctx?.translateBy(x: 0, y: -rect.size.height)
            
            let page = pdfDocument?.page(at: pageNumber!) // Объявляем страницу
            // Далее производим настройки отображения страницы:
            let pageRect = page?.getBoxRect(CGPDFBox.cropBox)
            
            let ratioWidth = rect.size.width / (pageRect?.size.width)!
            let ratioHeight = rect.size.height / (pageRect?.size.height)!
            
            let ratio = min(ratioWidth, ratioHeight)
            
            let newWidth = (pageRect?.size.width)! * ratio
            let newHeight = (pageRect?.size.height)! * ratio
            
            let ofsetX = (rect.size.width - newWidth)
            let ofsetY = (rect.size.height - newHeight)
            
            ctx?.scaleBy(x: newWidth / (pageRect?.size.width)!, y: newHeight / (pageRect?.size.height)!)
            
            ctx?.translateBy(x: -(pageRect?.origin.x)! + ofsetX, y: -(pageRect?.origin.y)! + ofsetY)
            
            ctx?.drawPDFPage(page!)
        }
        
    }
    
}

class PdfPageViewController: UIViewController, UIScrollViewDelegate {
    
    var pdfDocument: CGPDFDocument? = nil
    var pageNumber: Int? = nil
    
    @IBOutlet weak var page: PdfPageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.preparePdfPage()
        
    }
    
    func preparePdfPage() {
        
        page.pdfDocument = self.pdfDocument
        page.pageNumber = self.pageNumber
        
        page.setNeedsDisplay()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return page
    }
    
}
