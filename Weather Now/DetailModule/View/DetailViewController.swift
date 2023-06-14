//
//  DetailViewController.swift
//  Weather Now
//
//  Created by user on 01.06.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModelProtocol!
    var tableView: TableViewDetail!
    //MARK: - searchBar
    var searchBar: UISearchBar = {
        var bar = UISearchBar()
        bar.barStyle = .black
        bar.placeholder = "Город, местность"
        
        return bar
    }()
    
    //MARK: -
    var cancelButton: UIButton = {
        var but = UIButton()
        but.setTitle("Отменить", for: .normal)
        but.setTitleColor(.black, for: .normal)
        but.backgroundColor = .white
        
        return but
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createConstraintsForTable()
        updateView()
        self.navigationItem.titleView = customView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.clipsToBounds = true
    }
    
    //MARK: - createConstraintsForTable
    func createConstraintsForTable() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.topAnchor),
            
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - func updateView()
    private func updateView() {
        viewModel.updateTableState = { [weak self] tableState in
            self?.tableView.tableState = tableState
        }
    }
    
    //MARK: - customView
    private func customView() -> UIView {
        //view
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        view.clipsToBounds = true
        
        
        self.searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/1.1, height: 44)
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonAction(sender:)), for: .touchUpInside)
        cancelButton.frame = CGRect(x: self.view.frame.width/1.1 + 10, y: 0, width: 200, height: 30)
        
        view.addSubview(cancelButton)
        
        return view
    }
    
    //MARK: - cancelButtonAction
    @objc private func cancelButtonAction(sender: UIButton) {
        searchBar.endEditing(true)
        searchBar.text = ""
        viewModel.updateTableState?(.failure)
    }
}
extension DetailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            viewModel.fetchCities(city: searchText)
        } else if searchText.count <= 2 {
            viewModel.updateTableState?(.failure)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5) {
            searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/1.55, height: 44)
            self.cancelButton.frame = CGRect(x: self.view.frame.width/1.55 + 6, y: 0, width: 100, height: 44)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5) {
            searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/1.1, height: 44)
            self.cancelButton.frame = CGRect(x: self.view.frame.width/1.1 + 10, y: 0, width: 200, height: 44)
        }
    }
}

