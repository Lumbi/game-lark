//
//  MessageViewController.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-18.
//

import Foundation
import UIKit

struct Message {
    let text: String
}

class MessageViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var nextMessageIcon: UIImageView?
    
    var charactersPerSecond: Double = 24
    var messagesToShow: [Message] = []
    
    var onDismiss: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func show(messages: [Message]) {
        messagesToShow = messages
        showNextMessage()
    }
    
    private func showNextMessage() {
        if let message = messagesToShow.first {
            messagesToShow.removeFirst()
            show(message: message)
        }
    }
    
    private func show(message: Message) {
        view.isUserInteractionEnabled = false
        nextMessageIcon?.isHidden = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            let count = message.text.count
            var current = 0
            while current <= count {
                let next = current + 1
                DispatchQueue.main.async {
                    self.updateText(with: message, showUntil: current)
                    let isCompleted = next >= count
                    if isCompleted {
                        self.view.isUserInteractionEnabled = true
                        self.nextMessageIcon?.isHidden = false
                    }
                }
                Thread.sleep(forTimeInterval: 1 / self.charactersPerSecond)
                current = next
            }
        }
    }
    
    private func updateText(with message: Message, showUntil endIndex: Int) {
        let attributedString = NSMutableAttributedString(string: message.text)
        let visibleRange = NSRange(location: 0, length: endIndex)
        let hiddenRange = NSRange(location: endIndex, length: message.text.count - endIndex)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: visibleRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.clear, range: hiddenRange)
        messageLabel?.attributedText = attributedString
    }
    
    @IBAction func didTap() {
        if messagesToShow.isEmpty {
            close()
        } else {
            showNextMessage()
        }
    }
    
    private func close() {
        dismiss(animated: true) {
            self.onDismiss?()
        }
    }
}
