//
//  Fonts.swift
//  VideoFramework
//
//  Created by Gowthaman G on 08/07/21.
//

import Foundation
import UIKit

extension UIFont {
    private static func registerFont(withName name: String, fileExtension: String) {
        let frameworkBundle = Bundle(identifier: Constants.bundleId)
        let pathForResourceString = frameworkBundle!.path(forResource: name, ofType: fileExtension)
        let fontData = NSData(contentsOfFile: pathForResourceString!)
        let dataProvider = CGDataProvider(data: fontData!)
        let fontRef = CGFont(dataProvider!)
        var errorRef: Unmanaged<CFError>? = nil

        if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
            print("Error registering font")
        }else{
           print("Register successfully")
        }
        
    }

    public static func loadFonts() {
        registerFont(withName: "Montserrat-Bold", fileExtension: "ttf")
        registerFont(withName: "Montserrat-SemiBold", fileExtension: "ttf")
        registerFont(withName: "Montserrat-Regular", fileExtension: "ttf")
    }
}
