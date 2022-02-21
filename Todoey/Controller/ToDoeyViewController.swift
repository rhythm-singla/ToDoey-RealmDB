//
//  ViewController.swift
//  Todoey/Users/rhythmsingla
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class ToDoeyViewController: UITableViewController {
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    @IBOutlet weak var navbar: UINavigationItem!

    var selectedCategory: Category?{
        didSet{
            print("Category set successfully!\(String(describing: selectedCategory?.name))")
            loadItems()
            navbar.title = selectedCategory?.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
//        print(items)
        tableView.reloadData()
    }

//    func saveData(item: Item){
//        do{
//            try realm.write {
//                realm.add(item)
//            }
//        }catch{
//            print("Error saving item: \(error)")
//        }
//       self.tableView.reloadData()
//    }

    // MARK: - ADD ITEM BUTTON PRESSED
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add ToDoey Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
//            print("Item added successfully")
            print(textField.text ?? "Error adding item!")
            
            if let text = textField.text{
                do{
                    try self.realm.write {
                        let item = Item()
                        item.title = text
                        self.selectedCategory?.items.append(item)
                        item.dateCreated = Date()
//                        print(date)
//                        self.realm.add(item)
                    }
                }catch{
                    print("Error saving item: \(error)")
                }
               self.tableView.reloadData()
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter New ToDoey Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

//     MARK: - TABLE VIEW DATASOURCE METHODS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoeyCell", for: indexPath)
        
        cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No Item yet"

        if(todoItems?[indexPath.row].done == true){
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }

// MARK: - TABLE VIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
            try realm.write {
                todoItems?[indexPath.row].done = !(todoItems?[indexPath.row].done ?? false)
            }
        }catch{
            print("Error changing accessory of item: \(error)")
        }
       self.tableView.reloadData()
        
//        DELETING DATA
//        context1.delete(arr[indexPath.row])
//        arr.remove(at: indexPath.row)
//        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - SEARCH FIELD DELEGATE EXTENSION
extension ToDoeyViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text == ""){
            loadItems()
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        }
        else{
            searchBarSearchButtonClicked(searchBar)
        }
    }
}


