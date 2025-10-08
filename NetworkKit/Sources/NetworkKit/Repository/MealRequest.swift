//
//  MealRequest.swift
//  NetworkKit
//
//  Created by Ali FAKIH on 10/8/25.
//


import Foundation

enum MealRequest{
    case searchMealByName(String)
    case lookupFullMealDetailsById(String)
    case listAllMealCategories
    case filterByCategory(String)
}

extension MealRequest: APIRequest {

    var path: String {
        switch self {
        case .searchMealByName: return "/search.php"
        case .lookupFullMealDetailsById: return "/lookup.php"
        case .listAllMealCategories: return "categories.php"
        case .filterByCategory: return "filter.php"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .searchMealByName: return .get
        case .lookupFullMealDetailsById: return .get
        case .listAllMealCategories: return .get
        case .filterByCategory: return .get
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchMealByName(let search):
            return [URLQueryItem(name: "s", value: search)]
        case .lookupFullMealDetailsById(let id):
            return [URLQueryItem(name: "i", value: id)]
        case .listAllMealCategories:
            return []
        case .filterByCategory(let category):
            return [URLQueryItem(name: "c", value: category)]
        }
    }
}
