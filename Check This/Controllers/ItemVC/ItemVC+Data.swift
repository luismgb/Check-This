//
//  ItemVC+Data.swift
//  Check This
//
//  Created by Luis M Gonzalez on 7/24/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import RealmSwift

extension ItemVC {
    
    // MARK: - Data Methods
    
    func save(_ item: Item) {
        do {
            try realm.write {
                realm.add(item)
                if let items = items {
                    item.persistedIndexRow = items.count
                }
                selectedCategory?.items.append(item)
            }
        } catch {
            fatalError("Error saving item \(error)")
        }
    }
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "persistedIndexRow", ascending: true)
        tableView.reloadData()
    }
    
    func edit(item: Item, newName: String? = nil) {
        do {
            try realm.write {
                if let newName = newName {
                    item.name = newName
                }
                realm.add(item)
            }
        } catch {
            fatalError("Error editing item \(error)")
        }
    }
    
    func moveItem(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        do {
            try realm.write {
                let itemBeingMoved = items?[sourceIndexPath.row]
                if sourceIndexPath.row < destinationIndexPath.row {
                    for index in (sourceIndexPath.row + 1)...destinationIndexPath.row {
                        let item = items?[index]
                        item?.persistedIndexRow -= 1
                    }
                } else if sourceIndexPath.row > destinationIndexPath.row {
                    for index in destinationIndexPath.row..<sourceIndexPath.row {
                        items?[index].persistedIndexRow += 1
                    }
                }
                itemBeingMoved?.persistedIndexRow = destinationIndexPath.row
            }
        } catch {
            fatalError("Error moving item to new indexPath \(error)")
        }
    }
    
    func resetItemsPersistedIndexRow() {
        if let items = items {
            var index = 0
            for item in items {
                do {
                    try realm.write {
                        item.persistedIndexRow = index
                    }
                } catch {
                    fatalError("Error resetting item persistedIndexRow \(error)")
                }
                index += 1
            }
        }
    }
    
    func deleteItem(at indexPath: IndexPath) {
        if let item = selectedCategory?.items[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                fatalError("Error deleting item \(error)")
            }
        }
    }
    
}