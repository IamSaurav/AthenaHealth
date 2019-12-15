//
//  ViewController.swift
//  AthenaHealth
//
//  Created by Saurav Satpathy on 13/12/19.
//  Copyright © 2019 Saurav Satpathy. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    lazy var dataViewModel = DataViewModel()
    var categoriesViewModel: CategoriesViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        dataViewModel.downloadData()
        dataViewModel.receivedData = { [unowned self] in
           self.tableView.reloadData()
        }
    }
    
}

extension CategoriesViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataViewModel.categories?.content.count ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30)
        label.text = "  Departments"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let content = dataViewModel.categories?.content[indexPath.row]
        cell.textLabel?.text = content?.first as? String
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

