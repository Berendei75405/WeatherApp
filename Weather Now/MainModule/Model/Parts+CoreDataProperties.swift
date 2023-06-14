//
//  Parts+CoreDataProperties.swift
//  Weather Now
//
//  Created by user on 04.06.2023.
//
//

import Foundation
import CoreData


extension Parts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Parts> {
        return NSFetchRequest<Parts>(entityName: "Parts")
    }

    @NSManaged public var day: Day?
    @NSManaged public var foreCast: ForeCast?
    @NSManaged public var hours: NSSet?

}

// MARK: Generated accessors for hours
extension Parts {

    @objc(addHoursObject:)
    @NSManaged public func addToHours(_ value: Hours)

    @objc(removeHoursObject:)
    @NSManaged public func removeFromHours(_ value: Hours)

    @objc(addHours:)
    @NSManaged public func addToHours(_ values: NSSet)

    @objc(removeHours:)
    @NSManaged public func removeFromHours(_ values: NSSet)

}

extension Parts : Identifiable {

}
