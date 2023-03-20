//
//  File.swift
//  
//
//  Created by 오하온 on 19/03/23.
//

import Foundation

extension String {
    func append(if condition: Bool, _ other: Self) -> Self {
        self + (condition ? other : "")
    }
}
