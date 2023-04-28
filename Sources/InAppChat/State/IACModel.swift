//
//  IAC.swift
//  InAppChatUI
//
//  Created by Zaid Daghestani on 1/26/23.
//

import CoreData
import Foundation

public class IACModel {

  static var current = IACModel("default")

  let id: String

  init(_ id: String) {
    self.id = id
  }

  // MARK: - Core Data Stack

  private lazy var managedObjectModel: NSManagedObjectModel = {
    // Fetch Model URL
    guard let modelURL = Bundle.main.url(forResource: "UIACModel", withExtension: "momd") else {
      fatalError("Unable to Find Data Model")
    }

    // Initialize Managed Object Model
    guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Unable to Load Data Model")
    }

    return managedObjectModel
  }()

  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    // Initialize Persistent Store Coordinator
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(
      managedObjectModel: self.managedObjectModel)

    // Helpers
    let fileManager = FileManager.default
    let storeName = "\(self.id).sqlite"

    // URL Documents Directory
    let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

    // URL Persistent Store
    let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

    do {
      let options = [
        NSMigratePersistentStoresAutomaticallyOption: true,
        NSInferMappingModelAutomaticallyOption: true,
      ]

      // Add Persistent Store
      try persistentStoreCoordinator.addPersistentStore(
        ofType: NSSQLiteStoreType,
        configurationName: nil,
        at: persistentStoreURL,
        options: options)
    } catch {
      fatalError("Unable to Add Persistent Store")
    }

    return persistentStoreCoordinator
  }()

  private lazy var privateManagedObjectContext: NSManagedObjectContext = {
    // Initialize Managed Object Context
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

    // Configure Managed Object Context
    managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

    return managedObjectContext
  }()

  public private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
    // Initialize Managed Object Context
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    // Configure Managed Object Context
    managedObjectContext.parent = self.privateManagedObjectContext

    return managedObjectContext
  }()

  public func saveChanges() {
    mainManagedObjectContext.performAndWait {
      do {
        if self.mainManagedObjectContext.hasChanges {
          try self.mainManagedObjectContext.save()
        }
      } catch {
        print("Unable to Save Changes of Main Managed Object Context")
        print("\(error), \(error.localizedDescription)")
      }
    }

    privateManagedObjectContext.perform {
      do {
        if self.privateManagedObjectContext.hasChanges {
          try self.privateManagedObjectContext.save()
        }
      } catch {
        print("Unable to Save Changes of Private Managed Object Context")
        print("\(error), \(error.localizedDescription)")
      }
    }
  }
}

extension NSManagedObject {
  static var entity: NSEntityDescription {
    return NSEntityDescription.entity(
      forEntityName: String(describing: self), in: IACModel.current.mainManagedObjectContext)!
  }

  static func new() -> Self {
    return Self.init(entity: Self.entity, insertInto: IACModel.current.mainManagedObjectContext)
  }
}
