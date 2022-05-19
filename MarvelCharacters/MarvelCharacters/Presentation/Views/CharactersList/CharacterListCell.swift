//
//  CharacterListCell.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 12/05/2022.
//

import UIKit
import Anchorage
import Kingfisher

class CharacterListCell: UICollectionViewCell {

    let thumbnailImageView = UIImageView()
    let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        nameLabel.numberOfLines = 1
        thumbnailImageView.backgroundColor = UIColor.systemGray6
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(nameLabel)
        thumbnailImageView.topAnchor == contentView.topAnchor
        thumbnailImageView.leadingAnchor == contentView.leadingAnchor
        thumbnailImageView.trailingAnchor == contentView.trailingAnchor
        nameLabel.bottomAnchor == contentView.bottomAnchor
        nameLabel.leadingAnchor == contentView.leadingAnchor
        nameLabel.trailingAnchor == contentView.trailingAnchor
        nameLabel.topAnchor == thumbnailImageView.bottomAnchor
        nameLabel.heightAnchor == 30
    }

    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }

    func toggleIsHighlighted() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = self.isHighlighted ? 0.9 : 1.0
            self.transform = self.isHighlighted ?
                CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
                CGAffineTransform.identity
        })
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        nameLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let fontSize = traitCollection.horizontalSizeClass == .compact ? 14.0 : 18.0
        nameLabel.font = .boldSystemFont(ofSize: fontSize)
    }

    func configure(with characterItem: CharacterListItem) {
        thumbnailImageView.kf.indicatorType = .activity
        if let url = characterItem.thumbnailURL {
            thumbnailImageView.kf.setImage(with: url,
                                           options: [.transition(.fade(1)),
                                                     .cacheOriginalImage])

        }
        nameLabel.text = characterItem.name
    }
}
