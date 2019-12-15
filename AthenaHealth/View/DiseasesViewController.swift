//
//  DiseasesViewController.swift
//  AthenaHealth
//
//  Created by Saurav Satpathy on 15/12/19.
//  Copyright © 2019 Saurav Satpathy. All rights reserved.
//

import Foundation
import UIKit
class DiseasesViewController: UIViewController {
    var dataViewModel: DataViewModel!
    override func viewDidLoad() {
        
    }
}
extension DiseasesViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataViewModel.topics?.content.count ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30)
        label.text = "  Diseases"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let content = dataViewModel.topics?.content[indexPath.row]
        cell.textLabel?.text = content?[1] as? String
        return cell
    }
}

extension DiseasesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .none)
        let diseaseViewController = storyboard.instantiateViewController(withIdentifier: "DiseaseViewController") as! DiseaseViewController
        diseaseViewController.dataViewModel = dataViewModel
        let content = dataViewModel.topics?.content[indexPath.row]
        diseaseViewController.selectedDisease = content?[1] as! String
        navigationController?.pushViewController(diseaseViewController, animated: true)
    }
}

