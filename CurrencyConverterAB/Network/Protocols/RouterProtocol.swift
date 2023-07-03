//
//  RouterProtocol.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation

protocol RouterProtocol {
    var url: URL { get }
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    var headers: [String: String]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum Task {

    /// A request with no additional data.
    case requestPlain

    /// A requests body set with data.
    case requestData(Data)

    /// A request body set with `Encodable` type
    case requestJSONEncodable(Encodable)

    /// A request body set with `Encodable` type and custom encoder
    case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)

    /// A requests body set with data, combined with url parameters.
    case requestCompositeData(bodyData: Data, urlParameters: [String: Any])
}
