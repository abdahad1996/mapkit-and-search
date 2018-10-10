//
//  LocationSearchTable.swift
//  MapkitSearch
//
//  Created by Arsal Jamal on 10/10/2018.
//  Copyright © 2018 abdulahad. All rights reserved.
//

import UIKit
import MapKit


class LocationSearchTable: UITableViewController {

    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text =  parseAddress(item : selectedItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
    
    func parseAddress(item :MKPlacemark ) -> String{
        var address = ""
    
        if let streetno = item.subThoroughfare{
            address += "\(streetno)"
            if let streetname = item.thoroughfare{
                address += " \(streetname)"
                if let locality = item.locality{
                    address += ",\(locality)"
                    if let state = item.administrativeArea {
                        address += " \(state)"
                    }
                }
            }
            
        }
        else
        {
                address = "error :\(NSDate())"
            }
            
        
        return address
    }

}
extension LocationSearchTable : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapview = mapView , let searchBarText = searchController.searchBar.text else{
            return
        }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapview.region
        
        let search = MKLocalSearch(request: request)
        search.start{ (response, error) in
            guard let res = response else {
                return
            }
            self.matchingItems = res.mapItems
            self.tableView.reloadData()
        }
        
        
    }
}
