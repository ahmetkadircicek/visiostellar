//
//  ViewController.swift
//  Visio
//
//  Created by Ahmet on 26.06.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())

        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc1.tabBarItem.selectedImage = UIImage(systemName: "house.fill")

        
        vc1.title = "Home"

        
        tabBar.tintColor = .label
        setViewControllers([vc1], animated: true)
    }
}


