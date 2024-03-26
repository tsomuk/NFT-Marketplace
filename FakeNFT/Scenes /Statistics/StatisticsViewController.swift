//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 22.03.2024.
//

import UIKit
import SnapKit

class StatisticsViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(RatingCell.self, forCellReuseIdentifier: RatingCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.allowsSelection = false
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setNavItem()
    }
    
    func setNavItem() {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(named: "sort"), for: .normal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func setView() {
        view.backgroundColor = .white
        
        //TableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(83)
            make.top.equalToSuperview().inset(88)
        }
        
    }
}


extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RatingCell.identifier) as? RatingCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    
}
