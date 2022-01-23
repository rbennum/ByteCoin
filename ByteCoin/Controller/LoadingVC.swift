//
//  LoadingVC.swift
//  ByteCoin
//
//  Created by Bening Ranum on 23/01/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation
import UIKit

class LoadingVC: UIViewController {
    var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = UIColor(hex: "#81EBEBFF")
        indicator.startAnimating()
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
        return indicator
    }()
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        return blurEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
        blurEffectView.frame = self.view.bounds
        view.insertSubview(blurEffectView, at: 0)
        
        loadingActivityIndicator.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.addSubview(loadingActivityIndicator)
    }
}
