//
//  Fact+CoreDataProperties.swift
//  Weather Now
//
//  Created by user on 04.06.2023.
//
//

import Foundation
import CoreData


extension Fact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fact> {
        return NSFetchRequest<Fact>(entityName: "Fact")
    }

    @NSManaged public var condition: String?
    @NSManaged public var feelsLike: Int16
    @NSManaged public var icon: String?
    @NSManaged public var temp: Int16
    @NSManaged public var windDir: String?
    @NSManaged public var windSpeed: Double
    @NSManaged public var city: String?
    @NSManaged public var foreCast: NSSet?

}

// MARK: Generated accessors for foreCast
extension Fact {

    @objc(addForeCastObject:)
    @NSManaged public func addToForeCast(_ value: ForeCast)

    @objc(removeForeCastObject:)
    @NSManaged public func removeFromForeCast(_ value: ForeCast)

    @objc(addForeCast:)
    @NSManaged public func addToForeCast(_ values: NSSet)

    @objc(removeForeCast:)
    @NSManaged public func removeFromForeCast(_ values: NSSet)

}

extension Fact : Identifiable {

}
