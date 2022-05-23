//
//  CharacterListCell.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 12/05/2022.
//

import UIKit
import Anchorage
import Kingfisher

final class CharacterListCell: UICollectionViewCell {

    enum Constants {
        static let nameLabelHeightAnchor: CGFloat = 30.0
        static let isHighlightedAlpha: CGFloat = 0.9
        static let isNotHighlightedAlpha: CGFloat = 1.0
        static let highlightedScaling: CGFloat = 0.97
        static let compactFontSize: CGFloat = 14.0
        static let regularFontSize: CGFloat = 18.0
    }

    private let thumbnailImageView = UIImageView()
    private let nameLabel = UILabel()

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
        nameLabel.heightAnchor == Constants.nameLabelHeightAnchor
    }

    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }

    private func toggleIsHighlighted() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = self.isHighlighted ? Constants.isHighlightedAlpha : Constants.isNotHighlightedAlpha
            self.transform = self.isHighlighted ?
            CGAffineTransform.identity.scaledBy(x: Constants.highlightedScaling, y: Constants.highlightedScaling) :
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
        let fontSize = traitCollection.horizontalSizeClass == .compact ? Constants.compactFontSize : Constants.regularFontSize
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
