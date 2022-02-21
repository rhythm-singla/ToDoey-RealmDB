//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Rhythm Singla on 19/02/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

    func saveData(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving to realm: \(error)")
        }
       self.tableView.reloadData()
    }
    
    // MARK: - ADD Category BUTTON PRESSED
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Category Name", style: .default) { action in
            print("Category added successfully")
            print(textField.text ?? "Error adding category!")
            if let text = textField.text{
                let category = Category()
                category.name = text
//                self.categories.append(category)
                self.saveData(category: category)
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//     MARK: - TABLE VIEW DATASOURCE METHODS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category assigned"

        return cell
    }

    // MARK: - TABLE VIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "CategoryToItems", sender: self)
//        DELETING DATA
//        context1.delete(categories[indexPath.row])
//        categories.remove(at: indexPath.row)
        
//        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoeyViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}

// MARK: - SEARCH FIELD DELEGATE EXTENSION
//extension CategoryViewController: UISearchBarDelegate{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Category> = NSFetchRequest(entityName: "Category")
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
//        let orderDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [orderDescriptor]
//
//        loadData(with: request)
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if(searchBar.text == ""){
//            loadData()
//            DispatchQueue.main.async{
//                searchBar.resignFirstResponder()
//            }
//        }
//        else{
//            searchBarSearchButtonClicked(searchBar)
//        }
//    }
//
//
//}
