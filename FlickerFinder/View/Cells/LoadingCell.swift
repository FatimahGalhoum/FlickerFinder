//
//  LoadingCell.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/21/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {

    var activityIndicator: UIActivityIndicatorView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setupSubviews() {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .gray
        indicator.hidesWhenStopped = true
        
        contentView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            indicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ])
        
        indicator.startAnimating()
    }

}
