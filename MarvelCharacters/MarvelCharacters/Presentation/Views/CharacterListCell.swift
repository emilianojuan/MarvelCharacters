//
//  CharacterListCell.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 12/05/2022.
//

import UIKit

class CharacterListCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
