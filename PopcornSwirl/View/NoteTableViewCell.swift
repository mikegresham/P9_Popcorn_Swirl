//
//  NoteTableViewCell.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 27/07/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

protocol NoteTableViewCellDelegate {
    func updateRowHeight()
}

class NoteTableViewCell: UITableViewCell, UITextViewDelegate {
    var delegate: NoteTableViewCellDelegate?
    @IBOutlet weak var noteTextView: UITextView!
    
    var film: Film?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        noteTextView.delegate = self
        noteTextView.isScrollEnabled = false
        textViewDidChange(noteTextView)
    }
    
    func populate(film: Film) {
        self.film = film
        if let notes = film.notes, film.notes != "" {
            self.noteTextView.text = notes
        } else {
            noteTextView.text = "Tap to add note..."
        }
    }
    
    //MARK: Text View Interactions
        func textViewDidChange(_ textView: UITextView) {
            //Adjust size of text view, whilst users is typing.
            let size = CGSize(width: textView.frame.size.width, height: .infinity)
            let estimatedSize = textView.sizeThatFits(size)
            textView.frame.size.height = estimatedSize.height
            delegate?.self.updateRowHeight()
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            //If user presses return, keyboard should close.
            if (text == "\n"){
                textView.resignFirstResponder()
            }
            return true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == "" {
                //Placeholder text for goal
                textView.text = "Tap to add note..."
            } else {
                 film?.notes = noteTextView.text == "" ? nil : noteTextView.text
                       DataManager.shared.updateFilm(film: film!)
                       if noteTextView.text != nil && noteTextView.text != "Tap to add note..." {
                           DataManager.shared.filmList.first(where: {($0.id == film!.id)})?.notes = noteTextView.text
                       }
            }
            
        }
        func textViewDidBeginEditing(_ textView: UITextView) {
            //If placeholder text, set to blank
            if textView.text == "Tap to add note..." {
                textView.text = ""
            }
        }
}
