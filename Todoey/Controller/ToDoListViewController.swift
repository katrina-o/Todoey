//
//  ViewController.swift
//  Todoey
//
//  Created by Екатерина Орлова on 06.11.2024.
//

import UIKit
import CoreData

class ToDoListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var itemArray = [ItemModel]()
    var selectedCategory: CategoryModel? {
            didSet{
                loadItems()
            }
        }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    var toDoTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifire)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todoey"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        searchBar.delegate = self
        toDoTableView.dataSource = self
        toDoTableView.delegate = self
     
        loadItems()
        setupUI()
        makeConstraints()
    }
    
    
    @objc func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            
            let newItem = ItemModel(context: self.context)
            newItem.title = textField.text ?? ""
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifire, for: indexPath) as! ListCell

        let item = itemArray[indexPath.row]
        cell.itemLabel.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Model Manipulation Methods
    
    func saveItems() {
       
        do {
        try context.save()
        } catch {
           print("Error saving item context \(error)")
        }
        toDoTableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<ItemModel> = ItemModel.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory!.name)!)
        if let additionPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
        itemArray = try context.fetch(request)
        } catch {
            print("Error fetching item context \(error)")
        }
    }
 
    func setupUI() {
        view.backgroundColor = .systemMint
        view.addSubview(searchBar)
        view.addSubview(toDoTableView)
    }
    
    func makeConstraints() {
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 57),
            
            toDoTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            toDoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toDoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toDoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

//MARK: UISeaurchBarDelegate
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<ItemModel> = ItemModel.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                
                loadItems(with: request, predicate: predicate)
                
            }
            
            func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                if searchBar.text?.count == 0 {
                    loadItems()
                    
                    DispatchQueue.main.async {
                        searchBar.resignFirstResponder()
                    }
                  
                }
            }
        }
 
