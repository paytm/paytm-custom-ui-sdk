//
//  CustomizeConsentViewVC.swift
//  PaytmNativeSampleApp
//
//  Created by Aakash Srivastava on 01/02/21.
//  Copyright © 2021 Sumit Garg. All rights reserved.
//

import PaytmNativeSDK

protocol CustomizeConsentDelegate: class {
    func customize(with theme: AINativeConsentView.Theme)
}

final class CustomizeConsentViewVC: BaseViewController {

    @IBOutlet private weak var backgroundColorHexTF: UITextField!
    @IBOutlet private weak var textFontTF: UITextField!
    @IBOutlet private weak var textSizeTF: UITextField!
    @IBOutlet private weak var textColorTF: UITextField!
    @IBOutlet private weak var selectedCheckboxSFImageSymbolTF: UITextField!
    @IBOutlet private weak var selectedCheckboxTintColorHexTF: UITextField!
    @IBOutlet private weak var unselectedCheckboxSFImageSymbolTF: UITextField!
    @IBOutlet private weak var unselectedCheckboxTintColorHexTF: UITextField!
    
    var theme: AINativeConsentView.Theme! {
        didSet {
            setupViews()
        }
    }
    weak var delegate: CustomizeConsentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (theme == nil) {
            resetTheme()
        }
        backgroundColorHexTF.delegate = self
        textFontTF.delegate = self
        textSizeTF.delegate = self
        textColorTF.delegate = self
        selectedCheckboxSFImageSymbolTF.delegate = self
        selectedCheckboxTintColorHexTF.delegate = self
        unselectedCheckboxSFImageSymbolTF.delegate = self
        unselectedCheckboxTintColorHexTF.delegate = self
        
        if #available(iOS 13.0, *) { } else {
            selectedCheckboxSFImageSymbolTF.delegate = self
            unselectedCheckboxSFImageSymbolTF.delegate = self
        }
    }
}

private extension CustomizeConsentViewVC {
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseBackgroundColorHexBtnTapped(_ sender: UIButton) {
        moveToSearch(with: .color, textField: backgroundColorHexTF)
    }
    
    @IBAction func chooseTextFontBtnTapped(_ sender: UIButton) {
        moveToSearch(with: .font, textField: textFontTF)
    }
    
    @IBAction func chooseTextFontSizeBtnTapped(_ sender: UIButton) {
        moveToSearch(with: .fontSize, textField: textSizeTF)
    }
    
    @IBAction func chooseTextColorHexBtnTapped(_ sender: UIButton) {
        moveToSearch(with: .color, textField: textColorTF)
    }
    
    @IBAction func chooseSelectedCheckboxSFImageSymbolBtnTapped(_ sender: UIButton) {
        moveToSearch(with: .sfSymbol, textField: selectedCheckboxSFImageSymbolTF)
    }
    
    @IBAction func chooseSelectedCheckboxTintColorHexBtnTapped(_ sender: UIButton) {
        moveToSearch(with: .color, textField: selectedCheckboxTintColorHexTF)
    }
    
    @IBAction func chooseUnselectedCheckboxSFImageSymbolBtnTapped(_ sender: UIButton) {
        moveToSearch(with: .sfSymbol, textField: unselectedCheckboxSFImageSymbolTF)
    }
    
    @IBAction func chooseUnselectedCheckboxTintColorHexBtnTapped(_ sender: UIButton) {
        moveToSearch(with: .color, textField: unselectedCheckboxTintColorHexTF)
    }
    
    @IBAction func applyBtnTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        let backgroundColor: UIColor
        let textFont: String
        let textSize: CGFloat
        let textColor: UIColor
        let selectedCheckboxSFImage: UIImage?
        let selectedCheckboxTintColor: UIColor
        let unselectedCheckboxSFImage: UIImage?
        let unselectedCheckboxTintColor: UIColor
        let errorColor = UIColor.red.withAlphaComponent(0.4)
        
