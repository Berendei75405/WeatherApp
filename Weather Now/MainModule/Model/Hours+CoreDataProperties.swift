//
//  Hours+CoreDataProperties.swift
//  Weather Now
//
//  Created by user on 04.06.2023.
//
//

import Foundation
import CoreData


extension Hours {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hours> {
        return NSFetchRequest<Hours>(entityName: "Hours")
    }

    @NSManaged public var condition: String?
    @NSManaged public var feelsLike: Int16
    @NSManaged public var hour: String?
    @NSManaged public var icon: String?
    @NSManaged public var id: Int16
    @NSManaged public var precMM: Double
    @NSManaged public var precProb: Double
    @NSManaged public var temp: Int16
    @NSManaged public var windDir: String?
    @NSManaged public var windSpeed: Double
    @NSManaged public var parts: Parts?

}

extension Hours : Identifiable {

}
