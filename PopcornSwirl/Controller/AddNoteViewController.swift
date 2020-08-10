//
//  AddNoteViewController.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 25/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class AddNoteViewController: UIViewController {
    
    // MARK: IBOutlets & IBActions
    
    @IBOutlet weak var artworkView: UIImageView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func dismissButton(_ sender: Any) {
        //Dismiss View Controller, and return to films view controller. Assumes no changes want to be saved.
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonAction(_ sender: Any) {
        // Function to save any changes to movie notes.
        filmBrief?.notes = noteTextView.text == "" || noteTextView.text == "Tap to add note..." ? nil : noteTextView.text
        
        // Save changes to CoreData model
        if filmBrief?.notes != nil {
            DataManager.shared.updateFilm(film: filmBrief!)
            DataManager.shared.filmList.first(where: {($0.id == filmBrief!.id)})?.notes = noteTextView.text
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Global Variables
    
    var filmBrief: FilmBrief?
    
    // MARK: Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        // Customer UI style
        overrideUserInterfaceStyle = .dark
        
        //Load film details.
        populate()
        
        //Show Keyboard
        noteTextView.becomeFirstResponder()
        noteTextView.delegate = self
        doneButton.isEnabled = false
    }
    
    func populate() {
        // Function to show movie data (title, image, and any notes)
        self.movieTitleLabel.text = filmBrief?.title
        if let imageURL = URL(string: filmBrief!.posterPath) {
            MediaService.getImage(imageURL: imageURL, completion: { (success, imageData) in
                if success, let imageData = imageData,
                    let artwork = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.artworkView.image = artwork
                    }
                }
                
            })
        }
        // Check if there are already notes for movie
        if let note = DataManager.shared.fetchFilm(id: filmBrief!.id)?.notes {
            noteTextView.text = note
        }
    }
    
}

//MARK: Text View Interactions
extension AddNoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        //Adjust size of text view, whilst users is typing.
        doneButton.isEnabled = textView.text != nil ? true : false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //If user presses return, keyboard should close.
        if (text == "\n"){
            textView.resignFirstResponder()
            self.doneButtonAction(self)
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            //Placeholder text for note
            textView.text = "Tap to add note..."
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        //If placeholder text, set to blank
        if textView.text == "Tap to add note..." {
            textView.text = ""
        }
    }

}
