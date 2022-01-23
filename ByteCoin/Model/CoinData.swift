//
//  CoinData.swift
//  ByteCoin
//
//  Created by Bening Ranum on 22/01/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    let time: String?
    let paramLeftHand: String?
    let paramRightHand: String?
    let rate: Double?
    
    enum CodingKeys: String, CodingKey {
        case time
        case paramLeftHand = "asset_id_base"
        case paramRightHand = "asset_id_quote"
        case rate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        paramLeftHand = try values.decodeIfPresent(String.self, forKey: .paramLeftHand)
        paramRightHand = try values.decodeIfPresent(String.self, forKey: .paramRightHand)
        rate = try values.decodeIfPresent(Double.self, forKey: .rate)
    }
}
