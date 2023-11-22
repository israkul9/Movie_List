//
//  PrintUtility.swift
// Movie_List_App
//
//  Created by Israkul 
//

import Foundation


public class PrintUtility {
    static var isPrintingOn = true

    public static func printLog(tag : String, text : String) {
        if isPrintingOn {
           let timeStmp = generateCurrentTimeStamp()
            print(timeStmp + " " + tag + " " + text)
        }
    }
    public static func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd HH_mm_ss_SSS"
        return (formatter.string(from: Date()) as NSString) as String
    }
}
