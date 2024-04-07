import Kingfisher
import ProgressHUD
import UIKit

final class CatalogViewController: UIViewController {
    private let servicesAssembly: ServicesAssembly

    private var allCollections: [CatalogCollection] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
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

    private func loadCollection() {
        ProgressHUD.show()
        let request = CatalogRequest()
        let networkService = DefaultNetworkClient()
        networkService.send(request: request, type: [CatalogCollection].self) { [weak self] result in
            switch result {
            case .success(let collections):
                DispatchQueue.main.async {
                    self?.allCollections = collections
                    self?.tableView.reloadData()
                    ProgressHUD.dismiss()
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
                ProgressHUD.dismiss()
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
    }

    // TODO: - Добавить сортировку каталога
    @objc private func sortedCatalog() {

    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allCollections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CatalogCell", for: indexPath
        ) as? CatalogTableViewCell,
        let urlString = allCollections[indexPath.row].cover.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) else {
            return UITableViewCell()
        }

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
