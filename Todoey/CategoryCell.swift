//
//  CategoryCell.swift
//  Todoey
//
//  Created by Екатерина Орлова on 14.11.2024.
//

import Foundation
import UIKit

class CategoryCell: UITableViewCell {
    
    static let identifire = "CategoryCell"
    
    var itemLabel: UILabel = {
        let label = UILabel()
        label.text = "Food"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(itemLabel: String) {
        DispatchQueue.main.async {
            self.itemLabel.text = itemLabel
        }
    }
    
    func setupUI() {
        contentView.addSubview(itemLabel)

        NSLayoutConstraint.activate([
            itemLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            itemLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            itemLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
        ])
    }
}
