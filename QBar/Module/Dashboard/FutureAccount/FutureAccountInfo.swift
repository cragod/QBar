//
//  FutureAccountInfo.swift
//  QBar
//
//  Created by Talon Huang on 2022/6/2.
//

import Foundation

struct FutureAccountInfo: Codable {
    var walletBalance: Double
    var unrealizedProfit: Double
    var marginBalance: Double
    
    var unrealizedProfitPercent: Double {
        if walletBalance.isZero {
            return 0
        }
        return unrealizedProfit / walletBalance
    }
    
    enum CodingKeys: String, CodingKey {
        case walletBalance = "totalWalletBalance"
        case unrealizedProfit = "totalUnrealizedProfit"
        case marginBalance = "totalMarginBalance"
    }
    
    init() {
        walletBalance = 0
        unrealizedProfit = 0
        marginBalance = 0
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        walletBalance = Double(try values.decode(String.self, forKey: .walletBalance)) ?? 0
        unrealizedProfit = Double(try values.decode(String.self, forKey: .unrealizedProfit)) ?? 0
        marginBalance = Double(try values.decode(String.self, forKey: .marginBalance)) ?? 0
    }
    
}
