import UIKit

final class SplashViewController: UIViewController {
  private let titleLabel = UILabel()
  private let activityIndicator = UIActivityIndicatorView(style: .large)

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    titleLabel.text = "MiniSuperApp"
    titleLabel.font = .boldSystemFont(ofSize: 28)
    titleLabel.textColor = .black
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()

    view.addSubview(titleLabel)
    view.addSubview(activityIndicator)

    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)
    ])
  }
}
