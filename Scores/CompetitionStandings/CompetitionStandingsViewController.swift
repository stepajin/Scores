//
//  CompetitionStandingsViewController.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Foundation
import UIKit

final class CompetitionStandingsViewController: UIViewController {
    
    var viewModel: CompetitionStandingsViewModel!
    
    private let standingsView = CompetitionStandingsView()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        bindViewModel()
        viewModel.fetchTable()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        standingsView.translatesAutoresizingMaskIntoConstraints = false
        standingsView.emblemImageView.setImage(url: viewModel.competition.emblemURL)
        view.addSubview(standingsView)
    }
    
    private func setupLayout() {
        view.addConstraints([
            standingsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            standingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            standingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            standingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Standings"
        tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: "list.number"),
            selectedImage: UIImage(systemName: "list.number.fill")
        )
    }
    
    private func bindViewModel() {
        viewModel.onTableUpdated = { [weak self] table in
            self?.displayTable(table)
        }
        standingsView.onRowSelected = { [weak self] id in
            self?.viewModel.selectTablePosition(id)
        }
    }
    
    private func displayTable(_ table: [TableItem]) {
        let items = table.map { item in
            CompetitionStandingsView.Item(
                id: item.position,
                position: item.position,
                name: item.team.name,
                imageURL: item.team.crestURL,
                points: item.points
            )
        }
        standingsView.displayStandings(items)
    }
}
