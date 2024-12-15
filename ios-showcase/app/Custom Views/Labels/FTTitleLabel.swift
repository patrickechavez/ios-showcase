//
//  FTTitleLabel.swift
//  GithubFollowers
//
//  Created by John Patrick Echavez on 8/21/22.
//

import UIKit

class FTTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = .systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    
    private func configure() {
        textColor                   = .label
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.9
        lineBreakMode               = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
        text = "Sample Text"
    }
    
}

@available(iOS 17, *)
#Preview {
    FTTitleLabel(textAlignment: .left, fontSize: 26)
}

