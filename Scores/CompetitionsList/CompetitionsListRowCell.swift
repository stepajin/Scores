//
//  CompetitionsListRowCell.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import UIKit

final class CompetitionsListRowCell: UITableViewCell {
    static let id: String = "CompetitionRowCell"
    
    let nameLabel = UILabel()
    let emblemImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        contentView.addSubview(nameLabel)
        
        emblemImageView.translatesAutoresizingMaskIntoConstraints = false
        emblemImageView.contentMode = .scaleAspectFill
        
        contentView.addSubview(emblemImageView)
        
        contentView.addConstraints([
            emblemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emblemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emblemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            emblemImageView.heightAnchor.constraint(equalToConstant: 32),
            emblemImageView.widthAnchor.constraint(equalTo: emblemImageView.heightAnchor, multiplier: 1),
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: emblemImageView.trailingAnchor  , constant: 24)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
