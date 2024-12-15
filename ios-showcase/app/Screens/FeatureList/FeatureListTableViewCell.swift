//
//  FeatureListTableViewCell.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/13/24.
//

import UIKit

class FeatureListTableViewCell: UITableViewCell {
    
    static let reuseUID = "FeatureListTableViewCell"
    let iconImageView  = UIImageView()
    let featureName = FTTitleLabel(textAlignment: .left, fontSize: 22)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(feature: Feature) {
        iconImageView.image = UIImage(systemName: feature.iconName)
        featureName.text = feature.featureName
    }
    
    private func configure() {
        addSubview(iconImageView)
        addSubview(featureName)
        
        let padding: CGFloat     = 12

        iconImageView.tintColor = .label
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
        ])

        NSLayoutConstraint.activate([
            featureName.centerYAnchor.constraint(equalTo: centerYAnchor),
            featureName.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 24),
            featureName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            featureName.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

}

@available(iOS 17, *)
#Preview {
    let mockFeature = Feature(id: UUID(),
                              iconName: "qrcode.viewfinder",
                              featureName: "QR Code Scanner",
                              screen: .qrCodeScanner)
    let cell = FeatureListTableViewCell(style: .default, reuseIdentifier: FeatureListTableViewCell.reuseUID)
    cell.set(feature: mockFeature)
    return cell
}
