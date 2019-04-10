//
//  SearchableRecord.swift
//  Continuum25
//
//  Created by Hannah Hoff on 4/10/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
