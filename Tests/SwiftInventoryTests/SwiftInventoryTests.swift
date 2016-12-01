import XCTest
@testable import SwiftInventory

class SwiftInventoryTests: XCTestCase {
    
    class A : Item {
        override var name : String {
            get {
                return "A"
            }
        }
        override var dependencies : [Item : Int]? {
            get {
                return [B():1,C():1]
            }
        }
    }
    
    class B : Item {
        override var name : String {
            get {
                return "B"
            }
        }
        override var dependencies : [Item : Int]? {
            get {
                return nil
            }
        }
    }
    
    class C : Item {
        override var name : String {
            get {
                return "C"
            }
        }
        override var dependencies : [Item : Int]? {
            get {
                return nil
            }
        }
    }
    
    class D : Item {
        override var name : String {
            get {
                return "D"
            }
        }
        override var dependencies : [Item : Int]? {
            get {
                return [A():2]
            }
        }
    }
    
    func testInventoryStartsEmpty() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var player = Player()
        XCTAssertEqual(player.inventory.count, 0)
    }

    func testInventoryAdd() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var player = Player()
        let a = A();
        
        player.addItem(a, count: 1)
        XCTAssertEqual(player.inventory.count, 1)
        XCTAssertEqual(player.inventory[a], 1)
        
    }
    
    func testInventoryRemove() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var player = Player()
        let a = A();
        
        player.addItem(a, count: 1)
        XCTAssertEqual(player.inventory.count, 1)
        XCTAssertEqual(player.inventory[a], 1)
        
        do {
            let newCount = try player.removeItem(A(),count:1)
            XCTAssertEqual(newCount, 0)
        }
        catch {
            XCTFail("Should not throw and error")
        }
        
        XCTAssertEqual(player.inventory.count, 1)
        XCTAssertEqual(player.inventory[a], 0)
        
    }
    
    func testInventoryCraft() {
        var player = Player()
        let b = B();
        let c = C();
        
        player.addItem(b, count: 1)
        player.addItem(c, count: 1)
        XCTAssertEqual(player.inventory.count, 2)
        XCTAssertEqual(player.inventory[b], 1)
        XCTAssertEqual(player.inventory[c], 1)
        
        
        do {
            let itemsRemoved = try player.craftItem(A());
            XCTAssertEqual(player.inventory[b], 0)
            XCTAssertEqual(player.inventory[c], 0)
            XCTAssertEqual(player.inventory[A()], 1)
            
            //let expect : [[Item:Int]] = [[b:1],[c:1]]
            //XCTAssertEqual(itemsRemoved, expect)
        }
        catch {
            XCTFail("Should not throw and error")
        }
        
    }
    
    func testInventoryCraftTwoWays() {
        var player = Player()
        let a = A()
        let b = B()
        let c = C()
        
        player.addItem(a, count: 1)
        player.addItem(b, count: 1)
        player.addItem(c, count: 1)
        
        XCTAssertEqual(player.inventory.count, 3)
        XCTAssertEqual(player.inventory[b], 1)
        XCTAssertEqual(player.inventory[c], 1)
        
        
        do {
            let itemsRemoved = try player.craftItem(D());
            XCTAssertEqual(player.inventory[b], 0)
            XCTAssertEqual(player.inventory[c], 0)
            XCTAssertEqual(player.inventory[a], 0)
            XCTAssertEqual(player.inventory[D()], 1)
            //let expect : [[Item:Int]] = [[b:1],[c:1]]
            //XCTAssertEqual(itemsRemoved, expect)
        }
        catch {
            XCTFail("Should not throw and error")
        }
        
    }
    
    static var allTests : [(String, (SwiftInventoryTests) -> () throws -> Void)] {
        return [
            ("testInventoryStartsEmpty", testInventoryStartsEmpty),
            ("testInventoryAdd", testInventoryAdd),
        ]
    }
}
