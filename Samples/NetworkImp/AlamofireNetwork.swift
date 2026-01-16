import Alamofire
import Combine
import Foundation

public final class AccessTokenInterceptor: RequestAdapter {
  private let accessToken: String

  public init(accessToken: String) {
    self.accessToken = accessToken
  }

  public func adapt(
    _ urlRequest: URLRequest,
    for session: Session,
    completion: @escaping (Result<URLRequest, Error>) -> Void
  ) {
    var urlRequest = urlRequest
    urlRequest.headers.add(.authorization(bearerToken: accessToken))

    completion(.success(urlRequest))
  }
}

enum Router: URLRequestConvertible {
  case get([String: String])
  case post([String: String])

  var baseURL: URL {
    return URL(string: "https://httpbin.org")!
  }

  var method: HTTPMethod {
    switch self {
    case .get:
      return .get
    case .post:
      return .post
    }
  }

  var path: String {
    switch self {
    case .get:
      return "get"
    case .post:
      return "post"
    }
  }

  func asURLRequest() throws -> URLRequest {
    let url = baseURL.appendingPathComponent(path)
    var request = URLRequest(url: url)
    request.method = method

    switch self {
    case let .get(parameters):
      request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
    case let .post(parameters):
      request = try JSONParameterEncoder().encode(parameters, into: request)
    }

    return request
  }
}

public final class AlamofireNetwork {
  private let session: Session

  public init(accessToken: String) {
    let interceptor = AccessTokenInterceptor(accessToken: accessToken)
    self.session = Session(interceptor: interceptor)
  }

  public func send<T: Decodable>(_ router: Router, responseType: T.Type) -> AnyPublisher<Response<T>, Error> {
    Future { [session] promise in
      session
        .request(router)
        .validate()
        .responseDecodable(of: T.self) { response in
          switch response.result {
          case let .success(output):
            let statusCode = response.response?.statusCode ?? 0
            promise(.success(Response(output: output, statusCode: statusCode)))
          case let .failure(error):
            promise(.failure(error))
          }
        }
    }
    .eraseToAnyPublisher()
  }
}
