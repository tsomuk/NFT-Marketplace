import Kingfisher
import ProgressHUD
import UIKit

final class CatalogViewController: UIViewController {
    private let servicesAssembly: ServicesAssembly

    private var allCollections: [Collection] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: "CatalogCell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        return tableView
    }()

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBar()
        loadCollection()

        view.backgroundColor = .systemBackground

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaInsets).inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func loadCollection() {
        ProgressHUD.show()
        let request = CatalogRequest()
        let networkService = DefaultNetworkClient()
        networkService.send(request: request, type: [Collection].self) { [weak self] result in
            switch result {
            case .success(let collections):
                self?.allCollections = collections
                self?.tableView.reloadData()
                ProgressHUD.dismiss()
                self?.tableView.reloadData()
            case .failure(let error):
                assertionFailure(error.localizedDescription)
                ProgressHUD.dismiss()
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
    }

    @objc private func sortedCatalog() {

    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allCollections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CatalogCell",
            for: indexPath
        ) as? CatalogTableViewCell else {
            return UITableViewCell()
        }

        guard let urlString = allCollections[indexPath.row].cover.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) else { return cell }

        cell.configure(
            imageURL: URL(string: urlString),
            label: "\(allCollections[indexPath.row].name) (\(allCollections[indexPath.row].nfts.count))"
        )
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        return cell
    }
}
