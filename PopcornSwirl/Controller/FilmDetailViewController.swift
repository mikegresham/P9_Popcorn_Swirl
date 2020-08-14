//
//  FilmDetailViewController.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 18/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class FilmDetailViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var detailTableView: UITableView!
    
    // MARK: Global Variables
    
    var indicator = UIActivityIndicatorView()
    var bannerView: GADBannerView!
    var filmID: Int?
    private var film: Film?
    
    //MARK: Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        
        // Load Film for selected film ID
        if let id = filmID {
            MediaService.getFilm(id: id, completion: { (success, film) in
                       if success, let film = film {
                           self.film = film
                           
                           DispatchQueue.main.async {
                               self.setBackgroundImage()
                               self.detailTableView.reloadData()
                               self.indicator.stopAnimating()
                           }
                       } else {
                           print("No Film")
                       }
                       
                   })
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        self.navigationController?.setNavigationBarHidden(false, animated: false) //Handles display of back button when segueing between detail view controllers
        setNavigationBarTransparent()
    }
    
    func config() {
        // Delegates and datasource
        detailTableView.dataSource = self
        detailTableView.delegate = self
        
        //Custom UI
        overrideUserInterfaceStyle = .dark
        registerForKeyboardNotifications()
        
        //Show activity indicator whilst film is loading
        activityIndicator()
        indicator.startAnimating()
        
        createBannerView() //Load Google Ads Banner
    }
    
    // MARK: Functions
    
    func activityIndicator() {
        // setup activity indicator
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
    }
    
    func setBackgroundImage() {
        if let imageURL = URL(string: film!.posterPath) {
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
    
    func setNavigationBarTransparent() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    func presentNoDataAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Got it!", style: .cancel, handler: {(action) -> Void in
        })
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    func formatRuntime(runtime: Int) -> String {
        //function to format runtime into hours and minutes
        let hours = runtime/60
        let minutes = runtime - (hours*60)
        
        let hoursplural = hours == 1 ? "" : "s"
        let minutesplural = minutes == 1 ? "" : "s"
        return "\(hours) hour\(hoursplural) \(minutes) minute\(minutesplural)"
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
}

// MARK: TableView Delegates and Datasource

extension FilmDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 5 Sections to table view (Picture, Summary, Notes, Recommended, and Adverts)
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            //Backdrop Image
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageTableViewCell
            if film != nil {
            cell.populate(imageURL: film!.backdropPath!)
            }
            return cell
        case 1:
            //Summary information
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "summaryCell") as! SummaryTableViewCell
            if film != nil {
            cell.populate(film: film!)
            }
            return cell
        case 2:
            //My Notes
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "noteCell") as! NoteTableViewCell
            if film != nil {
                cell.populate(film: film!)
                cell.delegate = self
            }
            return cell
        case 3:
            //Recommended Movies
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "recommendedCell") as! RecommendedTableViewCell
            if film != nil {
                cell.populate(recommendations: film!.recommendations!)
            }
            return cell
        case 4:
            //Google Mobile Ads Cell
            let cell = AdvertTableViewCell()
            cell.addBannerViewToView(bannerView)
            return cell
        default:
            let cell = UITableViewCell.init()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            //Set Image cell to half screen height.
            return tableView.bounds.height/2
        case 4:
            //Set Advert cell to height of google banner ad
            return bannerView.frame.height
        default:
            //Otherwise use estimated height
            return tableView.estimatedRowHeight
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Prepare for segue to show recommended film details
        if segue.identifier == "showRecommendedFilm" {
            let filmDetailViewController = segue.destination as! FilmDetailViewController
            let cell = sender as! RecommendedCollectionViewCell
            filmDetailViewController.filmID = cell.film?.id
        }
    }
}

// MARK: Other Delegates

extension FilmDetailViewController: NoteTableViewCellDelegate {
    func updateRowHeight() {
       // TableViewController handles row height automatically
        detailTableView.beginUpdates()
        detailTableView.endUpdates()
    }
}

extension FilmDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Function to Hide back button when view is scrolled down.
        if detailTableView.contentOffset.y > 200.0 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else if detailTableView.contentOffset.y <= 100.0 {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

extension FilmDetailViewController: GADBannerViewDelegate {
    
    //MARK: Google Mobile Ads
    
    func createBannerView() {
        bannerView = GADBannerView()
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.backgroundColor = .clear
    }
    // Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    override func viewWillTransition(to size: CGSize,
                            with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to:size, with:coordinator)
      coordinator.animate(alongsideTransition: { _ in
        self.loadBannerAd()
      })
    }

    func loadBannerAd() {
      // Step 2 - Determine the view width to use for the ad width.
      let frame = { () -> CGRect in
        // Here safe area is taken into account, hence the view frame is used
        // after the view has been laid out.
        if #available(iOS 11.0, *) {
          return view.frame.inset(by: view.safeAreaInsets)
        } else {
          return view.frame
        }
      }()
      let viewWidth = frame.size.width

      // Step 3 - Get Adaptive GADAdSize and set the ad view.
      // Here the current interface orientation is used. If the ad is being preloaded
      // for a future orientation change or different orientation, the function for the
      // relevant orientation should be used.
      bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)

      // Step 4 - Create an ad request and load the adaptive banner ad.
      bannerView.load(GADRequest())
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      // Note loadBannerAd is called in viewDidAppear as this is the first time that
      // the safe area is known. If safe area is not a concern (e.g., your app is
      // locked in portrait mode), the banner can be loaded in viewWillAppear.
      loadBannerAd()
    }
}
