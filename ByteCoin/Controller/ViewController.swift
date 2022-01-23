//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    var loadingView: LoadingVC = {
        var loadingVC = LoadingVC()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        return loadingVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currencyPicker.selectRow(0, inComponent: 0, animated: false)
        selectRowOnPickerView(row: 0, inComponent: 0)
    }
}

extension ViewController: CoinManagerDelegate {
    func showLoading() {
        DispatchQueue.main.async {
            self.present(self.loadingView, animated: true, completion: nil)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.loadingView.dismiss(animated: true, completion: nil)
        }
    }
    
    func didFetchCurrencyRate(_ currencyRate: Double?) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f", currencyRate ?? 0.0)
        }
    }
    
    func didFailWithError(_ error: ErrorData?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: error?.error ?? "Nil error", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRowOnPickerView(row: row, inComponent: component)
    }
    
    private func selectRowOnPickerView(row: Int, inComponent: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        currencyLabel.text = selectedCurrency
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}
