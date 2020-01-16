//
//  Book.swift
//  Data Application
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import Foundation

class Book {
    var title:String
    var author:String
    var pages:Int
    var year:Int
  
    init(title:String,author:String,pages:Int,year:Int) {
        self.title = title
        self.author = author
        self.pages = pages
        self.year = year
    }
}
