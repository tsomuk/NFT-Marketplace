//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 22.03.2024.
//

import UIKit
import SnapKit
import Kingfisher

class StatisticsViewController: UIViewController {
    private let service = StatisticServiceImpl()
    
    private var usersServiceObserver: NSObjectProtocol?
    private var users = [User]()
    
   private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(RatingCell.self, forCellReuseIdentifier: RatingCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.allowsSelection = false
        table.showsVerticalScrollIndicator = false
        
        return table
    }()
    
    private let progressIndicator: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView()
        progress.isHidden = true
        
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
        setView()
        setNavItem()
    }
}

private extension StatisticsViewController {
    
    func loadUsers() {
        isHidenProgress()
        
        service.fetchUsersNextPage()
        usersServiceObserver = NotificationCenter.default.addObserver(forName: StatisticServiceImpl.didChangeNotification,
                                                                      object: nil,
                                                                      queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.users = service.users
            self.tableView.reloadData()
            isHidenProgress()
        }
    }
    
    func setNavItem() {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.addTarget(self, action: #selector(sortAction), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func isHidenProgress() {
        if users.isEmpty {
            progressIndicator.startAnimating()
            progressIndicator.isHidden = false
        } else {
            progressIndicator.stopAnimating()
            progressIndicator.isHidden = true
        }
    }
    
    func setView() {
        view.backgroundColor = .white
        
        //TableView
        view.addSubview(tableView)
        view.addSubview(progressIndicator)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(83)
            make.top.equalToSuperview().inset(88)
        }
        
        progressIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(tableView)
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
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RatingCell.identifier) as? RatingCell else {
            return UITableViewCell()
        }
        
        let user = users[indexPath.row]
        
        cell.config(countUsers: indexPath.row + 1,
                    name: user.name,
                    rating: user.rating)
        
        let processor = RoundCornerImageProcessor(cornerRadius: cell.avatarImageView.bounds.height / 2)
        
        cell.avatarImageView.kf.setImage(with: user.avatar,
                                         placeholder: UIImage(named: "profile"),
                                         options: [.processor(processor)]) {[weak self] res in
            guard let self = self else { return }
            
            switch res {
                
            case .success(_):
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(_):
                print("изображение не загружено")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == service.users.count {
            service.fetchUsersNextPage()
        }
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  96
    }
}
