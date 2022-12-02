//
//  Event.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-12-02.
//

import Foundation

struct WeakRef { weak var to: AnyObject? }

class Event<T> {
    typealias Callback = (T) -> Void

    struct Handler {
        let owner: WeakRef
        let callback: Callback
    }

    private var handlers = [Handler]()

    func on(_ handler: Handler) {
        handlers.append(handler)
    }

    func emit(_ value: T) {
        handlers.removeAll(where: { $0.owner.to == nil })
        handlers.forEach { $0.callback(value) }
    }
}

protocol EventHandler: AnyObject {}

extension EventHandler {
    func handle<T>(_ callback: @escaping Event<T>.Callback) -> Event<T>.Handler {
        Event<T>.Handler(
            owner: WeakRef(to: self),
            callback: callback
        )
    }
}
