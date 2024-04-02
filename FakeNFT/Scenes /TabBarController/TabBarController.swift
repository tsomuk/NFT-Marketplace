import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly

    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(systemName: "person.crop.circle.fill"),
        tag: 0
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(systemName: "cart.fill"),
        tag: 2
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 3
    )
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }
 
    private func configureTabs() {
        let profileController = ProfileViewController()
        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        let cartController = CartViewController(servicesAssembly: servicesAssembly)
        let cardNavigationController = UINavigationController(rootViewController: cartController)
        let statisticsController = StatisticsViewController()
        profileController.tabBarItem = profileTabBarItem
        catalogController.tabBarItem = catalogTabBarItem
        cartController.tabBarItem = cartTabBarItem
        statisticsController.tabBarItem = statisticsTabBarItem
        viewControllers = [profileController, catalogController, cardNavigationController, statisticsController]
    }
}
