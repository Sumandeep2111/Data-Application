//
//  ViewController.swift
//  Data Application
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var books:[Book]?
    
    @IBOutlet var textfields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       // loadData()
        loadCoreData()
       // NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(saveCoreData), name: UIApplication.willResignActiveNotification, object: nil)
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
    
    @objc func saveCoreData(){
        clearCoreData()
        // create an instance of app delegate
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        //second step is context
        let managedContext = appdelegate.persistentContainer.viewContext
        
        
        for book in books! {
            let bookEntity = NSEntityDescription.insertNewObject(forEntityName: "BookModel", into: managedContext)
            bookEntity.setValue(book, forKey: "title")
            bookEntity.setValue(book, forKey: "author")
            bookEntity.setValue(book, forKey: "pages")
            bookEntity.setValue(book, forKey: "year")
            //save data
            
            do{
                try managedContext.save()
            }catch{
                print(error)
            }
        }
        
    }
    
    func loadCoreData(){
        books = [Book]()
        //create an instance of app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //second step is context
        let managedContext = appDelegate.persistentContainer.viewContext
        //create a fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookModel")
        do{
            let results =  try managedContext.fetch(fetchRequest)
            if results is [NSManagedObject] {
                for result in results as! [NSManagedObject]{
                    let title =  result.value(forKey: "title") as! String
                     let author =  result.value(forKey: "author") as! String
                     let pages =  result.value(forKey: "pages") as! Int
                     let year =  result.value(forKey: "year") as! Int
                    books?.append(Book(title: title, author: author, pages: pages, year: year))
                }
            }
        }catch{
            print(error)
        }
    }
    
    func clearCoreData(){
        //create an instance of app delegate
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               //second step is context
               let managedContext = appDelegate.persistentContainer.viewContext
               //create a fetch request
               let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookModel")
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let results = try managedContext.fetch(fetchRequest)
            for managedObjects in results {
                if let managedObjectsData = managedObjects as? NSManagedObject{
                    managedContext.delete(managedObjectsData)
                }
            }
        }catch{
            print(error)
        }
    }
}

