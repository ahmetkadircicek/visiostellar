//
//  HomeViewController.swift
//  Visio
//
//  Created by Ahmet on 26.06.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var data: [Data] = [Data]()
    
    private let homeFeedCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeFeedCollection.delegate = self
        homeFeedCollection.dataSource = self
        view.addSubview(homeFeedCollection)
        configureNavbar()
        fetchSpaceNews()
    }
    
    private func configureNavbar() {
        let label = UILabel()
        label.text = "Visiostellar"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center

        navigationItem.titleView = label
    }


    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedCollection.frame = view.bounds
    }
    
    private func fetchSpaceNews() {
        APICaller.shared.getSpaceNews { [weak self] result in
            switch result {
            case .success(let news):
                self?.data = news
                DispatchQueue.main.async {
                    self?.homeFeedCollection.reloadData()
                }
            case .failure(let error):
                print("Haberleri alma hatası: \(error)")
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(data.count)
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let imageModel = data[indexPath.row].imageUrl else {
            print("Görüntü URL'si bulunamadı")
            return UICollectionViewCell()
        }
        
        guard let textModel = data[indexPath.row].title else {
            print("Başlık URL'si bulunamadı")
            return UICollectionViewCell()
        }
        
        cell.configureImage(with: imageModel)
        cell.configureTitle(with: textModel)
        cell.backgroundColor = .systemGray5
        cell.layer.cornerRadius = 32
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.shadowRadius = 4

        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 64, height: view.frame.size.width - 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
