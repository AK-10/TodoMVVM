//
//  ViewController.swift
//  TodoMVVM
//
//  Created by Atsushi KONISHI on 2018/12/09.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addButton: UIButton!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let notificationCenter = NotificationCenter()
    private lazy var viewModel = ViewModel(notificationCenter: notificationCenter, itemModel: ItemModel(context: context))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = viewModel
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        notificationCenter.addObserver(self, selector: #selector(updateTableView), name: viewModel.changeText, object: nil)
        notificationCenter.addObserver(self, selector: #selector(updateTableView), name: viewModel.getData, object: nil)
        notificationCenter.addObserver(self, selector: #selector(createData), name: viewModel.addData, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.itemRequested()
    }
}

extension ViewController {
    @objc func addButtonTapped() {
        // some action
//        let alertController = alertcontroller
        let alertController = UIAlertController(title: "入力", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { tf in
            tf.placeholder = "input"
        })
        let createAction = UIAlertAction(title: "Create", style: .default, handler: { [weak self] action in
            self?.viewModel.createItem(text: alertController.textFields?[0].text)
        })
        alertController.addAction(createAction)
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func updateTableView(notification: Notification) {
        guard let _ = notification.object as? [ItemEntity] else { return }
        self.tableView.reloadData()
    }
    
    @objc func createData(notification: Notification) {
        guard let _ = notification.object as? ItemEntity else { return }
        tableView.reloadData()
        
    }
}

extension ViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let item = self.items[indexPath.item]
        cell.setup(text: item.text ?? "error")
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextChanged(text: searchText)
        tableView.reloadData()
    }
}
