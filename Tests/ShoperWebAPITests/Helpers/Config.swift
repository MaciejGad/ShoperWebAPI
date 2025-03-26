import Foundation
@testable import ShoperWebAPI

func makeClient() -> Client {
    
    let environment = Environment(password: "please-dont-use-this-password", username: "webapi", shopURL: URL(string: "https://sklep_nie_istnieje.shoparena.pl")!, session: mockUrlSession())
    
    let config = Config(shopURL: environment.shopURL, login: environment.username, password: environment.password, verbose: true)
    return Client(config: config, session: environment.session)
}
