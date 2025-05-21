//
//  ExportManager.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 18/05/23.
//

import Foundation
import RealmSwift

class ExportManager: ObservableObject {
    func exportData() -> URL? {
        let realm = try! Realm()
        let expenses = realm.objects(Expense.self)
        let debts = realm.objects(Debt.self)
        let credits = realm.objects(Credit.self)
        let savings = realm.objects(Saving.self)
        let exportData = ExportData(expenses: Array(expenses), debts: Array(debts), credits: Array(credits), savings: Array(savings))
        let jsonData = try! JSONEncoder().encode(exportData)
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return nil }
        let fileName = "\(Date().dayOfTheYear)-\(Date().monthOfTheYear)-\(Date().year)"
        let fileURL = directory.appendingPathComponent("my-finance-\(fileName).json")
        try! jsonData.write(to: fileURL, options: .atomic)
        return fileURL
    }
}

struct ExportData: Codable {
    let expenses: [Expense]
    let debts: [Debt]
    let credits: [Credit]
    let savings: [Saving]
    
    init(expenses: [Expense], debts: [Debt], credits: [Credit], savings: [Saving]) {
        self.expenses = expenses
        self.debts = debts
        self.credits = credits
        self.savings = savings
    }
    
    enum CodingKeys: String, CodingKey {
        case expenses
        case debts
        case credits
        case savings
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        expenses = try values.decode([Expense].self, forKey: .expenses)
        debts = try values.decode([Debt].self, forKey: .debts)
        credits = try values.decode([Credit].self, forKey: .credits)
        savings = try values.decode([Saving].self, forKey: .savings)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(expenses, forKey: .expenses)
        try container.encode(debts, forKey: .debts)
        try container.encode(credits, forKey: .credits)
        try container.encode(savings, forKey: .savings)
    }
}
