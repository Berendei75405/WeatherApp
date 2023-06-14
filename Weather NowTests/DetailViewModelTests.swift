//
//  DetailViewModelTests.swift
//  Weather NowTests
//
//  Created by user on 12.06.2023.
//

import XCTest
@testable import Weather_Now

class MockDetailView: DetailViewController {
    
}

class MockDetailTableView: TableViewDetail {
    
}

final class DetailViewModelTests: XCTestCase {
    
    var view: MockDetailView!
    var viewModel: DetailViewModelProtocol!

    override func setUpWithError() throws {
        view = MockDetailView()
        viewModel = DetailViewModel(city: "")
        viewModel.coreDataManager = MockCoreData.share
    }

    override func tearDownWithError() throws {
        viewModel = nil
        view = nil
    }

    func testFeatchCities() throws {
        viewModel.fetchCities(city: "Барнаул")
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 3, execute: { [self] in
            XCTAssertTrue(self.viewModel.citiesForSearch?.response.geoObjectCollection.featureMember.count != nil)
            XCTAssertTrue((self.viewModel.citiesForSearch?.response.geoObjectCollection.featureMember.count ?? 0) > 2)
        })
    }
    
    func testFeatchWeather() {
        UserDefaults.standard.setValue(["83.763", "53.360"], forKey: "Барнаул")
        viewModel.fetchWeather(city: "Барнаул")
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 3, execute: { [self] in
            let weather = viewModel.coreDataManager.fetchWeather(name: "Барнаул")
            XCTAssertTrue(weather != nil)
        })
    }

}
