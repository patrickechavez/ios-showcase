//
//  FTAvatarImageView.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/13/24.
//

import UIKit

class FTAvatarImageView: UIImageView {

    let placeholderImage = Images.placeholder

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    private func configure() {
        layer.cornerRadius   = 10
        clipsToBounds        = true
        image                = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    /*
    func downloadImage(url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
    */
}
