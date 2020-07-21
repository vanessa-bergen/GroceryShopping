//
//  GroceryListTableViewController.swift
//  NoStoryboard
//
//  Created by Vanessa Bergen on 2019-08-15.
//  Copyright © 2019 Vanessa Bergen. All rights reserved.
//

import UIKit
import os.log

class GroceryListTableViewController: UITableViewController {

    //get the arrray of default list items
    private var items = [[GroceryItem]]() //= GroceryItem.getMockData()
    
    let sections = ["Fruits", "Vegetables", "Meats", "Dairy", "Grains", "Snacks", "Drinks", "Frozen", "Other"]
    
    let sectionImages: [UIImage] = [UIImage(named: "Fruits")!, UIImage(named: "Vegetables")!, UIImage(named: "Meats")!, UIImage(named: "Dairy")!, UIImage(named: "Grains")!, UIImage(named: "Snacks")!, UIImage(named: "Drinks")!, UIImage(named: "Frozen")!, UIImage(named: "Other")!]
    
    var groceryTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setNavigationBar()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //this isn't working as expected!!
        
        if let savedGroceryItems = loadGroceryItems() {
            items += savedGroceryItems
        }
        else {
            items = GroceryItem.getMockData()
       }

        self.title = "Grocery List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemView))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(clearList))
        
        groceryTableView.backgroundColor = UIColor.white
        groceryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(groceryTableView)
        
        groceryTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        groceryTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        groceryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.groceryTableView = tableView
        
        groceryTableView.delegate = self
        groceryTableView.dataSource = self
        groceryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "groceryItem")
        
    }
/*
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "test")
        let doneItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(addItem))
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
 */
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //check to make sure there are rows for a section, if there aren't then return 0
        let isIndexValid = items.indices.contains(section)
        if isIndexValid {
            return items[section].count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let showSection = items[section].count
        let view = UIView()
        // if showSection > 0 {
        view.isHidden = false
        
        //adding the image to the section header
        let image = sectionImages[section]
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        view.addSubview(imageView)
        view.bringSubviewToFront(imageView)
        
        //making the section header light gray
        view.backgroundColor = UIColor.lightGray
        
        //adding the section name as the label
        let label = UILabel()
        label.frame = CGRect(x: 80, y: 0, width: 200, height: 48)
        // label.font = UIFont(name: label.font.fontName, size: 20)
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = sections[section]
        label.textColor = UIColor.white
        view.addSubview(label)
        /*}
         else {
         view.isHidden = true
         }*/
        
        //i think we can add view.ishidden here to hide sections with no rows
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //added a little hack to hide sections with no rows
        let showSection = items[section].count
        if showSection > 0 {
            return 50
        }
        else {
            return 0
        }
        //return 50
    }
    
    //provide a cell object for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryItem", for: indexPath) as UITableViewCell
        
        if indexPath.row < items[indexPath.section].count {
            let item = items[indexPath.section][indexPath.row]
            cell.textLabel?.text = "\(item.quantity) \(item.listItem)"
            
            let accessory: UITableViewCell.AccessoryType = item.done ? .checkmark : .none
            cell.accessoryType = accessory
        }
        return cell
 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < items[indexPath.section].count {
            let item = items[indexPath.section][indexPath.row]
            
            item.done = !item.done
            print(items[indexPath.section][indexPath.row].done)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row < items[indexPath.section].count {
            items[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
        saveGroceryItems()
    }
    
    //navigation
    @objc func addItemView() {
        print("add item")
        
        let controller = ViewController()
        //adding this because it conforms to the prototcol
        controller.delegate = self
        
        self.navigationController?.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    @objc func clearList() {
        print("clearing list")
        items.removeAll()
        //reinitialize empty array with all the sections
        items = GroceryItem.getMockData()
        self.tableView.reloadData()
        saveGroceryItems()
    }
    
    //MARK Private Methods
    //called whenever the items array changes - new items, deletes, clear list
    private func saveGroceryItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(items, toFile: GroceryItem.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Grocery item saved.", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save.", log: OSLog.default, type: .error)
        }
    }
    
    private func loadGroceryItems() -> [[GroceryItem]]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: GroceryItem.ArchiveURL.path) as? [[GroceryItem]]
    }

}

extension GroceryListTableViewController: AddItemDelegate {
    func addItem(groceryItem: GroceryItem) {
        let sectionNum = groceryItem.type
        //add new grocery item
        //ToDo: change this to dynamic sections
        //maybe change the type to an int for the section
        let isIndexValid = items.indices.contains(sectionNum)
        let newRowNum: Int
        if isIndexValid {
            newRowNum = items[sectionNum].count
        }
        else {
            newRowNum = 0
        }
        let newIndexPath = IndexPath(row: newRowNum, section: sectionNum)
        items[sectionNum].append(groceryItem)
        //instead of doing this I think we can just relaod the table view
        //test that later
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        //save the grocery item
        saveGroceryItems()
    }
}
