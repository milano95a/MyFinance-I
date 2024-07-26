//
//  UserDefaults.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 26/07/24.
//

import Foundation

extension UserDefaults {
    struct Keys {
        static let selectedUnitOfCounting: String = "selectedUnitOfCounting"
        static let selectedPreferenceShowYearlyTotal: String = "selectedPreferenceShowYearlyTotal"
        static let selectedPreferenceShowMonthlyTotal: String = "selectedPreferenceShowMonthlyTotal"
        static let selectedPreferenceShowWeeklyTotal: String = "selectedPreferenceShowWeeklyTotal"
        static let selectedPreferenceShowDailyTotal: String = "selectedPreferenceShowDailyTotal"
        static let selectedPreferenceShowExpenses: String = "selectedPreferenceShowExpenses"
    }
    
    static var selectedUnitOfCounting: MFUnit {
        get {
            if let selectedUnitOfCountingStr = UserDefaults.standard.string(forKey: Keys.selectedUnitOfCounting) {
                return MFUnit(rawValue: selectedUnitOfCountingStr) ?? .som
            } else {
                return .som
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.selectedUnitOfCounting)
        }
    }
    
    static var selectedPreferenceShowYearlyTotal: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.selectedPreferenceShowYearlyTotal)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.selectedPreferenceShowYearlyTotal)
        }
    }

    static var selectedPreferenceShowMonthlyTotal: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.selectedPreferenceShowMonthlyTotal)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.selectedPreferenceShowMonthlyTotal)
        }
    }

    static var selectedPreferenceShowWeeklyTotal: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.selectedPreferenceShowWeeklyTotal)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.selectedPreferenceShowWeeklyTotal)
        }
    }
    
    static var selectedPreferenceShowDailyTotal: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.selectedPreferenceShowDailyTotal)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.selectedPreferenceShowDailyTotal)
        }
    }
    
    static var selectedPreferenceShowExpenses: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.selectedPreferenceShowExpenses)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.selectedPreferenceShowExpenses)
        }
    }
}
