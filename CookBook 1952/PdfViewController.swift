//
//  PdfViewController.swift
//  CookBook 1952
//
//  Created by OLK Macbook Pro on 08.03.17.
//  Copyright © 2017 Oleg Kalinkin. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate, UIPageViewControllerDataSource {
    
    //Переменные куда будем передавать информацию из PdfListController
    var localPdfUrls: URL?
    var remotePdfUrls: URL?
    var pdfDocument: CGPDFDocument? /*Когда скачивается pdf из интернета создается документ с информацией содержащейся в нем*/
    var pageController: UIPageViewController!
    
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
    
    // Реализуем функцию загрузки PDF из интернета:
    func loadRemotePdf() {
        progressView.setProgress(0, animated: false)
        
        // Создаем задачу по загрузке документа:
        // Cначала конфигурируем сессию
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        // Создаем собственно задачу по загрузке
        let downloadTask = session.downloadTask(with: remotePdfUrls!)
        
        downloadTask.resume()
        
    }
    
    // Этот метод подготавливает контроллер для анимации и отображения страниц:
    func preparePageViewController() {
      pageController = self.storyboard?.instantiateViewController(withIdentifier: "UIPageViewController") as! UIPageViewController
        
        self.addChildViewController(pageController)
        
        pageController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        let pageVc = self.storyboard?.instantiateViewController(withIdentifier: "PdfPageViewController") as! PdfPageViewController
        
        pageVc.pdfDocument = pdfDocument
        pageVc.pageNumber = 1
        
        self.view.addSubview(pageController.view)
        
        pageController.setViewControllers([pageVc], direction: .forward, animated: true, completion: nil)
    }
    
    // Перед загрузкой документа реализуем два метода UIPageViewControllerDataSource
    // Первый метод Before:
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pageVc = viewController as! PdfPageViewController
        
        if pageVc.pageNumber! > 1 {
            let previousPageVc = self.storyboard?.instantiateViewController(withIdentifier: "PdfPageViewController") as! PdfPageViewController
            
            previousPageVc.pdfDocument = pdfDocument
            previousPageVc.pageNumber = pageVc.pageNumber! - 1
            
            return previousPageVc
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pageVc = viewController as! PdfPageViewController
        
        let previousPageVc = self.storyboard?.instantiateViewController(withIdentifier: "PdfPageViewController") as! PdfPageViewController
        
        previousPageVc.pdfDocument = pdfDocument
        previousPageVc.pageNumber = pageVc.pageNumber! + 1
        
        return previousPageVc
    }
    
    // Реализуем делегат URLSessionDelegate:
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.localPdfUrls = location
        self.loadLocalPdf()
    }
    
    // Реализуем делегат где будет происходить подсчет progressView
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
    // После подсчета прогресса, обеспечиваем его постоянное обновление. Делаем это в главном потоке:
        DispatchQueue.main.async {
            self.progressView.setProgress(progress, animated: true)
        }
        
    }
    
    // Реализуем еще один метод у делегата на случай возникновения ошибки
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        dump (error)
    }
}
