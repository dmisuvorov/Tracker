//
//  Array+Common.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 30.05.2023.
//

extension Array {
    func partitioned(by condition: (Element) -> Bool) -> ([Element], [Element]) {
        var trueElements = [Element]()
        var falseElements = [Element]()
        
        for element in self {
            if condition(element) {
                trueElements.append(element)
            } else {
                falseElements.append(element)
            }
        }
        
        return (trueElements, falseElements)
    }
}
