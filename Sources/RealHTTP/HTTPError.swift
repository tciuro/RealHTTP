//
//  IndomioHTTP
//
//  Created by the Mobile Team @ ImmobiliareLabs
//  Email: mobile@immobiliare.it
//  Web: http://labs.immobiliare.it
//
//  Copyright ©2021 Immobiliare.it SpA. All rights reserved.
//  Licensed under MIT License.
//

import Foundation

// MARK: - HTTPError

public struct HTTPError: LocalizedError {
    
    /// HTTP Status Code if available.
    public let statusCode: HTTPStatusCode
    
    /// Cocoa related code.
    public var cocoaCode: Int?
    
    /// Long description of the error.
    public let error: Error?
    
    /// Category of the error.
    public let type: ErrorType
    
    /// Additional user info.
    public var userInfo: [String: Any]?
    
    /// Custom error message.
    public let message: String?
    
    // MARK: - Initialization
        
    public init(_ type: ErrorType,
                code: HTTPStatusCode = .none,
                error: Error? = nil,
                userInfo: [String: Any]? = nil,
                cocoaCode: Int? = nil) {
        self.type = type
        self.statusCode = code
        self.error = error
        self.userInfo = userInfo
        self.cocoaCode = cocoaCode
        self.message = nil
    }
    
    public init(_ type: ErrorType, message: String) {
        self.type = type
        self.message = message
        self.statusCode = .none
        self.cocoaCode = nil
        self.error = nil
    }
    
    // MARK: - Public Properties
    
    public var errorDescription: String? {
        return (message ?? error?.localizedDescription)
    }
    
    /// Return `true` if error is related to a missing connectivity.
    public var isConnectivityError: Bool {
        cocoaCode == -1009
    }
    
    /// Return `true` if error is about a missing authorization.
    public var isNotAuthorized: Bool {
        statusCode == .unauthorized
    }
    
}

// MARK: - ErrorType

public extension HTTPError {
    
    /// Typology of errors:
    /// - `invalidURL`: invalid URL provided, request cannot be executed
    /// - `multipartInvalidFile`: multipart form, invalid file has been set (not found or permissions error)
    /// - `multipartFailedStringEncoding`: failed to encode multipart form
    /// - `jsonEncodingFailed`: encoding in JSON failed
    /// - `urlEncodingFailed`: encoding in URL failed
    /// - `network`: network related error
    /// - `missingConnection`: connection cannot be established
    /// - `invalidResponse`: invalid response received
    /// - `failedBuildingURLRequest`: failed to build URLRequest (wrong parameters)
    /// - `objectDecodeFailed`: object decoding failed
    /// - `emptyResponse`: empty response received from server
    /// - `maxRetryAttemptsReached`: the maximum number of retries for request has been reached
    /// - `maxRetryAltRequestReached`: the maximum number of alternate request for this session has been reached
    /// - `sessionError`: error related to the used session instances (may be a systemic error or it was invalidated)
    /// - `other`: any internal error, you can use it as your own handler.
    /// - `cancelled`: cancelled by user.
    enum ErrorType {
        case invalidURL(URLConvertible)
        case multipartInvalidFile(URL)
        case multipartFailedStringEncoding
        case multipartStreamReadFailed
        case jsonEncodingFailed
        case urlEncodingFailed
        case network
        case missingConnection
        case invalidResponse
        case failedBuildingURLRequest
        case objectDecodeFailed
        case emptyResponse
        case maxRetryAttemptsReached
        case maxRetryAltRequestReached
        case sessionError
        case other
        case cancelled
    }
    
}

// MARK: - HTTPError (URLResponse)

extension HTTPError {
    
    /// Parse the response of an HTTP operation and return `nil` if no error has found,
    /// a valid `HTTPError` if call has failed.
    ///
    /// - Parameter httpResponse: response from http layer.
    /// - Returns: HTTPError?
    public static func fromURLResponse(_ response: URLSessionResponse) -> HTTPError? {
        // If HTTP is an error or an error has received we can create the error object
        let httpCode = HTTPStatusCode(URLResponse: response.urlResponse) ?? .none
        let isError = (response.error != nil || httpCode.responseType != .success)
        
        guard isError else {
            return nil
        }
        
        // Evaluate error kind
        let cocoaErrorCode = (response.error as NSError?)?.code
        let userInfo = (response.error as NSError?)?.userInfo
        let isConnectionError = response.error?.isMissingConnection ?? false
        let errorType: HTTPError.ErrorType = (isConnectionError ? .missingConnection : .network)
        
        return HTTPError(errorType,
                         code: httpCode,
                         error: response.error,
                         userInfo: userInfo,
                         cocoaCode: cocoaErrorCode)
    }
    
}
