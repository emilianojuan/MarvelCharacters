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

//        nameLabel.font = R.Font.subtitle
        nameLabel.textColor = .black
        backgroundColor = .cyan
        thumbnailImageView.layer.borderWidth = 2
        thumbnailImageView.layer.borderColor = UIColor.red.cgColor
        thumbnailImageView.layer.borderColor = UIColor.red.cgColor
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.height / 2
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.backgroundColor = .red
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.tintColor = .blue

        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, nameLabel])
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        stackView.edgeAnchors == contentView.edgeAnchors
    }
}
