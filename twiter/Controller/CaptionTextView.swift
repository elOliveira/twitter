//
//  CaptionTextView.swift
//  twiter
//
//  Created by cit on 16/08/22.
//

import UIKit

class CaptionTextView: UITextView {
    // MARK: - Lifecycle
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What's happenning?"
        return label
    }()
    // MARK: - Lifecycle
    
    override init (frame: CGRect, textContainer: NSTextContainer? ){
        super.init(frame:frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(
            top:topAnchor,
            left:leftAnchor,
            paddingTop: 8,
            paddingLeft: 4
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(gandleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func gandleTextInputChange(){
        placeholderLabel.isHidden = !text.isEmpty
    }
}
