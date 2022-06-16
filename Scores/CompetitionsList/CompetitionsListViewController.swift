//
//  CompetitionsListViewController.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import UIKit

struct CompetitionListRow {
    let id: Int
    let name: String
    let emblemURL: URL?
}

struct CompetitionsListSection {
    let title: String
    let rows: [CompetitionListRow]
}

final class CompetitionsListViewController: UIViewController {
    var viewModel: CompetitionsListViewModel!
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private var sections: [CompetitionsListSection] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupLayout()
        bindViewModel()
        viewModel.fetchCompetitons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard sections.count > 0 else { return }
        viewModel.refreshCompetitions()
    }
    
    private func setupNavigationBar() {
        self.title = "Competitions"
    }
    
    private func setupView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CompetitionsListRowCell.self, forCellReuseIdentifier: CompetitionsListRowCell.id)
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        view.addConstraints([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onCompetitionsUpdated = { [weak self] sections in
            self?.displaySections(sections)
        }
    }
    
    private func displaySections(_ sections: [CompetitionsListSection]) {
        self.sections = sections
        tableView.reloadData()
    }
}

extension CompetitionsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section < sections.count else { return }
        let row = sections[indexPath.section].rows[indexPath.row]
        viewModel.selectCompetition(row.id)
    }
}

extension CompetitionsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < sections.count else { return 0 }
        return sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < sections.count, indexPath.row < sections[indexPath.section].rows.count else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CompetitionsListRowCell.id) as? CompetitionsListRowCell else {
            return UITableViewCell()
        }
        
        let competition = sections[indexPath.section].rows[indexPath.row]
        cell.nameLabel.text = competition.name
        cell.emblemImageView.setImage(url: competition.emblemURL)

        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
