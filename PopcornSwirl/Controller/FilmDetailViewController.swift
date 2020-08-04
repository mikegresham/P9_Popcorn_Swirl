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
                    self.setBackgroundImage()
                    self.detailTableView.reloadData()
                }
            } else {
                self.presentNoDataAlert(title: "Oops...", message: "No Data")
            }
            
        })
        registerForKeyboardNotifications()
    }
    
    //MARK: Keyboard Handling
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification){
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        adjustLayoutForKeyboard(targetHeight: keyboardFrame.size.height)
    }

    @objc func keyboardWillHide(notification: NSNotification){
        adjustLayoutForKeyboard(targetHeight: 0)
    }

    func adjustLayoutForKeyboard(targetHeight: CGFloat){
        detailTableView.contentInset.bottom = targetHeight
    }
    
    
    func setBackgroundImage() {
        if let imageURL = URL(string: media!.posterPath) {
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
    var mediaID: Int!
    
    private var media: Media?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    

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
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageTableViewCell
            if media != nil {
            cell.setup(imageURL: media!.backdropPath!)
            }
            return cell
        case 1:
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "summaryCell") as! SummaryTableViewCell
            if media != nil {
            cell.populate(media: media!)
            }
            return cell
        case 2:
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "noteCell") as! NoteTableViewCell
            if media != nil {
                cell.populate(media: media!)
                cell.delegate = self
            }
            return cell
        default:
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "noteCell") as! NoteTableViewCell
            if media != nil {
                cell.populate(media: media!)
                cell.delegate = self
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

extension FilmDetailViewController: NoteTableViewCellDelegate {
    func updateRowHeight() {
       //TableViewController handles row height automatically
        detailTableView.beginUpdates()
        detailTableView.endUpdates()
    }
    
}
