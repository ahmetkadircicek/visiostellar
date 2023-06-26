//
//  CollectionViewCell.swift
//  Visio
//
//  Created by Ahmet on 26.06.2023.
//

import UIKit
import SDWebImage

protocol CollectionViewCellDelegate:NSObjectProtocol{
   func topButtonTouched(indexPath:IndexPath)
}

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
    weak var delegate: CollectionViewCellDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 32
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return imageView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .label
        label.layer.borderColor = UIColor.gray.cgColor
        label.clipsToBounds = true
        return label
    }()
    
    public let summaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        label.textColor = .label
        label.layer.borderColor = UIColor.gray.cgColor
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()

 
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(summaryLabel)
        configureConstraints()
    }
    
    func configureConstraints() {
        let contentLabelConstraints = [
            contentLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentLabel.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let summaryLabelConstraints = [
            summaryLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor),
            summaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            summaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ]
        
        NSLayoutConstraint.activate(contentLabelConstraints)
        NSLayoutConstraint.activate(summaryLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.width * 5/6)
    }
    
    public func configureImage(with model: String) {
        guard let url = URL(string: model) else {
            print("Geçersiz görüntü URL'si: \(model)")
            return
        }
        
        imageView.sd_setImage(with: url, completed: nil)
    }
    
    public func configureTitle(with model: String) {
        contentLabel.text = model
    }
    
    public func configureSummary(with model: String) {
        summaryLabel.text = model
    }
}
