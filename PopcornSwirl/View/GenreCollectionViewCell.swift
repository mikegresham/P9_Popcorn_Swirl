//
//  CategoryCollectionViewCell.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 24/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

protocol GenreCollectionViewCellDelegate{
    func updateGenre(genre: FilmGenre)
}

class GenreCollectionViewCell: UICollectionViewCell {
    
    //MARK: Global Variables
    
    var delegate: GenreCollectionViewCellDelegate?
    var selectedGenre = String()

    
    //MARK: IBOutlets
    
    @IBOutlet weak var genreTextField: UITextField!
    
    //MARK: Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let genrePicker = UIPickerView()
        genrePicker.delegate = self
        genrePicker.dataSource = self
        genreTextField.tintColor = .clear
        genreTextField.inputView = genrePicker
        createToolBar()
    }
    
    func setGenre(genre: String) {
        self.selectedGenre = genre
        self.genreTextField.text = "\(genre) ▾"
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(GenreCollectionViewCell.dismissKeyBoard))
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        genreTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func dismissKeyBoard() {
        superview?.endEditing(true)
    }
    
}

extension GenreCollectionViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DataManager.shared.genreList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DataManager.shared.genreList[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.updateGenre(genre: DataManager.shared.genreList[row])
    }
}
