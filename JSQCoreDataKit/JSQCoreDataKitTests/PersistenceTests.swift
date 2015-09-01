//
//  PersistenceTests.swift
//  JSQCoreDataKit
//
//  Created by Per Bull Holmen on 31.08.15.
//  Copyright (c) 2015 Hexed Bits. All rights reserved.
//

import XCTest
import CoreData

import JSQCoreDataKit

// With the following two lines uncommented, the test fails:
// typealias ModelType = MyModel
// private let EntityName = MyModelEntityName

// With the following two lines uncommented, the test succeeds:
typealias ModelType = MySecondModel
private let EntityName = MySecondModelEntityName

// The class MySecondModel inherits the designated initializer init(entity:insertIntoManagedObjectContext:)
// because it implements no designated initializer. Also see MyModel.swift and TestCase.swift

class PersistenceTests : PersistentModelTestCase {
    
    func test_ThatFetchRequest_Succeeds_WithNewStack() {
        
        // WHEN: we store objects and deallocate the stack
        storeObjects([ "Baba" ])
        
        // AND: we retrieve the objects with a new stack
        let results = retrieveObjectsWithNewStack()
        
        // THEN: we receive the expected data
        XCTAssertEqual(results.count, 1, "Fetch should return 1 object")
        XCTAssertEqual(results, [ "Baba" ], "Fetch should return the same objects" )
        
     }
    
    func storeObjects( strings:[ String ] ) {
        
        let stack = CoreDataStack(model: model)
        
        for string in strings {
            let modelObject = ModelType(context: stack.managedObjectContext, myString:string)
        }
        saveContextAndWait(stack.managedObjectContext)
        
    }
    
    func retrieveObjectsWithNewStack() -> [ String ] {
        
        let stack = CoreDataStack(model: model)
        var result:[ String ] = []
        
        let request = FetchRequest<ModelType>(entity: entity(name: EntityName, context: stack.managedObjectContext))
        let fetchResult = fetch(request: request, inContext: stack.managedObjectContext)
        XCTAssertTrue(fetchResult.success, "Fetch should succeed")
        XCTAssertNil(fetchResult.error, "Fetch should not error")
        
        for modelObject in fetchResult.objects {
            result.append(modelObject.myString)
        }
        
        return result
    }
    
}