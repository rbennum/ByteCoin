//
//  ErrorData.swift
//  ByteCoin
//
//  Created by Bening Ranum on 23/01/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinError: LocalizedError {
    var error: String? { get }
}

struct ErrorData: Codable, CoinError {
    var error: String?
    
    enum CodingKeys: String, CodingKey {
        case error
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }
    
    init(error: Error?) {
        self.error = error?.localizedDescription ?? "Nil error"
    }
}
