//
//  SearchDataSource.swift
//  TestProject7devs
//
//  Created by Alexey on 7/17/17.
//  Copyright © 2017 Alexey. All rights reserved.
//

import Foundation
import MapKit

typealias SearchResultCompletion = ([SearchResult]) -> Void
typealias CoordinateCompletion = (CLLocationCoordinate2D?) -> Void

struct SearchResult {
    let title: String
    let subtitle: String
}

class SearchDataSource: NSObject, MKLocalSearchCompleterDelegate {
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    var searchResultCompletion: SearchResultCompletion?
    
    override init() {
        super.init()
        
        searchCompleter.delegate = self
    }
    
    func updateSearchResultsWithString(string: String, completion: @escaping SearchResultCompletion) {
        self.searchResultCompletion = completion
        
        searchCompleter.queryFragment = string
    }
    
    func coordinateBySearchIndex(index: Int, completion: @escaping CoordinateCompletion) {
        let result = searchResults[index]
        
        let searchRequest = MKLocalSearchRequest(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            completion(coordinate)
        }
    }
    
    // MARK: MKLocalSearchCompleterDelegate
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        self.searchResults = completer.results
        
        let results = completer.results.map { (result) -> SearchResult in
            return SearchResult(title: result.title, subtitle: result.subtitle)
        }
        
        self.searchResultCompletion?(results)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
    }
}
