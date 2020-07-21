//
//  GroceryItem.swift
//  groceryList
//
//  Created by Vanessa Bergen on 2019-08-09.
//  Copyright © 2019 Vanessa Bergen. All rights reserved.
//

import Foundation
import os.log

//the class needs to conform to the NSCoding protocol
class GroceryItem: NSObject, NSCoding {
    
    
    //MARK: Properties
    var listItem: String
    var quantity: Int
    var type: Int
    var done: Bool
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("items")
    
    //MARK: types
    //this class is in charge of storing and loading each of its properties
    //it needs to save its data by assigning the value of each property to a particular key
    //it then loads the data by looking up the information associated with that key
    struct PropertyKey {
        //creating a structure to store the ket strings
        //when you need to use the key it's easier to refer to the constant instead of retyping the string
        //static means the constants belong to the structure itself not to instances of the structure
        //accessed using PropertyKey.listItem
        static let listItem = "listItem"
        static let quantity = "quantity"
        static let type = "type"
        static let done = "done"
    }
    
    init?(listItem: String, quantity: Int, type: Int) {
        self.listItem = listItem
        self.quantity = quantity
        self.type = type
        self.done = false
        
        guard !listItem.isEmpty else {
            return nil
        }
        
    }
    
    //MARK NSCoding
    
    //prepares the class's information to be archived
    func encode(with aCoder: NSCoder) {
        aCoder.encode(listItem, forKey:  PropertyKey.listItem)
        aCoder.encode(quantity, forKey: PropertyKey.quantity)
        aCoder.encode(type, forKey: PropertyKey.type)
        aCoder.encode(done, forKey: PropertyKey.done)
    }
    
    //this method unarchives the data when the class is created
    required convenience init?(coder aDecoder: NSCoder) {
        //the listItem is required, if we cannot decode the listitem string, the initializor will fail
        //the decode for key method decodes the info and returns an option
        guard let listItem = aDecoder.decodeObject(forKey: PropertyKey.listItem) as? String else {
            os_log("Unable to decode the name for a Grocery Item object", log: OSLog.default, type: .debug)
            return nil
        }
        
        let quantity = aDecoder.decodeInteger(forKey: PropertyKey.quantity)
        let type = aDecoder.decodeInteger(forKey: PropertyKey.type)
        
        self.init(listItem: listItem, quantity: quantity, type: type)
        let done = aDecoder.decodeBool(forKey: PropertyKey.done)
        self.done = done
    }
    
}

extension GroceryItem {
    public class func getMockData() -> [[GroceryItem]] {
        return [
            /*
            [
                GroceryItem(listItem: "Banana", quantity: 4, type: 0)!,
                GroceryItem(listItem: "Chicken Breasts", quantity: 4, type: 0)!,
                GroceryItem(listItem: "Milk", quantity: 1, type: 0)!
            ],
            [
                GroceryItem(listItem: "Chocolate", quantity: 4, type: 1)!,
                GroceryItem(listItem: "Bread", quantity: 4, type: 1)!,
                GroceryItem(listItem: "Cereal", quantity: 1, type: 1)!
            ],
            [
                GroceryItem(listItem: "Banana", quantity: 4, type: 2)!,
                GroceryItem(listItem: "Chicken Breasts", quantity: 4, type: 2)!,
                GroceryItem(listItem: "Milk", quantity: 1, type: 2)!
            ],
            [
                GroceryItem(listItem: "Chocolate", quantity: 4, type: 3)!,
                GroceryItem(listItem: "Bread", quantity: 4, type: 3)!,
                GroceryItem(listItem: "Cereal", quantity: 1, type: 3)!
            ],
             */
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            []
        ]
    }
    
}
