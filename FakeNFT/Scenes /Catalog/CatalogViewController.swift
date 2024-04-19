import Kingfisher
import ProgressHUD
import UIKit

final class CatalogViewController: UIViewController {
    private let servicesAssembly: ServicesAssembly

    private var allCollections: [CatalogCollection] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .nftWhite
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: "CatalogCell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
            tabBarController?.tabBar.isHidden = false
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBar()
        loadCollection()

        view.backgroundColor = .nftWhite

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaInsets).inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func loadCollection() {
        ProgressHUD.show()
        let request = CatalogRequest()
        let networkService = DefaultNetworkClient()
        networkService.send(request: request, type: [CatalogCollection].self) { [weak self] result in
            ProgressHUD.dismiss()
            switch result {
            case .success(let collections):
                DispatchQueue.main.async {
                    self?.allCollections = collections
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
                ProgressHUD.showError()
                return
            }
        }
    }

    private func setupBar() {
        let addButtonImage = UIImage(named: "sort")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: addButtonImage,
            style: .plain,
            target: self,
            action: #selector(sortedCatalog)
        )
        navigationItem.rightBarButtonItem?.tintColor = .nftBlack
    }

    @objc private func sortedCatalog() {
        let alert = UIAlertController(
            title: "Catalog.sort"~,
            message: nil,
            preferredStyle: .actionSheet)
        let nameSortedAction = UIAlertAction(title: "Catalog.sortTitle"~, style: .default) { [weak self] _ in
            self?.sortedNameCollections()
            self?.tableView.reloadData()
        }
        alert.addAction(nameSortedAction)

        let countNftSortedAction = UIAlertAction(title: "Catalog.sortNftAmount"~, style: .default) { [weak self] _ in
            self?.sortedCountNftCollections()
            self?.tableView.reloadData()
        }
        alert.addAction(countNftSortedAction)
        let cancelAction = UIAlertAction(title: "Catalog.sortClose"~, style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func sortedNameCollections() {
        allCollections.sort(by: {$0.name < $1.name})
    }

    private func sortedCountNftCollections() {
        allCollections.sort(by: {$0.nfts.count < $1.nfts.count})
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allCollections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogCell", for: indexPath) as? CatalogTableViewCell,
        let urlString = allCollections[indexPath.row].cover.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) else {
            return UITableViewCell()
        }
        cell.backgroundColor = .nftWhite
        cell.configure(
            imageURL: URL(string: urlString),
            label: "\(allCollections[indexPath.row].name) (\(allCollections[indexPath.row].nfts.count))"
        )
        return cell
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = CatalogCollectionViewController(
            servicesAssembly: servicesAssembly,
            catalogCollection: allCollections[indexPath.row]
        )
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: false)
    }
}
