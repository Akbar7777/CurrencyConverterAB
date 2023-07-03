//
//  CurrencyConverterRootView.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import BottomPopUpView

class CurrencyConverterRootView: UIView {
    
    var fromCurrencyTF: CurrencyTextField!
    var toCurrencyTF: CurrencyTextField!
    
    private var submitButton: UIButton!
    private let disposeBag = DisposeBag()
    
    var onFromCurrencySelect: (() -> Void)?
    var onToCurrencySelect: (() -> Void)?
    var onSubmitButtonTap: (() -> Void)?
        
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        clipsToBounds = true
        backgroundColor = .white
        
        setupFromCurrencyTF()
        setupToCurrencyTF()
        setupSubmitButton()
        
    }
    
    private func setupFromCurrencyTF() {
        fromCurrencyTF = CurrencyTextField()
        fromCurrencyTF.currencyButtonTapped = {
            self.onFromCurrencySelect?()
        }
        self.addSubview(fromCurrencyTF)
        fromCurrencyTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview().offset(-(UIScreen.main.bounds.width * 44 / 414))
            make.height.equalTo(UIScreen.main.bounds.width * 44 / 414)
        }
    }
    
    private func setupToCurrencyTF() {
        toCurrencyTF = CurrencyTextField()
        toCurrencyTF.isTextFieldEnabled = false
        toCurrencyTF.currencyButtonTapped = {
            self.toCurrencyTF.textField.text = ""
            self.onToCurrencySelect?()
        }
        self.addSubview(toCurrencyTF)
        
        toCurrencyTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(UIScreen.main.bounds.width * 44 / 414)
            make.top.equalTo(fromCurrencyTF.snp.bottom).offset(16)
        }
    }
    
    private func setupSubmitButton() {
        submitButton = UIButton(type: .system)
        
        submitButton.backgroundColor = .black.withAlphaComponent(0.9)
        submitButton.layer.cornerRadius = (UIScreen.main.bounds.width * 44 / 414) / 2
        submitButton.setTitle("Submit", for: .normal)
        
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitleColor(UIColor.lightGray, for: .disabled)
        
        self.addSubview(submitButton)
        
        submitButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(UIScreen.main.bounds.width * 44 / 414)
            make.bottom.equalToSuperview().inset(32)
        }
        submitButton.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        
        Observable
            .combineLatest(fromCurrencyTF.textField.rx.text, toCurrencyTF.selectedCurrency)
            .map { text, item in
                return !(text ?? "").isEmpty && item != nil
            }
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func bindFromCurrencyTextField(drive: BehaviorRelay<String>) {
        
        fromCurrencyTF.textField.rx.text
            .orEmpty
            .changed
            .flatMap({ return Observable.just($0.formatCurrency()) })
            .bind(to: drive)
            .disposed(by: disposeBag)
        
        drive
            .bind(to: fromCurrencyTF.textField.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    func bindToCurrencyTextField(drive: BehaviorRelay<String>) {
        
        toCurrencyTF.textField.rx.text
            .orEmpty
            .changed
            .flatMap({ return Observable.just($0.formatCurrency()) })
            .bind(to: drive)
            .disposed(by: disposeBag)
        
        
        drive
            .bind(to: toCurrencyTF.textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    @objc private func submitButtonTapped(_ sender: UIButton) {
        onSubmitButtonTap?()
    }
}
