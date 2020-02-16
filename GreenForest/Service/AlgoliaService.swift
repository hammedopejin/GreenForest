//
//  AlgoliaService.swift
//  GreenForest
//
//  Created by Hammed opejin on 2/16/20.
//  Copyright © 2020 Hammed opejin. All rights reserved.
//

import Foundation
import InstantSearchClient

class AlgoliaService {
    
    static let shared = AlgoliaService()
    
    let client = Client(appID: Algolia.kALGOLIA_APP_ID, apiKey: Algolia.kALGOLIA_ADMIN_KEY)
    let index = Client(appID: Algolia.kALGOLIA_APP_ID, apiKey: Algolia.kALGOLIA_ADMIN_KEY).index(withName: "item_Name")
    
    private init() {}
}
