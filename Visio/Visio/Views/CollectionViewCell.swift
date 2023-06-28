//
//  CollectionViewCell.swift
//  Visio
//
//  Created by Ahmet on 26.06.2023.
//

import UIKit
import SDWebImage

protocol CollectionViewCellDelegate: NSObjectProtocol {
    func topButtonTouched(indexPath: IndexPath)
}

class CollectionViewCell: UICollectionViewCell {

    static let identifier = "CollectionViewCell"

    private var tapGesture: UITapGestureRecognizer!

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
        label.numberOfLines = 2
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

    public let newsSiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .label
        label.layer.borderColor = UIColor.gray.cgColor
        label.clipsToBounds = true
        return label
    }()

    public var linkURL: URL?

    public let urlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.layer.borderColor = UIColor.gray.cgColor
        label.clipsToBounds = true
        label.text = "Click here for details..."
        label.underlineText()
        label.isUserInteractionEnabled = true
        label.isHidden = true
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(newsSiteLabel)
        contentView.addSubview(urlLabel)

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        urlLabel.addGestureRecognizer(tapGesture)

        configureConstraints()
    }

    public func configureForSearchView(with model: String) {
        contentLabel.text = model
        contentLabel.font = .systemFont(ofSize: 10, weight: .regular)

        let contentLabelConstraints = [
            contentLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentLabel.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(contentLabelConstraints)
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

        let newsSiteLabelConstraints = [
            newsSiteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            newsSiteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ]

        let urlLabelConstraints = [
            urlLabel.centerYAnchor.constraint(equalTo: newsSiteLabel.centerYAnchor),
            urlLabel.leadingAnchor.constraint(equalTo: newsSiteLabel.trailingAnchor, constant: 4)
        ]

        NSLayoutConstraint.activate(contentLabelConstraints)
        NSLayoutConstraint.activate(summaryLabelConstraints)
        NSLayoutConstraint.activate(newsSiteLabelConstraints)
        NSLayoutConstraint.activate(urlLabelConstraints)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.width * 5/6)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if let url = linkURL {
            UIApplication.shared.open(url)
        } else {
            print("URL is nil")
        }
    }
    
    public func configureImage(with model: String) {
        guard let url = URL(string: model) else {
            print("Invalid image URL: \(model)")
            return
        }
        print(model)

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Image loading error: \(error.localizedDescription)")
                return
            }

            if let imageData = data, let image = UIImage(data: imageData) {
                let scaledImage = image.scaleImageToSize(CGSize(width: 100, height: 100))
                DispatchQueue.main.async {
                    self.imageView.image = scaledImage
                }
            }
        }.resume()
    }

    public func configureTitle(with model: String) {
        contentLabel.text = model
    }

    public func configureSummary(with model: String) {
        summaryLabel.text = model
    }

    public func configureNewsSite(with model: String) {
        newsSiteLabel.text = model
    }
    
    func configureURL(with url: URL) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        urlLabel.addGestureRecognizer(tapGesture)
        linkURL = url
    }
}
