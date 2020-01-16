//
//  ViewController.swift
//  Data Application
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var books:[Book]?
    @IBOutlet var textfields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
    }
    func getFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if documentPath.count > 0 {
            let documentDirectory = documentPath[0]
            //creating path for file
            let filePath = documentDirectory.appending("data.txt")
            return filePath
        }
        return ""
    }
    
    func loadData(){
        let filePath = getFilePath()
        books = [Book]()
        if FileManager.default.fileExists(atPath: filePath){
            do{
                //extract data
                let fileContents = try String(contentsOfFile: filePath)
                let contentArray = fileContents.components(separatedBy: "\n")
                for content in contentArray{
                    let bookcontent = content.components(separatedBy: ",")
                    if bookcontent.count == 4 {
                        let book = Book(title: bookcontent[0], author: bookcontent[1], pages: Int(bookcontent[2])!, year: Int(bookcontent[3])!)
                        books?.append(book)
                    }
                }
            }catch{
                print(error)
            }
        }
    }
    
    
    @IBAction func addBook(_ sender: UIBarButtonItem) {
        
        let title = textfields[0].text ?? ""
          let author = textfields[1].text ?? ""
          let pages = Int(textfields[2].text ?? "0") ?? 0
        let year = Int(textfields[3].text ?? "2020") ?? 2020
        
        let book = Book(title: title, author: author, pages: pages, year: year)
        books?.append(book)
        
        for textField in textfields {
            textField.text = ""
            textField.resignFirstResponder()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let BookTable = segue.destination as? BookTableViewController {
            BookTable.books = self.books
        }
    }
    
    @objc func saveData() {
        let filePath = getFilePath()
        var saveString = ""
        for book in books!{
            saveString = "\(saveString)\(book.title),\(book.author),\(book.pages),\(book.year)\n"
        }
        //write to path
        do {
            try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
        }catch {
            print(error)
        }
    }
}

