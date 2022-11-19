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
    
    var charactersPerSecond: Double = 30
    var messagesToShow: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func show(messages: [Message]) {
        messagesToShow = messages
        
        // TODO: loop thru all messages?
        if let message = messages.first {
            show(message: message)
        }
    }
    
    func show(message: Message) {
        DispatchQueue.global(qos: .userInteractive).async {
            var current = message.text.startIndex
            while current < message.text.endIndex {
                let text = String(message.text[...current])
                DispatchQueue.main.async { self.set(text: text) }
                Thread.sleep(forTimeInterval: 1 / self.charactersPerSecond)
                let next = message.text.index(after: current)
                current = next
            }
        }
    }
    
    private func set(text: String) {
        messageLabel?.text = text
    }
    
    @IBAction func didTap() {
        // TODO: Move to next message if exists
        close()
    }
    
    private func close() {
        dismiss(animated: true)
    }
}
