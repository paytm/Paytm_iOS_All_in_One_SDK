//
//  ViewController.swift
//  AllInOneSDK_SampleApp
//
//  Created by Paytm on 15/09/20.
//  Copyright © 2020 Paytm. All rights reserved.
//

import UIKit
import AppInvokeSDK

class ViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var environmentSegmentControl: UISegmentedControl!
    @IBOutlet weak var merchantIdTextField: UITextField!
    @IBOutlet weak var orderIdTextField: UITextField!
    @IBOutlet weak var txnTokenTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var callbackTextField: UITextField!
    
    //MARK: Private Properties
    private let handler = AIHandler()

    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handler.version()
    }
}

//MARK:- Button Action Methods
extension ViewController {
    @IBAction func onTapMerchantPaymentButton(_ sender: UIButton) {
        let mid = self.merchantIdTextField.text!
        let orderId = self.orderIdTextField.text!
        let txnToken = self.txnTokenTextField.text!
        let amount = self.amountTextField.text!
        let callback = self.callbackTextField.text!
        let environment: AIEnvironment = (self.environmentSegmentControl.selectedSegmentIndex == 0) ? .production : .staging
        
        self.handler.openPaytm(merchantId: mid, orderId: orderId, txnToken: txnToken, amount: amount, callbackUrl: callback, delegate: self, environment: environment)
    }
    
    @IBAction func onTapSubscriptionPaymentButton(_ sender: UIButton) {
        let mid = self.merchantIdTextField.text!
        let orderId = self.orderIdTextField.text!
        let txnToken = self.txnTokenTextField.text!
        let amount = self.amountTextField.text!
        let callback = self.callbackTextField.text!
        let environment: AIEnvironment = (self.environmentSegmentControl.selectedSegmentIndex == 0) ? .production : .staging

        self.handler.openPaytmSubscription(merchantId: mid, orderId: orderId, txnToken: txnToken, amount: amount, callbackUrl: callback, delegate: self, environment: environment)
    }
}

// MARK:- AIDelegate
extension ViewController: AIDelegate {
    func didFinish(with status: AIPaymentStatus, response: [String : Any]) {
        print("Paytm Callback Response: ", response)
        self.showAlert(title: "\(status)", message:  String(describing: response))
    }
    
    func openPaymentWebVC(_ controller: UIViewController?) {
        if let vc = controller {
            DispatchQueue.main.async {[weak self] in
                self?.present(vc, animated: true, completion: nil)
            }
        }
    }
}

//MARK:- UITextFieldDelegate methods
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
