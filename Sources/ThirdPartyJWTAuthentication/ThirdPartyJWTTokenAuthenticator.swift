import Vapor
import Fluent

final public class ThirdPartyJWTTokenAuthenticator<T>: BearerAuthenticator where T: ThirdPartyJWTUserAuthenticationToken {
    public typealias User = T.User
    
    public func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<T.User?> {
        let db = request.db

        return T.query(on: db)
            .filter(\._$value == bearer.token)
            .first()
            .flatMap { token -> EventLoopFuture<T.User?> in
                guard let token = token else {
                    return request.eventLoop.makeSucceededFuture(nil)
                }

                return token._$user.get(on: db).map { $0 }
        }
    }

    public static func guardMiddleware(app: Application) -> RoutesBuilder {
        return app.grouped(ThirdPartyJWTTokenAuthenticator<T>().middleware())
            .grouped(T.User.guardMiddleware())
    }
}


