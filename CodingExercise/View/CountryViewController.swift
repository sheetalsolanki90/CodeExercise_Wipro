//
//  CountryViewController.swift
//  CodingExercise
//
//  Created by Sheetal on 01/09/20.
//  Copyright © 2020 Sheetal.com. All rights reserved.
//

import UIKit
class CountryViewController: UIViewController {
    
    var tableView = UITableView()
    private var refreshControl = UIRefreshControl()
    var activityIndicator : UIActivityIndicatorView?
    
    lazy var viewModel: CountryViewModel = {
        return CountryViewModel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        initViewModel()
        // Do any additional setup after loading the view.
    }
    func configureTableView(){
        tableView = UITableView()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: Constants.COUNTRY_TABLEVIEW_CELL_IDENTIFIER)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = UIColor.white
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute:.bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        tableView.tableFooterView = UIView()
        //setting up Pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string:Constants.PULL_TO_REFRESH_MSG)
        refreshControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = self.view.center
        activityIndicator?.hidesWhenStopped = true
        self.view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }
    
    func hideActivityIndicator(){
        self.refreshControl.endRefreshing()
        if (activityIndicator != nil){
            activityIndicator?.stopAnimating()
        }
    }
    func initViewModel() {
        
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.showActivityIndicator()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.hideActivityIndicator()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.updateCountryTitle = { [weak self] () in
            DispatchQueue.main.async {
                self?.title = self?.viewModel.countryTitle
            }
        }
        viewModel.requestData()
    }
    func showAlert( _ message: String ) {
        self.refreshControl.endRefreshing()
        let alert = UIAlertController(title: Constants.AlertConstants.ALERT_TITLE, message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: Constants.AlertConstants.ALERT_OK, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Action when Pull to refresh event
    @objc func refreshListData(_ sender: Any) {
        self.refreshControl.endRefreshing()
        viewModel.requestData()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.COUNTRY_TABLEVIEW_CELL_IDENTIFIER, for: indexPath) as? CountryTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.countryCellViewModel = cellVM
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
}
