//
//  Model.swift
//  Weather Now
//
//  Created by user on 03.06.2023.
//

import Foundation


// MARK: - Welcome
struct City: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let geoObjectCollection: GeoObjectCollection

    enum CodingKeys: String, CodingKey {
        case geoObjectCollection = "GeoObjectCollection"
    }
}

// MARK: - GeoObjectCollection
struct GeoObjectCollection: Codable {
    let featureMember: [FeatureMember]
}

// MARK: - FeatureMember
struct FeatureMember: Codable {
    let geoObject: GeoObject

    enum CodingKeys: String, CodingKey {
        case geoObject = "GeoObject"
    }
}

// MARK: - GeoObject
struct GeoObject: Codable {
    let name: String
    let description: String
    let point: Point

    enum CodingKeys: String, CodingKey {
        case description, name
        case point = "Point"
    }
}

// MARK: - Point
struct Point: Codable {
    let pos: String
}


