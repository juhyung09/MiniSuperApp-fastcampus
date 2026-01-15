import UIKit
import RIBs

protocol AppRootPresentableListener: AnyObject {
  
}

final class RootTabBarController: UITabBarController, AppRootViewControllable, AppRootPresentable {
  weak var listener: AppRootPresentableListener?
  private var splashViewController: SplashViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tabBar.isTranslucent = false
    tabBar.tintColor = .black
    tabBar.backgroundColor = .white
  }
  
  func setViewControllers(_ viewControllers: [ViewControllable]) {
    super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
  }

  func showSplash() {
    guard splashViewController == nil else { return }

    let splashViewController = SplashViewController()
    splashViewController.modalPresentationStyle = .fullScreen
    present(splashViewController, animated: false)
    self.splashViewController = splashViewController
  }

  func hideSplash() {
    guard let splashViewController else { return }

    splashViewController.dismiss(animated: false)
    self.splashViewController = nil
  }
}
