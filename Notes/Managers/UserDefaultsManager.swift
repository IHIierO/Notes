//
//  UserDefaultsManager.swift
//  Notes
//
//  Created by Artem Vorobev on 03.02.2023.
//

import Foundation


final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    let defaults = UserDefaults.standard
    
    private var keys: [String] = []
    
    // MARK: - Save model to UserDefaults
    /// - Parameter model: Note model
    public func saveData(_ model: NoteTextModel) {
        let key = model.id
        
        if var keys = UserDefaultsManager.shared.defaults.stringArray(forKey: "Model.keys") {
            keys.append(key)
            UserDefaultsManager.shared.defaults.set(keys, forKey: "Model.keys")
        } else {
            keys.append(key)
            UserDefaultsManager.shared.defaults.set(keys, forKey: "Model.keys")
        }
        
        if (UserDefaultsManager.shared.defaults.object(forKey: key) as? Data) != nil {
            return
        } else {
            if let encoded = try? JSONEncoder().encode(model) {
                UserDefaultsManager.shared.defaults.set(encoded, forKey: key)
            }
        }
    }
    
    // MARK: - Get data from UserDefaults
    /// - Parameters:
    ///   - models: Note models
    ///   - completion: Get note for key
    public func getData(models: [NoteTextModel], completion: @escaping (Result<NoteTextModel,Error>) -> Void) {
        guard let keys = UserDefaultsManager.shared.defaults.stringArray(forKey: "Model.keys") else {
            return
        }
        for key in keys {
            if let data = UserDefaultsManager.shared.defaults.object(forKey: key) as? Data, let newNote = try? JSONDecoder().decode(NoteTextModel.self, from: data) {
                completion(.success(newNote))
            }
        }
    }
    
    // MARK: - Delete note
    /// - Parameter model: Note model
    public func deleteNote(model: NoteTextModel) {
        UserDefaultsManager.shared.defaults.removeObject(forKey: model.id)
        if var keys = UserDefaultsManager.shared.defaults.stringArray(forKey: "Model.keys") {
            keys.removeAll { key in
                key == model.id
            }
            UserDefaultsManager.shared.defaults.set(keys, forKey: "Model.keys")
        }
    }
    
    // MARK: - resetDefaults/delete all keys
    public func resetDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
