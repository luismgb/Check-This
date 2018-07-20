//
//  ItemAlerts.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/19/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import SwipeCellKit

struct ItemAlerts {
    
    // MARK: - Alerts Methods For ItemViewController
    
    static func presentAlertToAddNewItem(from itemVC: ItemViewController) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let addItemAction = UIAlertAction(title: "Add", style: .default) { _ in
            if textField.text! != "" {
                let newItem = Item()
                newItem.name = textField.text!
                newItem.timeCreated = Date()
                itemVC.save(item: newItem)
                itemVC.setTableViewBackground()
                itemVC.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(addItemAction)
        alert.addAction(cancelAction)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "New Item"
        }
        itemVC.present(alert, animated: true)
    }
    
    static func editItemAlertController(from itemVC: ItemViewController, at indexPath: IndexPath) -> UIAlertController {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editNameAction = ItemAlerts.editItemNameAction(from: itemVC, at: indexPath)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(editNameAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    static func editItemNameAction(from itemVC: ItemViewController, at indexPath: IndexPath) -> UIAlertAction {
        let editNameAction = UIAlertAction(title: "Edit Name", style: .default) { (_) in
            let editNameAlertController = ItemAlerts.itemEditNameAlertController(on: itemVC, at: indexPath)
            if let presentedVC = itemVC.presentedViewController {
                presentedVC.present(editNameAlertController, animated: true)
            } else {
                itemVC.present(editNameAlertController, animated: true)
            }
        }
        return editNameAction
    }

    static func itemEditNameAlertController(on itemVC: ItemViewController, at indexPath: IndexPath) -> UIAlertController {
        let itemAtIndexPath = itemVC.items![indexPath.row]
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Edit Item Name:", message: nil, preferredStyle: .alert)
        
        let editItemNameAction = UIAlertAction(title: "Save", style: .default) { (_) in
            itemVC.edit(item: itemAtIndexPath, newName: textField.text!)
            guard let cell = itemVC.tableView.cellForRow(at: indexPath) as? SwipeTableViewCell else { fatalError() }
            cell.hideSwipe(animated: true)
            Utilities.waitForSwipeAnimationThenReloadTableViewFor(itemVC)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(editItemNameAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.text = itemAtIndexPath.name
        }
        
        return alertController
    }
    
}