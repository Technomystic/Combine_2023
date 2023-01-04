//
//  ViewController.swift
//  DiffableTableView
//
//  Created by Niraj on 04/01/2023.
//

import UIKit

class ViewController: UIViewController {

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        return tv
    }()

    private let viewModel = DiffableViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(tableView)
        tableView.frame = view.bounds

        configureContents()
        viewModel.viewDidLoad(tableView: tableView)
    }

    @objc
    private func addButtonTapped() {
        viewModel.addItem()
    }

    @objc
    private func removeButtonTapped() {
        viewModel.removeItem()
    }

    private func configureContents() {
        title = "With DiffableDataSource"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addButtonTapped)),
            UIBarButtonItem(image: .remove, style: .plain, target: self, action: #selector(removeButtonTapped))
        ]
    }

}
