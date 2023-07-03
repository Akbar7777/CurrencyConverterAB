//
//  CurrencyConverterViewController.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import UIKit
import RxSwift
import BottomPopUpView
import RxOptional

class CurrencyConverterViewController: UIViewController, ViewSpecificController {
    
    typealias RootView = CurrencyConverterRootView
    
    private let viewModel = CurrencyViewModel()
    private let dataProvider = CurrencyListDataProvider()
    private let bottomPopUpView = BottomPopUpView(wrapperContentHeight: UIScreen.main.bounds.height / 2)
    private var alert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUI()
        bind()
        // Do any additional setup after loading the view.
    }
    
    private func setup() {
        self.bottomPopUpView.tableView.dataSource = dataProvider
        self.bottomPopUpView.tableView.delegate = dataProvider
        self.bottomPopUpView.tableView.register(CurrencyListTableViewCell.self, forCellReuseIdentifier: CurrencyListTableViewCell.className)
        viewModel.getSymbols()
    }
    
    private func setupUI() {
        self.view = CurrencyConverterRootView()
        self.title = "Currency Converter"
        self.view().fromCurrencyTF.setCurrency(currency: viewModel.selectedFromCurrency.value)
        self.view().toCurrencyTF.setCurrency(currency: viewModel.selectedToCurrency.value)
    }
    
    private func bind() {
        
        self.view().bindFromCurrencyTextField(drive: viewModel.fromCurrencyInput)
        self.view().bindToCurrencyTextField(drive: viewModel.toCurrencyInput)
        
        self.viewModel.currencyList.asObservable().filter({ $0 != nil }).subscribe { [weak self] data in
            guard let self = self else { return }
            if let list = data.element {
                self.dataProvider.setup(with: list ?? [])
            }
            
        }.disposed(by: viewModel.disposeBag)
        
        self.dataProvider.onSelect = { [weak self] currency in
            guard let self = self else { return }
            self.viewModel.selectedToCurrency.accept(currency)
            self.view().toCurrencyTF.setCurrency(currency: currency)
            self.bottomPopUpView.dismiss(animated: true)
        }
        
        self.view().onToCurrencySelect = { [weak self] in
            guard let self = self else { return }
            self.present(self.bottomPopUpView, animated: true, completion: nil)
        }
        
        self.view().onSubmitButtonTap = { [weak self] in
            guard let self = self else { return }
            self.viewModel.updateRates()
        }
        
        viewModel.isLoading.asObservable().bind { [weak self] value in
            guard let self = self else { return }
            DispatchQueue.main.async {
                value ? self.showLoader() : self.hideLoader()
            }
        }.disposed(by: viewModel.disposeBag)
        
//        self.viewModel.error.asObservable().filter({ $0 != nil }).subscribe { [weak self] error in
//            guard let self = self,
//                  let error = error.element
//            else { return }
//
//            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
//            DispatchQueue.main.async {
//                self.present(alert, animated: true, completion: nil)
//            }
//        }.disposed(by: viewModel.disposeBag)
    }
    
    private func showLoader() {
        self.alert = UIAlertController(title: nil, message: "Loading.", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    private func hideLoader() {
        self.alert.dismiss(animated: true)
    }

}
