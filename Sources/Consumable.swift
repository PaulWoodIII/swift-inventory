//
//  Consumable.swift
//  SwiftInventory
//
//  Created by Paul Wood on 11/14/16.
//
//

import Foundation

struct DependencyNode {
    var item : Item
    var count : Int
    var dependencies : [DependencyNode]?
}

class Item: Hashable {
    
    var name : String {
        get {
            return "Item"
        }
    }
    
    var dependencies : [Item : Int]? {
        get {
            fatalError("Superclass method that must be overriden called")
        }
    }
    
    var dependencyNode : DependencyNode {
        get {
            var nodes = [DependencyNode]()
            if let dependencies = self.dependencies{
                for key in dependencies.keys {
                    var node = key.dependencyNode
                    node.count = dependencies[key]!
                    nodes.append(node)
                }
            }
            return DependencyNode(item: self, count: 1, dependencies: nodes.count > 0 ? nodes : nil)
        }
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name
    }
    
    /// The Consumable hash value. Is it's name
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    public var hashValue: Int {
        get {
            return name.hashValue
        }
    }
    
}

extension Item: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(name)"
    }
}
