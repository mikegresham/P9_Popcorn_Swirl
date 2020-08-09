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
    
    var media: Media?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        noteTextView.delegate = self
        noteTextView.isScrollEnabled = false
        textViewDidChange(noteTextView)
    }
    
    func populate(media: Media) {
        self.media = media
        if let notes = media.notes, media.notes != "" {
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
                 media?.notes = noteTextView.text == "" ? nil : noteTextView.text
                       DataManager.shared.updateMedia(media: media!)
                       if noteTextView.text != nil && noteTextView.text != "Tap to add note..." {
                           DataManager.shared.mediaList.first(where: {($0.id == media!.id)})?.notes = noteTextView.text
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
