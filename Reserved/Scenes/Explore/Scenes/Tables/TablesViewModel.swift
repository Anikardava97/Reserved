//
//  TablesViewModel.swift
//  Reserved
//
//  Created by Ani's Mac on 01.02.24.
//

import Foundation

final class TablesViewModel {
    // MARK: - Properties
    let tableImages = ["Table12", "Table2", "Table8", "Table9",
                       "Table6", "Table4", "Table10", "Table3",
                       "Table2", "Table5", "Table7", "Table1",
                       
                       "Table11", "Table5", "Table2", "Table3",
                       "Table8", "Table4","Table12", "Table9",
                       "Table6", "Table10", "Table1", "Table7"]
    
    
    
    var selectedRestaurant: Restaurant?
    var selectedDate: String?
    var selectedTime: String?
    var selectedGuests: Int?
    
    // MARK: - Init
    init(selectedRestaurant: Restaurant?, selectedDate: String?, selectedTime: String?, selectedGuests: Int?) {
        self.selectedRestaurant = selectedRestaurant
        self.selectedDate = selectedDate
        self.selectedTime = selectedTime
        self.selectedGuests = selectedGuests
    }
    
    // MARK: - Methods
    func isTableAvailable(forGuests guests: Int, tableIndex: Int) -> Bool {
        let tableCapacity = Table.tables[tableIndex].capacity
        return tableCapacity == guests
    }
}
