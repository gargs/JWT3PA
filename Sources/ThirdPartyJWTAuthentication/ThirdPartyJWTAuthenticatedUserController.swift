import Vapor
import Fluent
import JWT

open class ThirdPartyJWTAuthenticatedUserController<T> where T: ThirdPartyJWTAuthenticatedUser {
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

    public func registerJWTAuthenticationRoutes(app: Application, protected: RoutesBuilder) {
        app.post("register", "apple", use: self.appleRegister)
        app.post("register", "google", use: self.googleRegister)
        app.get("bob", use: self.bob)
        
        let login = protected.grouped("login")
        login.post("apple", use: self.appleLogin)
        login.post("google", use: self.googleLogin)
    }

    public init() {}
}
