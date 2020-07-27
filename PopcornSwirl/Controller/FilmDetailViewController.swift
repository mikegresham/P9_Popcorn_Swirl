//
//  FilmDetailViewController.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 18/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class FilmDetailViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.dataSource = self
        detailTableView.delegate = self
        overrideUserInterfaceStyle = .dark
        
        MediaService.getMedia(id: mediaID, completion: { (success, media) in
            if success, let media = media {
                self.media = media
                
                DispatchQueue.main.async {
                    self.detailTableView.reloadData()
                }
            } else {
                self.presentNoDataAlert(title: "Oops...", message: "No Data")
            }
            
        })
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        setNavigationBarTransparent()
    }
    
    func setNavigationBarTransparent() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    func setGradientLayer() {
        let width = backgroundImageView.frame.width
        let height = backgroundImageView.frame.height
        let sHeight:CGFloat = 100
        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        backgroundImageView.layer.insertSublayer(bottomImageGradient, at: 0)
    }
    var mediaID: Int!
    
    private var media: Media?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var viewedButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    
    func populate(media: Media){
        self.movieTitle.text = media.title
        self.descriptionLabel.text = media.overview
        self.bookmarkButton.isSelected = media.bookmark
        self.viewedButton.isSelected = media.viewed
        let caption = "\(media.yearText) ∙ \(formatRuntime(runtime: media.runtime!))"
        captionLabel.text = caption
        self.ratingLabel.text = media.ratingText + " " + media.scoreText

        if let imageURL = URL(string: media.backdropPath!) {
            MediaService.getImage(imageURL: imageURL, completion: { (success, imageData) in
                if success, let imageData = imageData,
                    let artwork = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.backgroundImageView.image = artwork
                    }
                }
                
            })
        }
    }
    
    
    func presentNoDataAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Got it!", style: .cancel, handler: {(action) -> Void in
        })
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    func formatRuntime(runtime: Int) -> String {
        let hours = runtime/60
        let minutes = runtime - (hours*60)
        
        let hoursplural = hours == 1 ? "" : "s"
        let minutesplural = minutes == 1 ? "" : "s"
        return "\(hours) hour\(hoursplural) \(minutes) minute\(minutesplural)"
    }
}
extension FilmDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageTableViewCell
            if media != nil {
            cell.setup(imageURL: media!.backdropPath!)
            }
            return cell
        default:
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "summaryCell") as! SummaryTableViewCell
            if media != nil {
            cell.populate(media: media!)
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return tableView.bounds.height/2
        default:
            return tableView.estimatedRowHeight
        }
    }
    
}
