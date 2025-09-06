//
//  ExpenseTransaction+CoreDataProperties.swift
//  WeePay
//
//  Created by Core Data Generator
//

import Foundation
import CoreData

extension ExpenseTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseTransaction> {
        return NSFetchRequest<ExpenseTransaction>(entityName: "ExpenseTransaction")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var amount: Double
    @NSManaged public var type: String?
    @NSManaged public var category: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var paymentMethod: String?
    @NSManaged public var recipientName: String?
    @NSManaged public var recipientPhoneNumber: String?
    @NSManaged public var date: Date?
    @NSManaged public var isManualEntry: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
}
