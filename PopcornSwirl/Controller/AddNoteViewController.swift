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
    
    @IBOutlet weak var artworkView: UIImageView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonAction(_ sender: Any) {
        mediaBrief?.notes = noteTextView.text == "" ? nil : noteTextView.text
        DataManager.shared.updateMedia(media: mediaBrief!)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var mediaBrief: MediaBrief?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        populate()
        noteTextView.becomeFirstResponder()
        noteTextView.delegate = self
        doneButton.isEnabled = false
        
        
    }
    func populate() {
        self.movieTitleLabel.text = mediaBrief?.title
        if let imageURL = URL(string: mediaBrief!.posterPath) {
            MediaService.getImage(imageURL: imageURL, completion: { (success, imageData) in
                if success, let imageData = imageData,
                    let artwork = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.artworkView.image = artwork
                    }
                }
                
            })
        }
        if let note = DataManager.shared.fetchMedia(id: mediaBrief!.id)?.notes {
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
            //Placeholder text for goal
            textView.text = "Add your thoughts here..."
        } else {
            //Update Goal
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        //If placeholder text, set to blank
        if textView.text == "Add your thoughts here..." {
            textView.text = ""
        }
    }

}
