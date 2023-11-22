//
//  NSObject+Extension.swift
//  Movie_List_App
//
//  Created by israkul
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
