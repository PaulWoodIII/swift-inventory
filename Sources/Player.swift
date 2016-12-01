//
//  Player.swift
//  SwiftInventory
//
//  Created by Paul Wood on 11/14/16.
//
//

import Foundation

enum PlayerError: Error {
    case insufficientItemCount(currentItems: Int)
    case insufficientItemsRequired
    case itemUncraftable
}

struct Player {
    var inventory = Dictionary<Item,Int>();
    
    mutating func addItem(_ item : Item, count increment : Int){
        
        if let current = inventory[item] {
            inventory[item] = current + increment
        }
        else {
            inventory[item] = increment
        }
        
    }
    
    mutating func removeItem(_ item : Item, count decrement : Int) throws -> Int{
        if let current = inventory[item] {
            if current - decrement < 0 {
                throw PlayerError.insufficientItemCount(currentItems:current)
            }
            inventory[item] = current - decrement
            return current - decrement
        }
        else {
            throw PlayerError.insufficientItemCount(currentItems:0)
        }
    }
    
    /**
     * Use things you already have crafted before crafting something new
     * returns the items removed from the inventory to craft the item
     */
    mutating func craftItem(_ item : Item) throws -> [Item:Int]  {
        
        guard item.dependencies != nil else {
            throw PlayerError.itemUncraftable
        }
        var toRemove = [[Item:Int]]()
        let nodes = item.dependencyNode
        
        //recursive function 
        func toSatisfyGraph(_ root : DependencyNode, inventory : Dictionary<Item,Int>) -> [Item:Int] {
            // Use things you already have crafted before crafting something new
            var flattenDependencies = [Item:Int]()
            var inventoryCount = 0
            if let has = inventory[root.item] {
                inventoryCount = has
            }
            var toCraft = root.count - inventoryCount
            if toCraft <= 0 {
                flattenDependencies[root.item] = root.count
            }
            else if let dependencies = root.dependencies {
                var copiedInventory = inventory
                while toCraft > 0 {
                    for node in dependencies {
                        let needed = toSatisfyGraph(node, inventory: copiedInventory)
                        for node in needed {
                            if let currentCount = flattenDependencies[node.key] {
                                flattenDependencies[node.key] = node.value + currentCount
                            }
                            else {
                                flattenDependencies[node.key] = node.value
                            }
                        }
                    }
                    toCraft -= 1
                }
            }
            return flattenDependencies
        }
        
        var copiedInventory = self.inventory
        let satisfable = toSatisfyGraph(nodes, inventory: copiedInventory)
        
        // For each Item in the list remove it from our test inventory
        for node in satisfable {
            copiedInventory[node.key]! -= node.value
        }
        // Lets see if we are missing something
        let filteredError = copiedInventory.filter {
            return $0.value < 0
        }
        // We are missing something if the value is negative after this loop completes
        if (filteredError.count > 0){
            //Can't do it, missing an item
            throw PlayerError.insufficientItemsRequired
        }
        else {
            // SUCCESS!
            // Remove the items used to craft from the inventory
            for node in satisfable {
                inventory[node.key] = inventory[node.key]! -
                    node.value
            }
            // Create the crafted item
            addItem(item, count: 1)
        }
        return satisfable
    }
    
}
