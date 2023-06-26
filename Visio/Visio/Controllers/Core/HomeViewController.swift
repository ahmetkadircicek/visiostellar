//
//  HomeViewController.swift
//  Visio
//
//  Created by Ahmet on 26.06.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var data: [Data] = [Data]()
    
    var isExpanded = [Bool]()
    
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
        
        isExpanded = Array(repeating: false, count: data.count)
    }
    
    private func configureNavbar() {
        let label = UILabel()
        label.text = "Visiostellar"
        label.font = .systemFont(ofSize: 32, weight: .ultraLight)
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
                self?.isExpanded = Array(repeating: false, count: news.count)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        topButtonTouched(indexPath: indexPath)
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
        
        guard let summaryModel = data[indexPath.row].summary else {
            print("Başlık URL'si bulunamadı")
            return UICollectionViewCell()
        }
        
        if isExpanded[indexPath.row] {
            cell.summaryLabel.isHidden = false
        } else {
            cell.summaryLabel.isHidden = true
        }
        
        cell.delegate = self
        
        cell.configureImage(with: imageModel)
        cell.configureTitle(with: textModel)
        cell.configureSummary(with: summaryModel)
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

        if isExpanded[indexPath.row] == true{
            return CGSize(width: view.frame.size.width - 64, height: (view.frame.size.width - 64)*2)
        }else{
            return CGSize(width: (view.frame.size.width - 64), height: (view.frame.size.width - 64))
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

extension HomeViewController:CollectionViewCellDelegate{
    func topButtonTouched(indexPath: IndexPath) {
        
        if let cell = homeFeedCollection.cellForItem(at: indexPath) as? CollectionViewCell {
                if isExpanded[indexPath.row] {
                    cell.summaryLabel.isHidden = false
                } else {
                    cell.summaryLabel.isHidden = true
                }
            }
        
        isExpanded[indexPath.row] = !isExpanded[indexPath.row]
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseInOut, animations: {
              self.homeFeedCollection.reloadItems(at: [indexPath])
            }, completion: { success in
                print("success")
        })
    }
}
