//
//  ViewController.swift
//  NoStoryboard
//
//  Created by Vanessa Bergen on 2019-08-13.
//  Copyright © 2019 Vanessa Bergen. All rights reserved.
//

import UIKit
import os.log

protocol AddItemDelegate {
    func addItem(groceryItem: GroceryItem)
}

class ViewController: UIViewController, UITextFieldDelegate {

    var delegate: AddItemDelegate?
    
    //dictionary of grocery type to section number
    var groceryTypes = ["Fruits": 0, "Vegetables": 1, "Meats": 2, "Dairy": 3, "Grains": 4, "Snacks": 5, "Drinks": 6, "Frozen": 7, "Other": 8]
    
    //labels
    var itemField = MyLabel()
    var itemError = MyLabel()
    var quantityField = MyLabel()
    
    //textfields
    var myItem = MyTextField()
    var myQuantity = MyTextField()
    
    //dropdown button
    var typeBtn = dropDownBtn()
    var typeError = MyLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        self.title = "Add Item To List"
        
        
        let margins = self.view.layoutMarginsGuide
        
        
        setupLabels(constraint: margins)
        
        
        setupTextFields(constraint: margins)
        myItem.delegate = self
        myQuantity.delegate = self
        
        //adding the dropdown button
        typeBtn = dropDownBtn.init(frame: CGRect(x: 140, y: 300, width: 0, height: 0))
        typeBtn.setTitle("Item Type", for: .normal)
        typeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(typeBtn)
        
        //typeBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //typeBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        typeBtn.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        typeBtn.topAnchor.constraint(equalTo: margins.topAnchor, constant: 260).isActive = true
        
        typeBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        typeBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        typeBtn.dropView.dropDownOptions = ["Fruits", "Vegetables", "Meats", "Dairy", "Grains", "Snacks", "Drinks", "Frozen", "Other"]
 
        //navigation buttons
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem))
       
    }
    
    @objc func cancel() {
        print("test")
        //_ = navigationController?.popViewController(animated: true)
        //let newViewController = UINavigationController(rootViewController: GroceryListTableViewController()) //GroceryListTableViewController()
        //present(newViewController, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveItem() {
        
        guard let item = myItem.text, !item.isEmpty else {
            // if myItem.text is empty, the itemError will be shown
            itemError.isHidden = false
            return
        }
        
        guard let itemType = typeBtn.titleLabel?.text else {
            // if no type is selected, the type error will be shown
            typeError.isHidden = false
            return
        }
        
        
        guard let sectionNum = groceryTypes[itemType] else {
           print("item type \(itemType)")
            return
        }
        //default the quantity to 1 if the user doesn't enter anything
//        guard let quantity = Int(myQuantity.text ?? "1") else {
//            //os_log("The value entered for quantity is not valid", log: OSLog.default, type: .debug)
//            print("no qunatity")
//            return
//        }
        let quantity = Int(myQuantity.text ?? "1") ?? 1
        
        let grocery = GroceryItem(listItem: item, quantity: quantity, type: sectionNum)
        delegate?.addItem(groceryItem: grocery!)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupLabels(constraint: UILayoutGuide) {
        
        itemField = MyLabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        itemField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(itemField)
        itemField.leadingAnchor.constraint(equalTo: constraint.leadingAnchor, constant: 20).isActive = true
        itemField.topAnchor.constraint(equalTo: constraint.topAnchor, constant: 40).isActive = true
        itemField.widthAnchor.constraint(equalToConstant: 150).isActive = true
        itemField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        itemField.text = "Item Name"
        
        itemError = MyLabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        itemError.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(itemError)
        itemError.leadingAnchor.constraint(equalTo: constraint.leadingAnchor, constant: 20).isActive = true
        itemError.topAnchor.constraint(equalTo: constraint.topAnchor, constant: 120).isActive = true
        itemError.widthAnchor.constraint(equalToConstant: 300).isActive = true
        itemError.heightAnchor.constraint(equalToConstant: 40).isActive = true
        itemError.text = "Please enter item name."
        itemError.textColor = .red
        itemError.font = itemError.font.withSize(18)
        itemError.isHidden = true
        
        quantityField = MyLabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        quantityField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(quantityField)
        quantityField.leadingAnchor.constraint(equalTo: constraint.leadingAnchor, constant: 20).isActive = true
        quantityField.topAnchor.constraint(equalTo: constraint.topAnchor, constant: 150).isActive = true
        quantityField.widthAnchor.constraint(equalToConstant: 150).isActive = true
        quantityField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        quantityField.text = "Quantity"
        
        typeError = MyLabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        typeError.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(typeError)
        typeError.leadingAnchor.constraint(equalTo: constraint.leadingAnchor, constant: 20).isActive = true
        typeError.topAnchor.constraint(equalTo: constraint.topAnchor, constant: 300).isActive = true
        typeError.widthAnchor.constraint(equalToConstant: 300).isActive = true
        typeError.heightAnchor.constraint(equalToConstant: 40).isActive = true
        typeError.text = "Select item type from dropdown."
        typeError.textColor = .red
        typeError.font = typeError.font.withSize(18)
        typeError.isHidden = true
        
    }
    
    func setupTextFields(constraint: UILayoutGuide) {
        myItem = MyTextField.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        myItem.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(myItem)
        
        myItem.leadingAnchor.constraint(equalTo: constraint.leadingAnchor, constant: 20).isActive = true
        myItem.topAnchor.constraint(equalTo: constraint.topAnchor, constant: 80).isActive = true
        //myItem.trailingAnchor.constraint(equalTo: constraint.trailingAnchor).isActive = true
        myItem.widthAnchor.constraint(equalToConstant: 200).isActive = true
        myItem.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        myQuantity = MyTextField.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        myQuantity.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(myQuantity)
        
        myQuantity.leadingAnchor.constraint(equalTo: constraint.leadingAnchor, constant: 20).isActive = true
        myQuantity.topAnchor.constraint(equalTo: constraint.topAnchor, constant: 190).isActive = true
        //myItem.trailingAnchor.constraint(equalTo: constraint.trailingAnchor).isActive = true
        myQuantity.widthAnchor.constraint(equalToConstant: 200).isActive = true
        myQuantity.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    //test fields, clear keyboard when enter pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//making a class for labels
class MyLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeLabel()
    }
    
    func initializeLabel() {
        self.textAlignment = .left
        self.font = UIFont(name: "Helvetica", size: 20)
        self.textColor = UIColor(red: 0.1922, green: 0.1882, blue: 0.498, alpha: 1.0)
        
    }
}

