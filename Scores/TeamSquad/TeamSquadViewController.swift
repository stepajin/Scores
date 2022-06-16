//
//  TeamSquadViewController.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import UIKit

struct TeamSquadSection {
    let name: String
    let players: [Player]
}

final class TeamSquadViewController: UIViewController {
    
    var viewModel: TeamSquadViewModel!
    
    private let scrollView = UIScrollView()
    private let crestImageView = UIImageView()
    private let stackView = UIStackView()
   
    private var sections: [TeamSquadSection] = []
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard viewModel.onSquadUpdated == nil else { return }
        bindViewModel()
        viewModel.fetchTeam()
    }
    
    private func setupNavigationBar() {
        title = "Squad"
        tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: "person.3.sequence"),
            selectedImage: UIImage(systemName: "person.3.sequence.fill")
        )
    }
    
    private func setupView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        crestImageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(crestImageView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .fill
        scrollView.addSubview(stackView)
        
        crestImageView.contentMode = .scaleAspectFit
        crestImageView.setImage(url: viewModel.team.crestURL)
    }
    
    private func setupLayout() {
        view.addConstraints([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            crestImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            crestImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            crestImageView.heightAnchor.constraint(equalToConstant: 120),
            crestImageView.widthAnchor.constraint(equalTo: crestImageView.widthAnchor, multiplier: 1),
            
            stackView.topAnchor.constraint(equalTo: crestImageView.bottomAnchor, constant: 30),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
    
    private func prepareRowView(player: Player) -> UIView {
        let flagLabel = UILabel()
        flagLabel.translatesAutoresizingMaskIntoConstraints = false
        flagLabel.text = FlagMap.map[player.nationality ?? ""]?.emoji ?? "🌎"
        flagLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = player.name
        nameLabel.textAlignment = .left
        nameLabel.textColor = .darkGray
        nameLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.spacing = 12
        rowStackView.alignment = .center
        rowStackView.translatesAutoresizingMaskIntoConstraints = false
        
        rowStackView.addArrangedSubview(flagLabel)
        rowStackView.addArrangedSubview(nameLabel)

        rowStackView.tag = player.id
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playerSelectedAction(_:)))
        rowStackView.addGestureRecognizer(tapGesture)
        return rowStackView
    }
    
    private func prepareSectionView(_ section: TeamSquadSection) -> UIView {
        let sectionStackView = UIStackView()
        sectionStackView.translatesAutoresizingMaskIntoConstraints = false
        sectionStackView.axis = .vertical
        sectionStackView.alignment = .center
        sectionStackView.spacing = 20
        
        if !section.name.isEmpty {
            let nameLabel = UILabel()
            nameLabel.text = section.name
            nameLabel.textColor = .darkGray
            nameLabel.font = .boldSystemFont(ofSize: 20)
            sectionStackView.addArrangedSubview(nameLabel)
        }
        
        let rows = section.players.map(prepareRowView(player: ))
        rows.forEach(sectionStackView.addArrangedSubview(_:))
        
        return sectionStackView
    }
    
    private func bindViewModel() {
        viewModel.onSquadUpdated = { [weak self] squad in
            self?.updateSquad(squad)
        }
    }
    
    private func updateSquad(_ squad: [TeamSquadSection]) {
        let sectionViews = squad.map(prepareSectionView(_:))
        sectionViews.forEach(stackView.addArrangedSubview(_:))
        view.layoutIfNeeded()
    }
    
    @objc private func playerSelectedAction(_ sender: UITapGestureRecognizer) {
        guard let id = sender.view?.tag else { return }
        viewModel.selectPlayer(id: id)
    }
}
