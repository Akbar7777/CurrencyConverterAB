//
//  CurrencyListDataProvider.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation
import UIKit

final class CurrencyListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var data: [String]?
    
    var onSelect: ((String) -> Void)?
    
    func setup(with data: [String]) {
        self.data = data
    }
}
extension CurrencyListDataProvider {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListTableViewCell.className) as? CurrencyListTableViewCell else { return UITableViewCell() }
        cell.configure(text: data?[indexPath.row] ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currency = data?[indexPath.row] {
            self.onSelect?(currency)
        }
    }
}
