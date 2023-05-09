//
//  Store.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 01.05.2023.
//
import CoreData
import UIKit

class Store: NSObject {
    weak var storeDelegate: StoreDelegate? = nil
    
    lazy var context: NSManagedObjectContext = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return context
    }()
    
    init(storeDelegate: StoreDelegate) {
        self.storeDelegate = storeDelegate
        super.init()
    }
    
    internal func save() {
        do { try context.save() } catch { context.rollback() }
    }
}
