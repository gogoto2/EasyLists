import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navController = window?.rootViewController as! UINavigationController
        let listsController = navController.viewControllers[0] as! ListsViewController
        listsController.dataSource = ListsDataSource(persistentContainer: self.persistentContainer)

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EasyLists")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                if CommandLine.arguments.contains("--uitesting") {
                    self.resetStateForTesting(container: container)
                }
            }
        })
        return container
    }()
    
    func resetStateForTesting(container: NSPersistentContainer) {
        let psc = container.persistentStoreCoordinator
        let desc = container.persistentStoreDescriptions[0]

        do {
            try psc.destroyPersistentStore(at: desc.url!, ofType: NSSQLiteStoreType, options: desc.options)
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: desc.configuration, at: desc.url, options: desc.options)
        } catch {
            print("Failed to reset state: \(error)")
            print("This will most likely cause tests to fail.")
        }
    }
    
    func addList(name: String, container: NSPersistentContainer) {
        let entity = NSEntityDescription.entity(forEntityName: "TodoList",
                                                in: container.viewContext)!
        let list = TodoList(entity: entity, insertInto: container.viewContext)
        list.name = name
    }


    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

