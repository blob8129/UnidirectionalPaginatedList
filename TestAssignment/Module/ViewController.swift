//
//  ViewController.swift
//  EFWeatherApp
//
//  Created by Andrey Volobuev on 12/4/18.
//  Copyright © 2018 blob8129. All rights reserved.
//
import UIKit

final class ViewController: UIViewController {

    var interactor: InteractorInput?
    private var users = [Entity]()
    private let userCellReuseIdentifier = "UserCellReuseIdentifier"
    private lazy var tableView: UITableView = { t in
        t.delegate = self
        t.dataSource = self
        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(UITableViewCell.self, forCellReuseIdentifier: userCellReuseIdentifier)
        return t
    }(UITableView())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.rightAnchor.constraint(equalTo: tableView.rightAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
        interactor?.start()
    }
}

extension ViewController: ViewInput {
    func render(state: ViewState) {
        switch state {
        case .loaded(let initialUsers):
            users = initialUsers
            tableView.reloadData()
        case .loadedNext(let nextUsers):
            let indexsPathToInsert = (users.count..<users.count+nextUsers.count) .map {
                IndexPath(row: $0, section: 0)
            }
            users.append(contentsOf: nextUsers)
            tableView.insertRows(at: indexsPathToInsert, with: .none)
        case .networkError:
            //TODO: Handle network error
            break
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == users.count - 1 {
            interactor?.willDisplayLast(slug: users[indexPath.row].slug)
            //TODO: Indicate activity
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}
