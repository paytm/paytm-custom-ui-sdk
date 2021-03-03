//
//  GenericSearchVC.swift
//  PaytmNativeSampleApp
//
//  Created by Aakash Srivastava on 01/02/21.
//  Copyright © 2021 Sumit Garg. All rights reserved.
//

import UIKit

final class GenericSearchVC: UIViewController {
    
    enum SearchType {
        case color
        case font
        case fontSize
        case sfSymbol
    }
    
    var searchType: SearchType = .color
    var textField: UITextField?
    
    private var items: [String] = []
    private var filteredItems: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        
        DispatchQueue.global().async {
            self.createDataSource()
        }
    }
}

private extension GenericSearchVC {
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func createDataSource() {
        switch searchType {
        case .color:
            items = Colors.all
        case .font:
            items = UIFont.familyNames
//                .forEach({ familyName in
//                        let fontNames = UIFont.fontNames(forFamilyName: familyName)
//                        print(familyName, fontNames)
//                    })
        case .fontSize:
            items = (0..<20).map { "\($0 + 11)" }
        case .sfSymbol:
            items = SFSymbols.all
        }
        DispatchQueue.main.async {
            self.filteredItems = self.items
        }
    }
}

extension GenericSearchVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenericSearchTVC", for: indexPath) as? GenericSearchTVC else {
            fatalError()
        }
        let item = filteredItems[indexPath.row]
        switch searchType {
        case .color:
            cell.label.text = item
            cell.imgView.backgroundColor = UIColor(hexString: item)
        case .font:
            cell.label.font = UIFont(name: item, size: 16)
            cell.label.text = item
        case .fontSize:
            let size = CGFloat(string: item)
            cell.label.font = UIFont.systemFont(ofSize: size!)
            cell.label.text = item
        case .sfSymbol:
            cell.label.text = item
            if #available(iOS 13.0, *) {
                let config = UIImage.SymbolConfiguration(pointSize: 20)
                cell.imgView.image = UIImage(systemName: item, withConfiguration: config)
            }
        }
        return cell
    }
}

extension GenericSearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let field = textField {
            field.text = filteredItems[indexPath.row]
            field.backgroundColor = .white
        }
        dismiss(animated: true, completion: nil)
    }
}

extension GenericSearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter { item -> Bool in
                return item.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredItems = items
    }
}

final class GenericSearchTVC: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imgView: UIImageView!
}
