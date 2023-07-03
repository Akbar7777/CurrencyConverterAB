//
//  CurrencyListTableViewCell.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation
import UIKit

class CurrencyListTableViewCell: UITableViewCell {
    
    weak var label: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        
        let label = UILabel()
      
        
        label.textAlignment = .left
        label.numberOfLines = 0
        
        label.textColor = .black
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            
        }
        self.label = label
    }
    
    public func configure(text: String) {
        label.text = text
    }

}
