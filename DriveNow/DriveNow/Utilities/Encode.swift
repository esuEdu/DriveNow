//
//  Encode.swift
//  DriveNow
//
//  Created by Eduardo on 08/12/24.
//

import Foundation

func encode<T: Encodable>(_ data: T) -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    do {
        let encodedData = try encoder.encode(data)
        
        return encodedData
    } catch {
        fatalError("Error encoding data: \(error)")
    }
}
