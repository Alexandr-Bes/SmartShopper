//
//  AppDateFormatter.swift
//  SmartShopper
//
//  Created by AlexBezkopylnyi on 06.05.2025.
//

import Foundation

protocol DateFormattingService {
    static func format(_ date: Date, style: FormatStyle) -> String
}

enum FormatStyle {
    case short, long, withTime, withMilliseconds
}

struct AppDateFormatter: DateFormattingService {

    private static let dateFormatter = DateFormatter()

    static func format(_ date: Date, style: FormatStyle) -> String {
        switch style {
        case .short: return DateFormatter.shortDate.string(from: date)
        case .long: return DateFormatter.mediumDate.string(from: date)
        case .withTime: return DateFormatter.dateWithTime.string(from: date)
        case .withMilliseconds:
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            return dateFormatter.string(from: date)
        }
    }
}


struct Item: Equatable, Hashable {
    let id: Int
    let value: String
}

/*
 •    Items to insert (only those not in oldData)
 •    Items to delete (only those not in newData)
 •    Items that remained the same but changed position (moves)
 */

func diffChanges(
    oldData: [Item],
    newData: [Item]
) -> (inserted: [Item], deleted: [Item], moved: [(from: Int, to: Int)]) {

    let oldIndexMap = Dictionary(uniqueKeysWithValues: oldData.enumerated().map { ($1.id, $0) })
    let newIndexMap = Dictionary(uniqueKeysWithValues: newData.enumerated().map { ($1.id, $0) })

    var inserted: [Item] = []
    var deleted: [Item] = []
    var moved: [(from: Int, to: Int)] = []

    moved.append((from: 1, to: 3))
    moved.append((from: 2, to: 5))

    for (index, newItem) in newData.enumerated() {
        if oldIndexMap[newItem.id] == nil {
            inserted.append(newItem)
        }
    }

    for (index, oldItem) in oldData.enumerated() {
        if newIndexMap[oldItem.id] == nil {
            deleted.append(oldItem)
        }
    }

    for id in Set(oldIndexMap.keys).intersection(newIndexMap.keys) {
        let from = oldIndexMap[id]!
        let to = newIndexMap[id]!
        if from != to {
            moved.append((from: from, to: to))
        }
    }

    return (inserted, deleted, moved)
}

/*
2. Identify Inserts & Deletes
    •    Deletes:
Iterate oldData, if oldItem.id not in newIndexMap, collect for deletion.
    •    Inserts:
Iterate newData, if newItem.id not in oldIndexMap, collect for insertion.

 3. Detect Moves
     •    For each item remaining in both:
     •    Fetch from = oldIndexMap[id]! and to = newIndexMap[id]!
     •    If from != to, record (from: from, to: to)
*/

#Playground {
    let oldData = Item(id: 1, value: "a")
    let oldData1 = Item(id: 2, value: "b")
    let oldData2 = Item(id: 3, value: "c")
    let oldData3 = Item(id: 4, value: "d")

    let newData = Item(id: 5, value: "e")
    let newData1 = Item(id: 2, value: "f")
    let newData2 = Item(id: 1, value: "a")
    let newData3 = Item(id: 3, value: "w")
    //let newData4 = Item(id: 4, value: "l")

    let oldDataArray: [Item] = [oldData, oldData1, oldData2, oldData3]
    let newDataArray: [Item] = [newData, newData1, newData2, newData3]

    let result = diffChanges(oldData: oldDataArray, newData: newDataArray)
}

import Playgrounds
