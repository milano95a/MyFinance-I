//
//  CostOfThingsIn30YearsManager.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 19/05/23.
//

import Foundation

class ManagerCostOfThingsIn30Years: ObservableObject {
    @Published var items: [CostIn30Years]
    
    init(_ exepenseManager: MFExpenseViewModel) {
        var items = [CostIn30Years]()
        
        func calculateCostIn30Years(_ cost: Int) -> Int {
            let roi = 1.06
            let years = 30.0
            let result = Double(cost) * pow(roi, years)
            return Int(result)
        }

        for expense in exepenseManager.expensesDOM { 
            let item = CostIn30Years(id: expense.id, name: expense.name, cost: calculateCostIn30Years(expense.cost))
            items.append(item)
        }
        self.items = items
    }
    
    // MARK: Intent(s)
    
    // MARK: API(s)
    
    // MARK: Other(s)
}

struct CostIn30Years: Identifiable {
    var id: ObjectIdentifier
    var name: String
    var cost: Int
}
