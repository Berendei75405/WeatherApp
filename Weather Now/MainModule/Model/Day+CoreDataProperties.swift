//
//  Day+CoreDataProperties.swift
//  Weather Now
//
//  Created by user on 04.06.2023.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var icon: String?
    @NSManaged public var precMM: Double
    @NSManaged public var precProb: Double
    @NSManaged public var tempMax: Int16
    @NSManaged public var tempMin: Int16
    @NSManaged public var parts: Parts?

}

extension Day : Identifiable {

}
