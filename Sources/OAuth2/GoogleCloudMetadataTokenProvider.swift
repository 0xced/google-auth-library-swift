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

import Dispatch
import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public class GoogleCloudMetadataTokenProvider : TokenProvider {
  
  public var token: Token?
  
  public func withToken(_ callback: @escaping (Result<Token, Error>) -> Void) {
    let urlString = "http://metadata/computeMetadata/v1/instance/service-accounts/default/token"
    let urlComponents = URLComponents(string:urlString)!
    var request = URLRequest(url: urlComponents.url!)
    request.setValue("Google", forHTTPHeaderField:"Metadata-Flavor")
    request.httpMethod = "GET"
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let task: URLSessionDataTask = session.dataTask(with:request) {
      (data, response, error) -> Void in
      callback(Result(catching: {
        if let data = data {
          let decoder = JSONDecoder()
          let token = try decoder.decode(Token.self, from: data)
          self.token = token
          return token
        } else {
          throw error!
        }
      }))
    }
    task.resume()
  }
}
