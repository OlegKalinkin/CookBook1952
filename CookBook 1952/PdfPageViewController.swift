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
