//
//  ViewController.swift
//  Todoey
//
//  Created by Екатерина Орлова on 06.11.2024.
//

import UIKit

class ToDoListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var itemArray = ["Find Mike", "Buy Milk", "Clean House"]
    
    var toDoTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .green
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifire)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        toDoTableView.dataSource = self
        toDoTableView.delegate = self
        setupUI()
        makeConstraints()
    }
    
    
    @objc func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            self.itemArray.append(textField.text ?? "")
            self.toDoTableView.reloadData()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter new item"
            textField = alertTextField
            print(alertTextField.text)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //Mark: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifire, for: indexPath) as! ListCell

        cell.itemLabel.text = itemArray[indexPath.row]
        return cell
    }
    
    //Mark: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected \(itemArray[indexPath.row])")
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(toDoTableView)
    }
    
    func makeConstraints() {
        
        NSLayoutConstraint.activate([
            toDoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toDoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toDoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toDoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
}


