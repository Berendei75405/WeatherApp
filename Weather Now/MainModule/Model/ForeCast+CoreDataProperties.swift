//
//  ForeCast+CoreDataProperties.swift
//  Weather Now
//
//  Created by user on 04.06.2023.
//
//

import Foundation
import CoreData


extension ForeCast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForeCast> {
        return NSFetchRequest<ForeCast>(entityName: "ForeCast")
    }

    @NSManaged public var id: Int16
    @NSManaged public var fact: Fact?
    @NSManaged public var parts: Parts?

}

extension ForeCast : Identifiable {

}
