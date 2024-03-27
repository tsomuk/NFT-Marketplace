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
        table.showsVerticalScrollIndicator = false
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setNavItem()
    }
}

private extension StatisticsViewController {
    func setNavItem() {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.addTarget(self, action: #selector(sortAction), for: .touchUpInside)
        
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
    
     @objc func sortAction() {
         let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
         
         let nameSort = UIAlertAction(title: "По имени", style: .default) { _ in
             print("Sort NAME")
         }
         let ratingSort = UIAlertAction(title: "По рейтингу", style: .default) { _ in
             print("Sort RATING")
         }
         
         let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
         
         alert.addAction(nameSort)
         alert.addAction(ratingSort)
         alert.addAction(cancelAction)
         
         self.present(alert, animated: true, completion: nil)
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RatingCell.identifier) as? RatingCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  96
    }
}
