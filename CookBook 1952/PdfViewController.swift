//
//  PdfViewController.swift
//  CookBook 1952
//
//  Created by OLK Macbook Pro on 08.03.17.
//  Copyright © 2017 Oleg Kalinkin. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController {
    
    //Переменные куда будем передавать информацию из PdfListController
    var localPdfUrls: URL?
    var remotePdfUrls: URL?
    var pdfDocument: CGPDFDocument? /*Когда скачивается pdf из интернета создается документ с информацией содержащейся в нем*/
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //Делаем проверку на предмет какой метод вызывать
        if localPdfUrls != nil {
            self.loadLocalPdf()
        }
        else if remotePdfUrls != nil {
            self.loadRemotePdf()
        }
        
    }
    
    // Реализуем функцию загрузки локальных PDF:
    func loadLocalPdf() {
        progressView.isHidden = true //Скрываем ProgressView для локального файла
        
        let pdfAsData = NSData(contentsOf: localPdfUrls!) //Представляем PDF как данные
        
        let dataProvider = CGDataProvider(data: pdfAsData!) /*Пропускае данные через CGDataProvider, что бы не беспокоиться о буфере данных*/
        
        self.pdfDocument = CGPDFDocument(dataProvider!) /* CGPDFDocument и CGDataProvider это классы фреймворка CoreGraphik */
        
        self.navigationItem.title = localPdfUrls?.deletingPathExtension().lastPathComponent // Отображаем название документа в NavigationController
        
        self.preparePageViewController() //Метод отвечающий за отображение PDF документа
    }
    
    func loadRemotePdf() {
        
    }
    
    func preparePageViewController() {
        
    }
}
