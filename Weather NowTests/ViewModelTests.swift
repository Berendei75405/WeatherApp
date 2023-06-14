//
//  ViewModelTests.swift
//  Weather NowTests
//
//  Created by user on 12.06.2023.
//

import XCTest
@testable import Weather_Now

class MockView: WeatherViewController {
    
}

class MockTableView: TableViewCastom {
    
}

class MockCoreData: CoreDataManager {
    
}

final class ViewModelTests: XCTestCase {

    var view: MockView!
    var viewModel: ViewModelProtocol!
    
    override func setUpWithError() throws {
        let tabBarController = TabBarController()
        let tableViewCastom = MockTableView()
        view = MockView()
        view.tableView = tableViewCastom
        viewModel = ViewModel()
        viewModel.coreDataManager = MockCoreData.share
    }

    override func tearDownWithError() throws {
        view = nil
        viewModel = nil
    }

    func testFetchSuccess() {
        viewModel.fetch()
        if view.tableView.tableState == .success {
            XCTAssertTrue(viewModel.weatherInfo != nil)
            //количество дней
            XCTAssertEqual(viewModel.weatherInfo?.forecasts.count, 3)
        }
    }
    
    func testFetchFailure() {
        viewModel.fetch()
        let weather = viewModel.getWeatherWithoutErrors()
        if view.tableView.tableState == .failure {
            XCTAssertTrue(viewModel.weatherInfo != nil)
            XCTAssertEqual(viewModel.weatherInfo?.forecasts.count, 3)
        }
    }
    
    func testUpdateState() {
        viewModel.updateTableState?(.initial)
        XCTAssertTrue(view.tableView.tableState == .initial)
    }
    
    func testGetLocation() {
        viewModel.getLocation()
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 3, execute: { [self] in
            XCTAssertTrue(self.viewModel.townName != "")
        })
    }
    
    func testGetWeatherWithoutErrors() {
        var weather = viewModel.getWeatherWithoutErrors()
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 3, execute: { [self] in
            XCTAssertEqual(weather.fact.icon, viewModel.weatherInfo?.fact.icon)
            XCTAssertEqual(weather.fact.temp, viewModel.weatherInfo?.fact.temp)
            XCTAssertEqual(weather.fact.condition, viewModel.weatherInfo?.fact.condition)
        })
    }


}
