//
//  StorageManager.swift
//  ChatMe
//
//  Created by Ivan Magda on 09.08.2024.
//

import SwiftUI
import FirebaseStorage
import os

final class StorageManager: StorageManagerProtocol {
    private let logger = Logger(
        subsystem: String(describing: Bundle.main.bundleIdentifier),
        category: String(describing: StorageManager.self)
    )
    
    static let shared = StorageManager()
    
    private let storage: Storage
    
    init() {
        self.storage = Storage.storage()
    }
    
    func storeImage(_ imageData: Data, userId: String) {
        let ref = storage.reference(withPath: userId)
        ref.putData(imageData)
    }
}

protocol StorageManagerProtocol {
    func storeImage(_ imageData: Data, userId: String)
}

