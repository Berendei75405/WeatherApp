//
//  ViewController.swift
//  Weather Now
//
//  Created by user on 04.04.2023.
//

import UIKit
import Combine

class WeatherViewController: UIViewController {
    
    var viewModel: ViewModelProtocol!
    var tableView: TableViewCastom!
    
    lazy var townButton = createTownButton()
    lazy var dateLabel = createDateLabel()
    //состояние dateLabel
    private var dateIsShow = false
    lazy var reloadLable = createReloadLabel()

    var cancellable = Set<AnyCancellable>()

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        createTitleView()
        townForButton()
        createConstraintsForTable()
        updateView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        viewModel.fetch()
        viewModel.getLocation()

    }
    
    //MARK: - townForButton
    private func townForButton() {
        viewModel.townPublisher.sink(receiveValue: { [weak self] value in
            self?.navigationItem.titleView = self?.customView(townName: self?.viewModel.townName ?? "", currentDate: self?.viewModel.currentDateForTitle() ?? "", dateIsHiden: true)
        }).store(in: &cancellable)
    }
    
    //MARK: - func updateView()
    private func updateView() {
        viewModel.updateTableState = { [weak self] tableState in
            self?.tableView.tableState = tableState
        }
    }
    
    @objc func buttonAction(sender: UIButton) {
        viewModel.router.showDetail(city: viewModel.townName)
    }
    
    //MARK: - customView
    func customView(townName: String, currentDate: String, dateIsHiden: Bool) -> UIView {
        //view
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 280, height: 44))
        view.clipsToBounds = true
        if townName == "" {
            townButton.setTitle("Город", for: .normal)
        } else {
            townButton.setTitle(townName, for: .normal)
        }
        dateLabel.text = currentDate
        
        if dateIsHiden == false && dateIsShow == false {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.dateIsShow = true
                self?.dateLabel.frame.origin.y = 30
            }, completion: nil)
        } else if dateIsHiden == true && dateIsShow == true {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.dateIsShow = false
                self?.dateLabel.frame.origin.y = 50
            }, completion: nil)
        }
            
        view.addSubview(dateLabel)
        view.addSubview(townButton)
        view.addSubview(reloadLable)
        
        return view
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
}

