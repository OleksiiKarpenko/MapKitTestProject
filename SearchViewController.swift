//
//  SearchViewController.swift
//  TestProject7devs
//
//  Created by Alexey on 7/10/17.
//  Copyright © 2017 Alexey. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
        
    var selectedCoordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    let searchDataSource = SearchDataSource()
    var searchResults = [SearchResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "identifier" {
            if let selectedCoordinate = self.selectedCoordinate {
                let mapVC = segue.destination as! MapViewController
                mapVC.destinationCoordinate = selectedCoordinate
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDataSource.updateSearchResultsWithString(string: searchText) { (results) in
            self.searchResults = results
            self.searchResultsTableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        searchDataSource.coordinateBySearchIndex(index: indexPath.row) { (coordinate) in
            if let coordinate = coordinate {
                self.selectedCoordinate = coordinate
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "identifier", sender: self)
                }
            }
        }
    }
}

