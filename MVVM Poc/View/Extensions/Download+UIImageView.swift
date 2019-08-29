//
//  Download+UIImageView.swift
//  MVVM Poc
//
//  Created by VB on 29.08.2019.
//  Copyright © 2019 Koçsistem. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadFromUrl(url: URL,contentMode mode : UIView.ContentMode = ContentMode.scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    
    
    func downloadFromUrl(link: String?, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link!) else { return }
        downloadFromUrl(url: url, contentMode: mode)
    }
    
}
