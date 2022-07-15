//
//  ViewController.swift
//  Weather
//
//  Created by Dima  on 14.07.2022.
//

import UIKit

class ViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource {
    
    var timer = Timer()
    fileprivate var contentView:MainView {
        return self.view as! MainView
    }
    var dataIsReady:Bool = false
    var offerModel:OfferModel! {
        didSet {
            DispatchQueue.main.async {
                self.contentView.tableView.reloadData()
            }
            
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        (self.view as! MainView).tableView.dataSource = self
    }
    
    fileprivate func setupNavigationBar() {
        self.navigationItem.title = "Weather App"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let city = searchController.searchBar.text!
        timer.invalidate()
        
        if city.count > 1 {
            timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
                NetworkManager.shared.getWeather(city: city, result: { (model) in
                    if model != nil {
                        self.dataIsReady = true
                        self.offerModel = model
                    }
                })
            })
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataIsReady {
            return self.offerModel!.list!.count
        }else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        
        cell.cityLabel.text = self.offerModel.city!.name
        cell.timeLabel.text = self.offerModel.list![indexPath.row].dt_txt
        cell.tempLabel.text = self.offerModel.list![indexPath.row].main!.temp!.description
        //cell.humidityLabel.text = self.offerModel.list![indexPath.row].main!.humidity!.description
        
        
        return cell
    }
}
//lat=49.867000&lon=24.040306
