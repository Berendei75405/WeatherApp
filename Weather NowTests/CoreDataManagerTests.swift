//
//  CoreDataManagerTests.swift
//  Weather NowTests
//
//  Created by user on 12.06.2023.
//

import XCTest
import CoreData
@testable import Weather_Now

class MockViewModel: ViewModel {
    
}

class MockDetailViewModel: DetailViewModel {
    
}

final class CoreDataManagerTests: XCTestCase {
    
    var mockViewModel: MockViewModel!
    var mockDetailViewModel: MockDetailViewModel!
    var coreDataManager: CoreDataManager!

    override func setUpWithError() throws {
        coreDataManager = CoreDataManager.share
        mockViewModel = MockViewModel()
        mockDetailViewModel = MockDetailViewModel(city: "")
    }

    override func tearDownWithError() throws {
        coreDataManager = nil
        mockViewModel = nil
        mockDetailViewModel = nil
    }

    func testAddWeatherInfo() throws {
        mockViewModel.fetch()
        let fetchReques = NSFetchRequest<NSFetchRequestResult>(entityName: "Fact")
        guard let arrayWeather = try? coreDataManager.viewContext.fetch(fetchReques) as? [Fact] else {return}
        print(arrayWeather.count)
        XCTAssertTrue(arrayWeather.count == 1)
    }
    
    func testFetchWeather() {
        mockViewModel.fetch()
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 3, execute: { [self] in
            var weatherInfo = coreDataManager.fetchWeather(name: mockViewModel.townName)
            XCTAssertTrue(weatherInfo != nil)
        })
    }
    
    func testR() {
        mockViewModel.fetch()
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 3, execute: { [self] in
            coreDataManager.removeWeather(name: mockViewModel.townName)
            XCTAssertTrue(coreDataManager.fetchWeather(name: mockViewModel.townName) == nil)
        })
    }


}
