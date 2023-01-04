//
//  DiffableViewModel.swift
//  DiffableTableView
//
//  Created by Niraj on 04/01/2023.
//

import UIKit

class DiffableViewModel {

    private var snapshot = NSDiffableDataSourceSnapshot<DiffableSection, DiffableItem>()

    private var datasource: UITableViewDiffableDataSource<DiffableSection, DiffableItem>!

    private var items = [
        DiffableItem(title: 1),
        DiffableItem(title: 2),
        DiffableItem(title: 3),
        DiffableItem(title: 4),
        DiffableItem(title: 5),
        DiffableItem(title: 6)
    ]

    func viewDidLoad(tableView: UITableView) {
        setupTableViewDataSource(tableView: tableView)
    }

    private func setupTableViewDataSource(tableView: UITableView) {
        datasource = UITableViewDiffableDataSource<DiffableSection, DiffableItem>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = UITableViewCell()
            cell.textLabel?.text = String(itemIdentifier.title)
            return cell
        }
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        updateDataSource()
        }

    func updateDataSource() {
        datasource.apply(snapshot)
    }

    func addItem() {
        let newItem = DiffableItem(title: Int.random(in: 1...100))
        items.append(newItem)
        snapshot.appendItems([newItem])
        updateDataSource()
    }

    // 7
    func removeItem() {
        if !items.isEmpty {
            let removed = items.remove(at: Int.random(in: 0..<items.count))
            snapshot.deleteItems([removed])
            updateDataSource()
        }
    }

}
