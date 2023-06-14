//
//  RouterTest.swift
//  Weather NowTests
//
//  Created by user on 11.06.2023.
//

import XCTest
@testable import Weather_Now

class MockTabBar: TabBarController {
    
    
        
}

final class RouterTest: XCTestCase {
    
    var router: MainRouter!
    var tabBar = MockTabBar()

    override func setUpWithError() throws {
        self.router = Router(tabBarController: tabBar)
    }

    override func tearDownWithError() throws {
        self.router = nil
    }

    func testInitialViewController() throws {
        router.initailViewController()
        let mockView = tabBar.viewControllers?.first
    
        XCTAssertTrue(mockView is UINavigationController)
    }
    
    func testCreateModule() {
        let mockView = router.createModule()
        let tabBarView = tabBar.view1
        
        XCTAssertEqual(mockView.viewControllers.first, tabBarView)
    }
    
    func testCreateDetail() {
        let secondVC = router.createDetailModule(city: "")
        
        XCTAssertTrue(secondVC is DetailViewController)
    }
    

}
