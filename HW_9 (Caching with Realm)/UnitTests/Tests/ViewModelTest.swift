//
//  ViewModelTest.swift
//  HW_9 (Caching with Realm)Tests
//
//  Created by Elizaveta Rogozhina on 11/10/2021.
//

import XCTest
@testable import HW_9__Caching_with_Realm_

class ViewModelTest: XCTestCase {

    func testVC(){
        let vc_mock = ViewModel_Mock()
        //var current_Info: [CurrentWeatherStruct.Current_Info] = [],
                   // forecast_Info: [ForecastWeatherStruct.Forecast_Info] = []
        //vc_mock.uploadForecastInfo()
        XCTAssert(vc_mock.curInfoLoad == true, "current weather download function works")
        //XCTAssert(vc_mock.forecastInfoLoad == true, "forecast weather download function works")
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
