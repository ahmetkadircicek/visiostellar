//
//  SplashViewController.swift
//  Visio
//
//  Created by Ahmet on 27.06.2023.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "moon.stars.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Visiostellar"
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(splashImageView)
        view.addSubview(titleLabel)
        configureConstraints()
    }
    
    func configureConstraints() {
        let splashImageConstraints = [
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -64),
            splashImageView.heightAnchor.constraint(equalToConstant: 128),
            splashImageView.widthAnchor.constraint(equalToConstant: 128)
        ]
        let titleLabelConstraints = [
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 32),
            titleLabel.heightAnchor.constraint(equalToConstant: 256),
            titleLabel.widthAnchor.constraint(equalToConstant: 256)
        ]
        NSLayoutConstraint.activate(splashImageConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.view.window?.rootViewController = MainTabBarViewController()
        }
    }
}
