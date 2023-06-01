//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Суворов Дмитрий Владимирович on 01.06.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainScreen() throws {
        let viewController = TrackersViewController()
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .light))])
        assertSnapshots(matching: viewController, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }

}
