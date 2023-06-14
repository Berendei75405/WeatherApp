//
//  Router.swift
//  Weather Now
//
//  Created by user on 24.04.2023.
//

import UIKit

protocol MainRouter: AnyObject {
    var tabBarController: TabBarController! {get set}
    func initailViewController()
    func showDetail(city: String)
    func popToRoot()
    func popToRootAndSend(city: String)
    func createDetailModule(city: String) -> UIViewController
    func createModule() -> UINavigationController
}

class Router: MainRouter {
    weak var tabBarController: TabBarController!
    
    init(tabBarController: TabBarController) {
        self.tabBarController = tabBarController
        
    }
    
    //MARK: - createModule
    func createModule() -> UINavigationController {
        let view = WeatherViewController()
        let viewModel = ViewModel()
        let tableView = TableViewCastom()
        let router = Router(tabBarController: tabBarController)
        
        view.viewModel = viewModel
        view.tableView = tableView
        tableView.vc = view
        
        viewModel.router = router
        viewModel.coreDataManager = CoreDataManager.share
        //полупрозрачный navBar
        let navView = UINavigationController(rootViewController: view)
        navView.navigationBar.setBackgroundImage(UIImage(named: "blue"), for: .default)
        navView.navigationBar.isTranslucent = true
        
        //tabBarController
        tabBarController.view1 = view
        
        return navView
    }
    
    //MARK: - createDetailModule
    func createDetailModule(city: String) -> UIViewController {
        let view = DetailViewController()
        let viewModel = DetailViewModel(city: city)
        let router = Router(tabBarController: tabBarController)
        let table = TableViewDetail()
        
        viewModel.router = router
        view.tableView = table
        view.viewModel = viewModel

        table.vc = view
        
        tabBarController.viewControllers?.append(view)
        
        return view
    }
    
    //MARK: - initailViewController
    func initailViewController() {
        if let tabBarController = tabBarController {
            weak var view = createModule()
            
            tabBarController.viewControllers = [view!]
        }
    }
    
    //MARK: - showDetail
    func showDetail(city: String) {
        if let navController = tabBarController.viewControllers?.first as? UINavigationController {
            weak var view = createDetailModule(city: city)
            view?.navigationItem.hidesBackButton = true
            
            navController.pushViewController(view!, animated: true)
        }
    }
    
    //MARK: - popToRoot
    func popToRoot() {
        if let navController = tabBarController.viewControllers?.first as? UINavigationController {
            navController.navigationBar.setBackgroundImage(UIImage(named: "blue"), for: .default)
            
            navController.popToRootViewController(animated: true)
        }
    }
    
    //MARK: - popToRootAndSend
    func popToRootAndSend(city: String) {
        if let navController = tabBarController.viewControllers?.first as? UINavigationController {
            navController.navigationBar.setBackgroundImage(UIImage(named: "blue"), for: .default)
            guard let firstVC = navController.viewControllers.first as? WeatherViewController else {
                print("Не удалось достать WeatherViewController")
                return}
            firstVC.viewModel.cityForWeather = city
            
            tabBarController.view1 = firstVC
            navController.popToRootViewController(animated: true)
        }
    }
}
