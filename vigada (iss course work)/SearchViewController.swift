//
//  SearchViewController.swift
//  vigada (iss course work)
//
//  Created by Maxim Marchuk on 20.11.2019.
//  Copyright © 2019 Maxim Marchuk. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let reuseId = "UITableViewCellreuseId"
    private var searchController: UISearchController?
    private var pendingRequestWorkItem: DispatchWorkItem?
    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        view.backgroundColor = .white

        setupTableView()
    }

    // MARK: - Set up
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        tableView.register(SearchRecentTableViewCell.self, forCellReuseIdentifier: "SearchRecentTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.VGDColor.clear

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0)
            ])

        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Find the game..."
        searchController?.searchBar.showsCancelButton = false
        searchController?.searchBar.showsBookmarkButton = false
        searchController?.searchBar.barTintColor = UIColor.VGDColor.blue
        searchController?.searchBar.tintColor = UIColor.VGDColor.black
        searchController?.searchBar.delegate = self
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.searchBarStyle = UISearchBar.Style.minimal

        let textFieldInsideUISearchBar = searchController?.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.font = SFMono.regular.of(size: 14)

        tableView.tableHeaderView = searchController?.searchBar
    }
}

// MARK: - Extensions
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell
        cell?.settingView.settingLabel.text = "test"
        cell?.selectionStyle = .none
        if let cell = cell {
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            cell.textLabel?.text = "Broke 'Settings' table row"
            return cell
        }
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: переход на экран с детальной информацией по игре если результат
        // или новый поиск по последним поисковым запросам (может буду хранить выдачу)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 35, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0.3
        UIView.animate(withDuration: 0.55) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
        }
    }

}

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //print("update")
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("YES 2")
        // Тут сделаем так, чтобы показывать последние поисковые запросы снова
    }

    // задержку поискового запроса устанавливаем через DispatchWorkItem в 1 секунду
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let delay = 1
        if searchText.count > 2 {
            pendingRequestWorkItem?.cancel()
            let requestWorkItem = DispatchWorkItem { [weak self] in
                print("\(delay) секунд прошло, ищу \(searchText)...")
                // очищаем массив моделей и буфер картинок, чтобы показывать только ответ последнего поискового запроса (обнуляем состояние)
                //            self?.globalModels.removeAll()
                //            self?.imagesBuffer.removeAll()
                //            self?.page = 1
                // вызов метода поиска
                //            self?.search(by: "\(searchText)")
                // запоминание поискового запроса для последующих постраничных вызовов
                //            self?.searchTextGlobal = searchText
            }
            pendingRequestWorkItem = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay), execute: requestWorkItem)
        } else {
            print("поле поиска не активно")
        }
    }
}
