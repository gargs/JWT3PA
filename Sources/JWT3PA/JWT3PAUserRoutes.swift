import Vapor
import Fluent
import JWT

public class JWT3PAUserRoutes<T> where T: JWT3PAUser {
    func appleLogin(req: Request) throws -> EventLoopFuture<String> {
        req.jwt.apple.verify().flatMap { (token: AppleIdentityToken) in
            T.apiTokenForUser(filter: \._$apple == token.subject.value, req: req)
        }
    }

    func googleLogin(req: Request) throws -> EventLoopFuture<String> {
        req.jwt.google.verify().flatMap { (token: GoogleIdentityToken) in
            T.apiTokenForUser(filter: \._$google == token.subject.value, req: req)
        }
    }

    func appleRegister(req: Request) throws -> EventLoopFuture<String> {
        return req.jwt.apple.verify().flatMap { (token: AppleIdentityToken) in
            T.createUserAndToken(req: req, email: token.email, vendor: .apple, subject: token.subject)
        }
    }

    func bob(req: Request) throws -> EventLoopFuture<String> {
        T.apiTokenForUser(filter: \._$apple == "000685.e20f8c18643842e092f21efbbbc92483.1825", req: req)
    }

    func googleRegister(req: Request) throws -> EventLoopFuture<String> {
        return req.jwt.google.verify().flatMap { (token: GoogleIdentityToken) in
            T.createUserAndToken(req: req, email: token.email, vendor: .google, subject: token.subject)
        }
    }

    public static func register(routeGroup: RoutesBuilder, protected: RoutesBuilder) {
        let me = JWT3PAUserRoutes<T>()

        routeGroup.post("register", "apple", use: me.appleRegister)
        routeGroup.post("register", "google", use: me.googleRegister)
        routeGroup.get("bob", use: me.bob)
        
        let login = protected.grouped("login")
        login.post("apple", use: me.appleLogin)
        login.post("google", use: me.googleLogin)
    }

    public static func register(app: Application, protected: RoutesBuilder) {
        let me = JWT3PAUserRoutes<T>()

        app.post("register", "apple", use: me.appleRegister)
        app.post("register", "google", use: me.googleRegister)
        app.get("bob", use: me.bob)
        
        let login = protected.grouped("login")
        login.post("apple", use: me.appleLogin)
        login.post("google", use: me.googleLogin)
    }

    private init() {}
}
