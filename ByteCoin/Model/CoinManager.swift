//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFetchCurrencyRate(_ currencyRate: Double?)
    func didFailWithError(_ error: ErrorData?)
    func showLoading()
    func hideLoading()
}

enum CoinManagerParsingError: Error {
    case wrongFormat(String)
}

struct CoinManager {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "<put-your-API-key-here>"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let formattedTimestamp = getCurrentDate().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        guard let url = URL(string: "\(baseURL)/\(currency)?time=\(formattedTimestamp)") else { return }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("deflate; gzip", forHTTPHeaderField: "Accept-Encoding")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.delegate?.hideLoading()
            
            guard error == nil else {
                delegate?.didFailWithError(ErrorData(error: error))
                delegate?.didFetchCurrencyRate(nil)
                return
            }
            
            guard let data = data else {
                delegate?.didFailWithError(nil)
                delegate?.didFetchCurrencyRate(nil)
                return
            }
                        
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let errorData = parseErrorJSON(data)
                delegate?.didFailWithError(errorData)
                delegate?.didFetchCurrencyRate(nil)
                return
            }
            
            let coinData = parseJSON(data)
            delegate?.didFetchCurrencyRate(coinData?.rate)
        }
        
        delegate?.showLoading()
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> CoinData? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
    
    func parseErrorJSON(_ data: Data) -> ErrorData? {
        let decoder = JSONDecoder()

        do {
            let decodedError = try decoder.decode(ErrorData.self, from: data)
            return decodedError
        } catch {
            return nil
        }
    }
    
    private func getCurrentDate() -> String {
        guard let currentDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date()) else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "id_ID")
        return dateFormatter.string(from: currentDate)
    }
}
