//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Екатерина Орлова on 14.11.2024.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var categories = [CategoryModel]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifire)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))

        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
        loadCategories()
        setupUI()
        makeConstraints()
    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = CategoryModel(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifire, for: indexPath) as! CategoryCell
        
        cell.itemLabel.text = categories[indexPath.row].name

        return cell
    }
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tdVC = ToDoListViewController()
        if let indexPath = tableView.indexPathForSelectedRow {
            tdVC.selectedCategory = categories[indexPath.row]
                    }
        navigationController?.pushViewController(tdVC, animated: true)
        saveCategories()
        tableView.deselectRow(at: indexPath, animated: true)
                }
      
    func saveCategories() {
           do {
               try context.save()
           } catch {
               print("Error saving category \(error)")
           }
           
        categoryTableView.reloadData()
           
       }
       
       func loadCategories() {
           let request : NSFetchRequest<CategoryModel> = CategoryModel.fetchRequest()
           
           do {
           categories = try context.fetch(request)
           } catch {
               print("Error loading categories \(error)")
           }
           categoryTableView.reloadData()
       }
    
    func setupUI() {
        view.backgroundColor = .systemMint
        view.addSubview(categoryTableView)
    }
    
    func makeConstraints() {
        
        NSLayoutConstraint.activate([
            categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

