//
//  SearchViewController.swift
//  IMusic
//
//  Created by Платон Конкилов on 05.04.2020.
//  Copyright © 2020 Платон Конкилов. All rights reserved.
//

import UIKit
import Alamofire

struct TrackModel {
    var trackName: String
    var artistName: String
}

class SearchMusicViewController: UITableViewController {
    
    private var timer: Timer?
    var networkService = NetworkService()
    let searchController = UISearchController(searchResultsController: nil)
    
    var tracks = [Track]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupSearchBar()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    private func setupSearchBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId",for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = " \(track.trackName)\n\(track.artistName)"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = #imageLiteral(resourceName: "Image")
        return cell
    }
}

extension SearchMusicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false)  { (_) in
            self.networkService.fetchTask(searchText: searchText) { [weak self] (searchResults) in
                self?.tracks = searchResults?.results ?? []
                self?.tableView.reloadData()
                
            }
            
        }
    }
}
    

