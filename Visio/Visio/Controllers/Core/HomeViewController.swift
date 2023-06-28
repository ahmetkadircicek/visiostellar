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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Visiostellar"
        label.font = .systemFont(ofSize: 32, weight: .ultraLight)
        label.textColor = .label
        label.textAlignment = .center
        return label
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
        navigationItem.titleView = titleLabel
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
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        topButtonTouched(indexPath: indexPath)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        topButtonTouched(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = data[indexPath.row]
        
        guard let imageModel = item.imageUrl else {
            print("Görüntü URL'si bulunamadı")
            return UICollectionViewCell()
        }
        
        guard let textModel = item.title else {
            print("Başlık URL'si bulunamadı")
            return UICollectionViewCell()
        }
        
        guard let summaryModel = item.summary else {
            print("Başlık URL'si bulunamadı")
            return UICollectionViewCell()
        }
        
        guard let newsSiteModel = item.newsSite else {
            print("Başlık URL'si bulunamadı")
            return UICollectionViewCell()
        }
        
        guard let urlString = item.url, let newsUrl = URL(string: urlString) else {
            print("Invalid URL: \(item.url ?? "")")
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        
        cell.configureImage(with: imageModel)
        cell.configureTitle(with: textModel)
        cell.configureSummary(with: summaryModel)
        cell.configureNewsSite(with: newsSiteModel)
        cell.configureURL(with: newsUrl)
        cell.backgroundColor = .systemGray5
        cell.layer.cornerRadius = 32
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.shadowRadius = 4
        
        cell.summaryLabel.isHidden = !isExpanded[indexPath.row]
        cell.newsSiteLabel.isHidden = !isExpanded[indexPath.row]
        cell.urlLabel.isHidden = !isExpanded[indexPath.row]
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = data[indexPath.row].summary
        
        let label = UILabel()
        label.text = item
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        
        let labelWidth = collectionView.frame.size.width - 64
        let labelSize = label.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let cellHeight = labelSize.height + 64
        
        if isExpanded[indexPath.row] == true{
            return CGSize(width: view.frame.size.width - 64, height: view.frame.size.width - 64 + cellHeight)
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
                    cell.newsSiteLabel.isHidden = false
                    cell.urlLabel.isHidden = false
                } else {
                    cell.summaryLabel.isHidden = true
                    cell.newsSiteLabel.isHidden = true
                    cell.urlLabel.isHidden = true
                }
            }
        
        isExpanded[indexPath.row] = !isExpanded[indexPath.row]
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseInOut, animations: {
              self.homeFeedCollection.reloadItems(at: [indexPath])
            }, completion: { success in
        })
    }
}
