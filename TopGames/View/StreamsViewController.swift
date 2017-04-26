//
//  StreamsViewController.swift
//  TopGames
//
//  Created by ALINA HAMBARYAN on 4/26/17.
//  Copyright © 2017 ALINA HAMBARYAN. All rights reserved.
//

import UIKit
import APESuperHUD

class StreamsViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var game:String = ""
    var streams:[Stream] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = game
    }
  
    override func fetchData() {
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
        
        DataSource.fetchStreamForGame(name: game) { (response, error) in
            if let streams = response {
                self.streams = streams.sorted(by: {$0.viewers > $1.viewers} )
                APESuperHUD.removeHUD(animated: false, presentingView: self.view, completion: {self.tableView.reloadData()})
            }
            else {
                APESuperHUD.showOrUpdateHUD(icon: .info, message: (error?.localizedDescription)!, particleEffectFileName: nil, presentingView: self.view, completion: {})
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamCell", for: indexPath) as! StreamCell
        cell.configureCell(stream:self.streams[indexPath.row])
        return cell
    }

}
