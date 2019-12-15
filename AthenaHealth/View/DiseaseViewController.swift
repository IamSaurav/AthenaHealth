//
//  DiseaseViewController.swift
//  AthenaHealth
//
//  Created by Saurav Satpathy on 16/12/19.
//  Copyright © 2019 Saurav Satpathy. All rights reserved.
//

import Foundation
import UIKit
class DiseaseViewController: UIViewController {
    var dataViewModel: DataViewModel!
    var selectedDisease: String!
    override func viewDidLoad() {
        let title = dataViewModel.disease(for: "83")
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 120, width: view.frame.size.width-40, height: 50)
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.text = title
        view.addSubview(label)
    }
    
    
}
