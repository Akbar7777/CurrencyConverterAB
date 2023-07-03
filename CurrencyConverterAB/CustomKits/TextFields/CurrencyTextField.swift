//
//  CurrencyTextField.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class CurrencyTextField: UIView {
    
    var currencyButtonTapped: (() -> Void)?
    var isTextFieldEnabled: Bool = true

    let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.rightViewMode = .always
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let selectedCurrency = BehaviorRelay<String?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    private let currencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▼", for: .normal)
        return button
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        bind()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    private func setupViews() {
        addSubview(textField)
        
        
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(8)
        }
        
        let rightView = UIStackView()
        rightView.axis = .horizontal
        
        rightView.addArrangedSubview(currencyLabel)
        rightView.addArrangedSubview(currencyButton)
        
        currencyLabel.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        
        textField.rightView = rightView
        textField.delegate = self
        
        currencyButton.addTarget(self, action: #selector(currencyButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func bind() {
        selectedCurrency
            .asObservable()
            .bind(to: currencyLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    @objc private func currencyButtonTapped(_ sender: UIButton) {
        // Call the dropdownButtonTapped closure when the button is tapped
        currencyButtonTapped?()
    }
    
    func setCurrency(currency: String?) {
        self.selectedCurrency.accept(currency)
        textField.placeholder = currency?.isEmpty ?? true ? "Select Currency" : "Enter amount"
    }
}
extension CurrencyTextField: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isTextFieldEnabled
    }
}
