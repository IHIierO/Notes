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
    
    public func saveData(_ model: NoteTextModel) {
        print("Saved Started")
        let key = model.id
        
        if var keys = UserDefaultsManager.shared.defaults.stringArray(forKey: "Model.keys") {
            keys.append(key)
            UserDefaultsManager.shared.defaults.set(keys, forKey: "Model.keys")
        } else {
            keys.append(key)
            UserDefaultsManager.shared.defaults.set(keys, forKey: "Model.keys")
        }
        print("Keys: - \(UserDefaultsManager.shared.defaults.array(forKey: "Model.keys"))")
        
        if ((UserDefaultsManager.shared.defaults.object(forKey: key) as? Data) != nil) {
            print("The model already exists")
        } else {
            if let encoded = try? JSONEncoder().encode(model) {
                print("Encode: - \(encoded)")
                UserDefaultsManager.shared.defaults.set(encoded, forKey: key)
                print("Key: - \(key)")
                print("Save Complete")
            }
        }
        
        print("Сохранить")
    }
    
    public func getData(models: [NoteTextModel], completion: @escaping (Result<NoteTextModel,Error>) -> Void) {
        print("Remade Started")
        guard let keys = UserDefaultsManager.shared.defaults.stringArray(forKey: "Model.keys") else {return}
        print("StorageKeys: -\(keys)")
        print("Keys Count: - \(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)")
        for key in keys {
            if let data = UserDefaultsManager.shared.defaults.object(forKey: key) as? Data, let newNote = try? JSONDecoder().decode(NoteTextModel.self, from: data) {
                completion(.success(newNote))
                print("Remade Complete")
                print("Note: - \(newNote)")
            } else {
                print("Remade Not Complete")
                completion(.failure(URLError(.badServerResponse)))
            }
        }
    }
    
    public func deleteNote(model: NoteTextModel) {
        print("Delete Started")
        UserDefaultsManager.shared.defaults.removeObject(forKey: model.id)
        if var keys = UserDefaultsManager.shared.defaults.stringArray(forKey: "Model.keys") {
            keys.removeAll { key in
                key == model.id
            }
            UserDefaultsManager.shared.defaults.set(keys, forKey: "Model.keys")
        }
        print("Delete Complete")
    }
    
    public func resetDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print("Reset Keys Count: - \(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)")
    }
}