        if let colorHex = backgroundColorHexTF.text, !colorHex.isEmpty, (colorHex.count == 7) {
            backgroundColor = UIColor(hexString: colorHex)
        } else {
            backgroundColorHexTF.backgroundColor = errorColor
            return
        }
        if let tFont = textFontTF.text, !tFont.isEmpty {
            textFont = tFont
        } else {
            textFontTF.backgroundColor = errorColor
            return
        }
        if let sizeString = textSizeTF.text, let size = CGFloat(string: sizeString) {
            textSize = size
        } else {
            textSizeTF.backgroundColor = errorColor
            return
        }
        if let colorHex = textColorTF.text, !colorHex.isEmpty, (colorHex.count == 7) {
            textColor = UIColor(hexString: colorHex)
        } else {
            textColorTF.backgroundColor = errorColor
            return
        }
        if let colorHex = selectedCheckboxTintColorHexTF.text, !colorHex.isEmpty, (colorHex.count == 7) {
            selectedCheckboxTintColor = UIColor(hexString: colorHex)
        } else {
            selectedCheckboxTintColorHexTF.backgroundColor = errorColor
            return
        }
        if let colorHex = unselectedCheckboxTintColorHexTF.text, !colorHex.isEmpty, (colorHex.count == 7) {
            unselectedCheckboxTintColor = UIColor(hexString: colorHex)
        } else {
            unselectedCheckboxTintColorHexTF.backgroundColor = errorColor
            return
        }
        
        if #available(iOS 13.0, *) {
            if let sfSymbol = selectedCheckboxSFImageSymbolTF.text,
               !sfSymbol.isEmpty {
                selectedCheckboxSFImage = UIImage(systemName: sfSymbol)
            } else {
                selectedCheckboxSFImage = nil
            }
            if let sfSymbol = unselectedCheckboxSFImageSymbolTF.text,
               !sfSymbol.isEmpty {
                unselectedCheckboxSFImage = UIImage(systemName: sfSymbol)
            } else {
                unselectedCheckboxSFImage = nil
            }
        } else {
            selectedCheckboxSFImage = nil
            unselectedCheckboxSFImage = nil
        }
        
        if let font = UIFont(name: textFont, size: textSize) {
            let theme = AINativeConsentView.Theme(backgroundColor: backgroundColor,
                                                  textFont: font,
                                                  textColor: textColor,
                                                  selectedCheckboxImage: selectedCheckboxSFImage,
                                                  selectedCheckboxTint: selectedCheckboxTintColor,
                                                  unselectedCheckboxImage: unselectedCheckboxSFImage,
                                                  unselectedCheckboxTint: unselectedCheckboxTintColor)
            
            delegate?.customize(with: theme)
            dismiss(animated: true, completion: nil)
        } else {
            textFontTF.backgroundColor = errorColor
        }
    }
    
    @IBAction func discardBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        resetTheme()
    }
    
    func resetTheme() {
        theme = AINativeConsentView.Theme.default
    }
    
    func setupViews() {
        backgroundColorHexTF.text = theme.backgroundColor.hexString
        textFontTF.text = theme.textFont.familyName
        textSizeTF.text = theme.textFont.pointSize.string
        textColorTF.text = theme.textColor.hexString
        selectedCheckboxSFImageSymbolTF.text = nil
        selectedCheckboxTintColorHexTF.text = theme.selectedCheckboxTint.hexString
        unselectedCheckboxSFImageSymbolTF.text = nil
        unselectedCheckboxTintColorHexTF.text = theme.unselectedCheckboxTint.hexString
    }
    
    func moveToSearch(with type: GenericSearchVC.SearchType, textField: UITextField) {
        if let storyboard = storyboard {
            let genericSearchScene: GenericSearchVC?
            if #available(iOS 13.0, *) {
                genericSearchScene = storyboard.instantiateViewController(identifier: "GenericSearchVC") as? GenericSearchVC
            } else {
                genericSearchScene = storyboard.instantiateViewController(withIdentifier: "GenericSearchVC") as? GenericSearchVC
            }
            if let searchScene = genericSearchScene {
                searchScene.searchType = type
                searchScene.textField = textField
                present(searchScene, animated: true, completion: nil)
            }
        }
    }
}

extension CustomizeConsentViewVC {
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        textField.backgroundColor = .white
    }
}
