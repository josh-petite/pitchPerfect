//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Josh Petite on 5/13/15.
//  Copyright (c) 2015 Josh Petite. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    private var filePathUrl: NSURL!
    private var title: String!
    
    init(url: NSURL, title: String) {
        filePathUrl = url
        self.title = title
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getUrl() -> NSURL {
        return filePathUrl
    }
}
