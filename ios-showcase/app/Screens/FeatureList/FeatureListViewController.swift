//
//  ViewController.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/13/24.
//

import UIKit

class FeatureListViewController: BaseViewController {
    
    enum Section {
        case main
    }
    
    var featureListTableView: UITableView = UITableView()
    
    var viewModel: FeatureListViewModel!
    var features: [Feature]    = Feature.mockData
    var dataSource: UITableViewDiffableDataSource<Section, Feature>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureFeatureTableView()
        configureDataSource()
        updateData(features)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Clear the selected row
        if let selectedIndexPath = featureListTableView.indexPathForSelectedRow {
            featureListTableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Features"
    }
    
    func configureFeatureTableView() {
        view.addSubview(featureListTableView)
        
        featureListTableView.frame       = view.bounds
        featureListTableView.rowHeight   = 80
        featureListTableView.delegate    = self
        featureListTableView.register(FeatureListTableViewCell.self, forCellReuseIdentifier: FeatureListTableViewCell.reuseUID)
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Feature>(tableView: featureListTableView, cellProvider: { tableView, indexPath, feature in
            let cell = tableView.dequeueReusableCell(withIdentifier: FeatureListTableViewCell.reuseUID, for: indexPath) as! FeatureListTableViewCell
            cell.set(feature: feature)
            return cell
        })
    }
    
    func updateData(_ features: [Feature]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Feature>()
        snapshot.appendSections([.main])
        snapshot.appendItems(features)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: false) }
    }
    
    deinit {
        print("\(self) deallocated")
    }

}

extension FeatureListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFeature = features[indexPath.row]
        viewModel.navigatetoSelectedFeature(selectedFeature: selectedFeature)
    }
}

@available(iOS 17, *)
#Preview {
    FeatureListViewController()
}
