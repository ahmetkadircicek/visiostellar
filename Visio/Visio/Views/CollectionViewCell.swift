//
//  CollectionViewCell.swift
//  Visio
//
//  Created by Ahmet on 26.06.2023.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
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
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .label
        label.layer.borderColor = UIColor.gray.cgColor
        label.clipsToBounds = true
        return label
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(contentLabel)
        configureConstraints()
    }
    
    func configureConstraints() {
        let contentLabelConstraints = [
            contentLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ]
        
        NSLayoutConstraint.activate(contentLabelConstraints)
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
}
