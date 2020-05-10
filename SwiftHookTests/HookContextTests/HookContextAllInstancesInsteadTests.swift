//
//  HookContextAllInstancesInsteadTests.swift
//  SwiftHookTests
//
//  Created by Yanni Wang on 10/5/20.
//  Copyright © 2020 Yanni. All rights reserved.
//

import XCTest
@testable import SwiftHook

class HookContextAllInstancesInsteadTests: XCTestCase {
    
    // MARK: All instances & instead
    
    func testCallOriginal() {
        do {
            let contextCount = HookManager.shared.debugToolsGetAllHookContext().count
            let test = TestObject()
            let argumentA = 77
            let argumentB = 88
            
            try autoreleasepool {
                // hook
                let targetClass = TestObject.self
                let selector = #selector(TestObject.sumFunc(a:b:))
                let mode: HookMode = .instead
                let closure = { original, a, b in
                    let result = original(a, b)
                    XCTAssertEqual(result, a + b)
                    return result
                    } as @convention(block) ((Int, Int) -> Int, Int, Int) -> Int as AnyObject
                let hookContext = try HookManager.shared.hook(targetClass: targetClass, selector: selector, mode: mode, hookClosure: closure)
                XCTAssertEqual(HookManager.shared.debugToolsGetAllHookContext().count, contextCount + 1)
                
                // test hook
                let result = test.sumFunc(a: argumentA, b: argumentB)
                XCTAssertEqual(result, argumentA + argumentB)
                
                // cancel
                XCTAssertTrue(hookContext.cancelHook())
            }
            
            // test cancel
            let result = test.sumFunc(a: argumentA, b: argumentB)
            XCTAssertEqual(result, argumentA + argumentB)
            XCTAssertEqual(HookManager.shared.debugToolsGetAllHookContext().count, contextCount)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testOverrideOriginal() {
        do {
            let contextCount = HookManager.shared.debugToolsGetAllHookContext().count
            let test = TestObject()
            let argumentA = 77
            let argumentB = 88
            
            try autoreleasepool {
                // hook
                let targetClass = TestObject.self
                let selector = #selector(TestObject.sumFunc(a:b:))
                let mode: HookMode = .instead
                let closure = { original, a, b in
                    let result = original(a, b)
                    XCTAssertEqual(result, a + b)
                    return a * b
                    } as @convention(block) ((Int, Int) -> Int, Int, Int) -> Int as AnyObject
                let hookContext = try HookManager.shared.hook(targetClass: targetClass, selector: selector, mode: mode, hookClosure: closure)
                XCTAssertEqual(HookManager.shared.debugToolsGetAllHookContext().count, contextCount + 1)
                
                // test hook
                let result = test.sumFunc(a: argumentA, b: argumentB)
                XCTAssertEqual(result, argumentA * argumentB)
                
                // cancel
                XCTAssertTrue(hookContext.cancelHook())
            }
            
            // test cancel
            let result = test.sumFunc(a: argumentA, b: argumentB)
            XCTAssertEqual(result, argumentA + argumentB)
            XCTAssertEqual(HookManager.shared.debugToolsGetAllHookContext().count, contextCount)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testChangeArgs() {
        do {
            let contextCount = HookManager.shared.debugToolsGetAllHookContext().count
            let test = TestObject()
            let argumentA = 77
            let argumentB = 88
            
            try autoreleasepool {
                // hook
                let targetClass = TestObject.self
                let selector = #selector(TestObject.sumFunc(a:b:))
                let mode: HookMode = .instead
                let closure = { original, a, b in
                    let result = original(a * 2, b * 2)
                    XCTAssertEqual(result, a * 2 + b * 2)
                    return result
                    } as @convention(block) ((Int, Int) -> Int, Int, Int) -> Int as AnyObject
                let hookContext = try HookManager.shared.hook(targetClass: targetClass, selector: selector, mode: mode, hookClosure: closure)
                XCTAssertEqual(HookManager.shared.debugToolsGetAllHookContext().count, contextCount + 1)
                
                // test hook
                let result = test.sumFunc(a: argumentA, b: argumentB)
                XCTAssertEqual(result, argumentA * 2 + argumentB * 2)
                
                // cancel
                XCTAssertTrue(hookContext.cancelHook())
            }
            
            // test cancel
            let result = test.sumFunc(a: argumentA, b: argumentB)
            XCTAssertEqual(result, argumentA + argumentB)
            XCTAssertEqual(HookManager.shared.debugToolsGetAllHookContext().count, contextCount)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testNonCallOriginal() {
        do {
            let contextCount = HookManager.shared.debugToolsGetAllHookContext().count
            let test = TestObject()
            var result = [Int]()
            
            try autoreleasepool {
                // hook
                let targetClass = TestObject.self
                let selector = #selector(TestObject.execute(closure:))
                typealias ExecuteType = () -> Void
                let mode: HookMode = .instead
                let closure = { original, arg in
                    XCTAssertEqual(result, [])
                    result.append(1)
                    result.append(3)
                    } as @convention(block) ((ExecuteType) -> Void, ExecuteType) -> Void as AnyObject
                let hookContext = try HookManager.shared.hook(targetClass: targetClass, selector: selector, mode: mode, hookClosure: closure)
                XCTAssertEqual(HookManager.shared.debugToolsGetAllHookContext().count, contextCount + 1)
                
                // test hook
                XCTAssertEqual(result, [])
                test.execute {
                    XCTAssertTrue(false)
                    result.append(2)
                }
                XCTAssertEqual(result, [1, 3])
                
                // cancel
                
                XCTAssertTrue(hookContext.cancelHook())
                result.removeAll()
            }
            
            // test cancel
            test.execute {
                XCTAssertEqual(result, [])
                result.append(2)
            }
            XCTAssertEqual(result, [2])
            XCTAssertEqual(HookManager.shared.debugToolsGetAllHookContext().count, contextCount)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testCallOriginalForClosure() {
        do {
            let contextCount = HookManager.shared.debugToolsGetAllHookContext().count
            let test = TestObject()
            var result = [Int]()
            
            try autoreleasepool {
                // hook
                let targetClass = TestObject.self
                let selector = #selector(TestObject.execute(closure:))
                typealias ExecuteType = () -> Void
                let mode: HookMode = .instead
                let closure = { original, arg in
                    XCTAssertEqual(result, [])
                    result.append(1)
                    original(arg)
                    result.append(3)
                    } as @convention(block) (@escaping (ExecuteType) -> Void, ExecuteType) -> Void as AnyObject
                let hookContext = try HookManager.shared.hook(targetClass: targetClass, selector: selector, mode: mode, hookClosure: closure)
                XCTAssertEqual(HookManager.shared.debugToolsGetAllHookContext().count, contextCount + 1)
                
                // test hook
                XCTAssertEqual(result, [])
                test.execute {
                    XCTAssertEqual(result, [1])
                    result.append(2)
                }
                XCTAssertEqual(result, [1, 2, 3])
                
                // cancel
                
                XCTAssertTrue(hookContext.cancelHook())
                result.removeAll()
            }
            
            // test cancel
            test.execute {
                XCTAssertEqual(result, [])
                result.append(2)
            }
            XCTAssertEqual(result, [2])
            XCTAssertEqual(HookManager.shared.debugToolsGetAllHookContext().count, contextCount)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testHookTwice() {
        do {
            let contextCount = HookManager.shared.debugToolsGetAllHookContext().count
            let test = TestObject()
            var result = [Int]()
            
            try autoreleasepool {
                let targetClass = TestObject.self
                let selector = #selector(TestObject.execute(closure:))
                typealias ExecuteType = () -> Void
                let mode: HookMode = .instead
                
                // first hook
                let hookContext1 = try HookManager.shared.hook(targetClass: targetClass, selector: selector, mode: mode, hookClosure: { original, arg in
                    result.append(1)
                    original(arg)
                    result.append(2)
                    } as @convention(block) (@escaping (ExecuteType) -> Void, ExecuteType) -> Void as AnyObject)
                XCTAssertEqual(HookManager.shared.debugToolsGetAllHookContext().count, contextCount + 1)
                
                // second hook
                let hookContext2 = try HookManager.shared.hook(targetClass: targetClass, selector: selector, mode: mode, hookClosure: { original, arg in
                    result.append(3)
                    original(arg)
                    result.append(4)
                    } as @convention(block) (@escaping (ExecuteType) -> Void, ExecuteType) -> Void as AnyObject)
                XCTAssertEqual(HookManager.shared.debugToolsGetAllHookContext().count, contextCount + 2)
                
                // test hook
                XCTAssertEqual(result, [])
                test.execute {
                    result.append(5)
                }
                XCTAssertEqual(result, [3, 1, 5, 2, 4])
                
                // TODO: not complete cancellation.
                // cancel
                XCTAssertFalse(hookContext1.cancelHook())
                XCTAssertTrue(hookContext2.cancelHook())
//                result.removeAll()
            }
            
            // test cancel
//            test.execute {
//                XCTAssertEqual(result, [])
//                result.append(2)
//            }
//            XCTAssertEqual(result, [2])
//            XCTAssertEqual(HookManager.shared.debugToolsGetAllHookContext().count, contextCount)
        } catch {
            XCTAssertNil(error)
        }
    }
    
}