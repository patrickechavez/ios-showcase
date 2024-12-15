//
//  GFButton.swift
//  GithubFollowers
//
//  Created by John Patrick Echavez on 8/14/22.
//

import UIKit

class FTButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        set(backgroundColor: backgroundColor, title: title)
        configure()
    }
    
    
    private func configure() {
    
        layer.cornerRadius      = 10
        setTitleColor(.white, for: .normal)
        
        titleLabel?.font        = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}

@available(iOS 17, *)
#Preview {
    FTButton(backgroundColor: .red, title: "Test Title")
}
