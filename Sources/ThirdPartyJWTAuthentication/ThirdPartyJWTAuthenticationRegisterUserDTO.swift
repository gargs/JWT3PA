import Vapor

public protocol ThirdPartyJWTAuthenticationRegisterUserDTO: Content {
    var name: String? { get set }
}
