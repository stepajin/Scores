//
//  CompetitionStandingsView.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Foundation
import UIKit

final class CompetitionStandingsView: UIScrollView {
    struct Item {
        let id: Int
        let position: Int
        let name: String
        let imageURL: URL?
        let points: Int
    }
    
    let emblemImageView = UIImageView()
    let stackView = UIStackView()

    var onRowSelected: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayStandings(_ items: [Item]) {
        let rows = items.map(prepareRowView(item:))
        rows.forEach(stackView.addArrangedSubview(_:))
        layoutIfNeeded()
    }
    
    private func setup() {
        emblemImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emblemImageView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        addSubview(stackView)
        
        emblemImageView.contentMode = .scaleAspectFit
    }
    
    private func setupLayout() {
        addConstraints([
            emblemImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            emblemImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emblemImageView.heightAnchor.constraint(equalToConstant: 120),
            emblemImageView.widthAnchor.constraint(equalTo: emblemImageView.widthAnchor, multiplier: 1),
            
            stackView.topAnchor.constraint(equalTo: emblemImageView.bottomAnchor, constant: 20),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -40),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    private func prepareRowView(item: Item) -> UIView {
        let positionLabel = UILabel()
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        positionLabel.text = "\(item.position)"
        positionLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        positionLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        positionLabel.layer.cornerRadius = 8
        positionLabel.layer.masksToBounds = true
        positionLabel.textAlignment = .center
        positionLabel.addConstraints([
            positionLabel.heightAnchor.constraint(equalToConstant: 36),
            positionLabel.widthAnchor.constraint(equalTo: positionLabel.heightAnchor, multiplier: 1)
        ])

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addConstraints([
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1)
        ])
        if let imageURL = item.imageURL {
            imageView.setImage(url: imageURL)
        }
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "\(item.name)"
        nameLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let pointsLabel = UILabel()
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pointsLabel.backgroundColor = UIColor.lightGray
        pointsLabel.layer.cornerRadius = 8
        pointsLabel.layer.masksToBounds = true
        pointsLabel.textAlignment = .center
        pointsLabel.addConstraints([
            pointsLabel.heightAnchor.constraint(equalToConstant: 36),
            pointsLabel.widthAnchor.constraint(equalTo: pointsLabel.heightAnchor, multiplier: 1)
        ])
        pointsLabel.text = "\(item.points)"
        
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.spacing = 12
        rowStackView.alignment = .center
        rowStackView.translatesAutoresizingMaskIntoConstraints = false
        
        rowStackView.addArrangedSubview(positionLabel)
        rowStackView.addArrangedSubview(imageView)
        rowStackView.addArrangedSubview(nameLabel)
        rowStackView.addArrangedSubview(pointsLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rowSelectedAction(_:)))
        rowStackView.tag = item.id
        rowStackView.addGestureRecognizer(tapGesture)
        
        return rowStackView
    }
    
    @objc private func rowSelectedAction(_ sender: UITapGestureRecognizer) {
        guard let id = sender.view?.tag else { return }
        onRowSelected?(id)
    }
}
