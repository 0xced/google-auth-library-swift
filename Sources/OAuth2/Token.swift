// Copyright 2019 Google LLC. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import Foundation

public struct Token : Codable {
  public var AccessToken : String
  public var TokenType : String
  public var ExpiresIn : Int?
  public var RefreshToken : String?
  public var Scope : String?
  public var CreationTime : Date? = Date()
  enum CodingKeys: String, CodingKey {
    case AccessToken = "access_token"
    case TokenType = "token_type"
    case ExpiresIn = "expires_in"
    case RefreshToken = "refresh_token"
    case Scope = "scope"
    case CreationTime = "creation_time"
  }
  
  func save(_ filename: String) throws {
    let encoder = JSONEncoder()
    let data = try encoder.encode(self)
    try data.write(to: URL(fileURLWithPath: filename))
  }
  
  public init(accessToken: String, tokenType: String, expiresIn: Int?, refreshToken: String?, scope: String?) {
    self.AccessToken = accessToken
    self.TokenType = tokenType
    self.ExpiresIn = expiresIn
    self.RefreshToken = refreshToken
    self.Scope = scope
  }
  
  public init(queryItems: [URLQueryItem]) throws {
    guard let accessToken = queryItems.filter({ $0.name == CodingKeys.AccessToken.rawValue }).first?.value else {
      throw AuthError.unknownError
    }
    guard let tokenType = queryItems.filter({ $0.name == CodingKeys.TokenType.rawValue }).first?.value else {
      throw AuthError.unknownError
    }
    let expiresInString = queryItems.filter({ $0.name == CodingKeys.ExpiresIn.rawValue }).first?.value
    let expiresIn = expiresInString != nil ? Int(expiresInString!) : nil
    let refreshToken = queryItems.filter({ $0.name == CodingKeys.RefreshToken.rawValue }).first?.value
    let scope = queryItems.filter({ $0.name == CodingKeys.Scope.rawValue }).first?.value
    self.init(accessToken: accessToken, tokenType: tokenType, expiresIn: expiresIn, refreshToken: refreshToken, scope: scope)
  }
}
