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
    var messageCurrentlyShown: Message?
    var isTypingMessage: Bool = false
    
    var onDismiss: (() -> Void)? = nil

    private var textUpdateWorkItems: [DispatchWorkItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        cancelScheduledTextUpdates()
    }
    
    func show(messages: [Message]) {
        messagesToShow = messages
        showNextMessage()
    }
    
    private func showNextMessage() {
        if let message = messagesToShow.first {
            messagesToShow.removeFirst()
            messageCurrentlyShown = message
            show(message: message)
        }
    }
    
    private func show(message: Message) {
        cancelScheduledTextUpdates()

        nextMessageIcon?.isHidden = true
        isTypingMessage = true

        for current in 0...message.text.count {
            let work = DispatchWorkItem { self.updateText(with: message, showUntil: current) }

            DispatchQueue.main.asyncAfter(
                deadline: .now() + Double(current) * (1 / charactersPerSecond),
                execute: work
            )

            textUpdateWorkItems.append(work)
        }
    }
    
    private func updateText(with message: Message, showUntil endIndex: Int) {
        let attributedString = NSMutableAttributedString(string: message.text)
        let visibleRange = NSRange(location: 0, length: endIndex)
        let hiddenRange = NSRange(location: endIndex, length: message.text.count - endIndex)
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: visibleRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.clear, range: hiddenRange)
        messageLabel?.attributedText = attributedString

        let isCompleted = endIndex >= message.text.count
        isTypingMessage = !isCompleted
        nextMessageIcon?.isHidden = !isCompleted
    }

    private func skipTyping() {
        cancelScheduledTextUpdates()

        if let messageCurrentlyShown = messageCurrentlyShown {
            self.updateText(with: messageCurrentlyShown, showUntil: messageCurrentlyShown.text.count)
        }
    }

    private func cancelScheduledTextUpdates() {
        for workItem in textUpdateWorkItems {
            workItem.cancel()
        }
        textUpdateWorkItems.removeAll()
    }
    
    @IBAction func didTap() {
        if isTypingMessage {
            skipTyping()
        } else if messagesToShow.isEmpty {
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