//making a class for textfields
class MyTextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeText()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeText()
    }
    
    func initializeText() {
        self.textAlignment = .left
        self.font = UIFont(name: "Helvetica", size: 20)
        self.textColor = UIColor(red: 0.1922, green: 0.1882, blue: 0.498, alpha: 1.0)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.1922, green: 0.1882, blue: 0.498, alpha: 1.0).cgColor
        
    }
    
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


protocol dropDownProtocol {
    func dropDownPressed(string: String)
}

class dropDownBtn: UIButton, dropDownProtocol {
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        self.titleLabel?.textColor = UIColor.white
        self.dismissDropDown()
    }
    
    //setting the view of the dropdown when the button is pressed
    var dropView = dropDownView()
    
    //want to be able to edit the height of the table view dropdown
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.1922, green: 0.1882, blue: 0.498, alpha: 1.0)
        
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func didMoveToSuperview() {
        //didMoveToSuperview function assumes it is only called when the view is added to its superview
        //it is also called when the view is removed
        //had to update the function so it only runs when the code is being added
        //this prevents the crashing error when the screen navigates away
        if self.superview != nil {
            //need to access the parent view??
            self.superview?.addSubview(dropView)
            self.superview?.bringSubviewToFront(dropView)
            
            //this will open the table view from beneath the button
            //here the self is referencing the button
            dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            //don't want to activate the height contrainst just yet
            height = dropView.heightAnchor.constraint(equalToConstant: 0)
        }
        
    }
    //this will  let us know if the dropdown is open or not
    var isOpen = false
    //when the button is pressed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            //activate the height
            //make sure its deactivated before activating
            NSLayoutConstraint.deactivate([self.height])
            //want to create a threshold for the height so that 150 is the largest it will get but it can be smaller if there are only a few options
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            }
            else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                //this will apply the activated constraints and animate them
                self.dropView.layoutIfNeeded()
                //this will make it move down
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
        }
        else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                //this will make it move up
                self.dropView.center.y -= self.dropView.frame.height / 2
                //this will apply the activated constraints and animate them
                self.dropView.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            //this will make it move up
            self.dropView.center.y -= self.dropView.frame.height / 2
            //this will apply the activated constraints and animate them
            self.dropView.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    //array of options that will fill the table view
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.lightGray
        self.backgroundColor = UIColor.lightGray
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.lightGray
        }
        else {
            cell.backgroundColor = UIColor(red: 0.6902, green: 0.6824, blue: 0.7686, alpha: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        //deselect the row
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
