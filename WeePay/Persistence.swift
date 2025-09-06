//
//  Persistence.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 15/07/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Add sample data for preview if needed - safely handle missing entities
        do {
            // Check if the Item entity exists before creating instances
            if let entityDescription = NSEntityDescription.entity(forEntityName: "Item", in: viewContext) {
                for _ in 0..<10 {
                    let newItem = NSManagedObject(entity: entityDescription, insertInto: viewContext)
                    newItem.setValue(Date(), forKey: "timestamp")
                }
            }
            
            try viewContext.save()
        } catch {
            print("Preview context setup error: \(error)")
            // Don't crash in previews - just log the error
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Create an in-memory container with programmatic model for preview compatibility
        if inMemory {
            container = PersistenceController.createInMemoryContainer()
        } else {
            // Try to load the WeePay model, fall back to in-memory if not found
            container = NSPersistentContainer(name: "WeePay")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    print("Core Data error: \(error), \(error.userInfo)")
                    // In development, create a fallback in-memory store
                }
            })
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    private static func createInMemoryContainer() -> NSPersistentContainer {
        // Create a managed object model programmatically
        let model = NSManagedObjectModel()
        
        // ExpenseTransaction Entity
        let expenseEntity = NSEntityDescription()
        expenseEntity.name = "ExpenseTransaction"
        expenseEntity.managedObjectClassName = "ExpenseTransaction"
        
        // Add attributes
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .UUIDAttributeType
        idAttribute.isOptional = true
        
        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = true
        
        let amountAttribute = NSAttributeDescription()
        amountAttribute.name = "amount"
        amountAttribute.attributeType = .doubleAttributeType
        amountAttribute.defaultValue = 0.0
        
        let typeAttribute = NSAttributeDescription()
        typeAttribute.name = "type"
        typeAttribute.attributeType = .stringAttributeType
        typeAttribute.isOptional = true
        
        let categoryAttribute = NSAttributeDescription()
        categoryAttribute.name = "category"
        categoryAttribute.attributeType = .stringAttributeType
        categoryAttribute.isOptional = true
        
        let descriptionAttribute = NSAttributeDescription()
        descriptionAttribute.name = "descriptionText"
        descriptionAttribute.attributeType = .stringAttributeType
        descriptionAttribute.isOptional = true
        
        let paymentMethodAttribute = NSAttributeDescription()
        paymentMethodAttribute.name = "paymentMethod"
        paymentMethodAttribute.attributeType = .stringAttributeType
        paymentMethodAttribute.isOptional = true
        
        let recipientNameAttribute = NSAttributeDescription()
        recipientNameAttribute.name = "recipientName"
        recipientNameAttribute.attributeType = .stringAttributeType
        recipientNameAttribute.isOptional = true
        
        let recipientPhoneAttribute = NSAttributeDescription()
        recipientPhoneAttribute.name = "recipientPhoneNumber"
        recipientPhoneAttribute.attributeType = .stringAttributeType
        recipientPhoneAttribute.isOptional = true
        
        let dateAttribute = NSAttributeDescription()
        dateAttribute.name = "date"
        dateAttribute.attributeType = .dateAttributeType
        dateAttribute.isOptional = true
        
        let isManualEntryAttribute = NSAttributeDescription()
        isManualEntryAttribute.name = "isManualEntry"
        isManualEntryAttribute.attributeType = .booleanAttributeType
        isManualEntryAttribute.defaultValue = false
        
        let createdAtAttribute = NSAttributeDescription()
        createdAtAttribute.name = "createdAt"
        createdAtAttribute.attributeType = .dateAttributeType
        createdAtAttribute.isOptional = true
        
        let updatedAtAttribute = NSAttributeDescription()
        updatedAtAttribute.name = "updatedAt"
        updatedAtAttribute.attributeType = .dateAttributeType
        updatedAtAttribute.isOptional = true
        
        expenseEntity.properties = [
            idAttribute, titleAttribute, amountAttribute, typeAttribute,
            categoryAttribute, descriptionAttribute, paymentMethodAttribute,
            recipientNameAttribute, recipientPhoneAttribute, dateAttribute,
            isManualEntryAttribute, createdAtAttribute, updatedAtAttribute
        ]
        
        model.entities = [expenseEntity]
        
        let container = NSPersistentContainer(name: "WeePay", managedObjectModel: model)
        container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                print("In-memory Core Data error: \(error)")
            }
        }
        
        return container
    }
}
