//
//  DBObject.swift
//  CoreDataCRUD
//
//  Created by Unipoli on 3/24/19.
//  Copyright © 2019 ankur. All rights reserved.
//

import UIKit
import CoreData

class DBLocal: NSObject
{
    class func save(for entityName: String, attributes: [String: String], where predicate: NSPredicate? = nil)
    {
        func getContext(for entityName: String, managedContext: NSManagedObjectContext, where predicate: NSPredicate? = nil) -> NSManagedObject
        {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
            fetchRequest.predicate = predicate
            
            do
            {
                let managedObjects: [NSManagedObject] = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
                
                guard let object: NSManagedObject = managedObjects.first else
                {
                    //Now let’s create an entity and new user records.
                    let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
                    
                    //we need to add some data to our newly created record for each keys using
                    let object: NSManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
                    
                    return object
                }
                
                return object
            }
            catch
            {
                print(error)
            }
            
            //Now let’s create an entity and new user records.
            let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
            
            //we need to add some data to our newly created record for each keys using
            let object: NSManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
            
            return object
        }
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let object: NSManagedObject = getContext(for: entityName, managedContext: managedContext, where: predicate)
        
        for (key, value) in attributes
        {
            object.setValue(value, forKeyPath: key)
        }
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        do
        {
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    class func retrieve(for entityName: String, where predicate: NSPredicate? = nil) -> [[String: String]]
    {
        var dictionaries: [[String: String]] = [[:]]
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return dictionaries }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        //
        do
        {
            let objects = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for object in objects
            {
                dictionaries.append(object.toDictionary())
            }
        }
        catch
        {
            print("Failed")
        }
        
        return dictionaries
    }
    
    class func delete(for entityName: String, where predicate: NSPredicate)
    {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext:  NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        do
        {
            let managedObjects: [NSManagedObject] = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            let object = managedObjects.first!
            managedContext.delete(object)
            
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
}

extension NSManagedObject
{
    func toDictionary() -> [String: String]
    {
        var dictionary: [String: String] = [:]
        
        let entity: NSEntityDescription = self.entity
        let attributes: [String: NSAttributeDescription] = entity.attributesByName
        
        for attribute in attributes
        {
            guard let value = self.value(forKey: attribute.key) as? String else { continue }
            dictionary[attribute.key] = value
        }
        
        return dictionary
    }
}
