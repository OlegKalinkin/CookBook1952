//
//  PdfListViewController.swift
//  CookBook 1952
//
//  Created by OLK Macbook Pro on 08.03.17.
//  Copyright © 2017 Oleg Kalinkin. All rights reserved.
//

import UIKit

class PdfListViewController: UITableViewController {
    
    var localPdfUrls: [URL] = []
    var remotePdfUrls: [URL] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localPdfUrls.append(Bundle.main.url(forResource: "CookBook 1952", withExtension: "pdf")!)
        
        remotePdfUrls.append(URL(string: "http://i.booksgid.com/web/getbook/43799")!)
        
        remotePdfUrls.append(URL(string: "http://i.booksgid.com/web/getbook/28746")!)
        
        remotePdfUrls.append(URL(string: "http://i.booksgid.com/web/getbook/15262")!)
        
    }
    
    //Переход в другой ViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Переменная для обеспечения перехода со строки выбора в этот ViewController
        let pdfVc = self.storyboard?.instantiateViewController(withIdentifier: "PdfViewController") as! PdfViewController
        
        if indexPath.section == 0 {
            //Передаем информацию содержащуюся в строке т.е. название ссылки
            pdfVc.localPdfUrls = localPdfUrls[indexPath.row]
        } else {
            pdfVc.remotePdfUrls = remotePdfUrls[indexPath.row]
        }
        self.navigationController?.pushViewController(pdfVc, animated: true)
    }
}
