import Alamofire
import Foundation

public struct AmiiboAPI {
    /// The base AmiiboAPI URL.
    private static let baseURL = "https://amiiboapi.com/api"
    
    // MARK: Amiibo
    
    /// Fetch a list of amiibos.
    ///
    /// - Parameters:
    ///   - head: Filter by first 8 hexadecimal characters in the ID. Example: `00000000`, `01010000`
    ///   - tail: Filter by last 8 hexadecimal characters in the ID. Example: `00410302`, `03560902`
    ///   - name: Filter by name. Example: `Green Yarn Yoshi`
    ///   - type: Filter by type. Example: `0x02`, `yarn`
    ///   - character: Filter by character. Example: `0x1996`, `Mewtwo`
    ///   - gameSeries: Filter by game series. Example: `0x22c`, `Chibi Robo`
    ///   - amiiboSeries: Filter by series. Example: `0x10`, `BoxBoy!`
    ///   - showGames: Includes the games the amiibo can be used in.
    ///   - showUsage: Includes the games the amiibo can be used in and how it is used.
    ///
    /// - Returns: A list of amiibo which fit the filter criteria.
    public static func amiibo(
        head: String? = nil,
        tail: String? = nil,
        name: String? = nil,
        type: String? = nil,
        character: String? = nil,
        gameSeries: String? = nil,
        amiiboSeries: String? = nil,
        showGames: Bool = false,
        showUsage: Bool = false
    ) async -> Result<[Amiibo], Error> {
        var error: Error? = nil
        if (head != nil && head?.count != 8) {
            error = Self.createError(code: 1, message: "'head' must be the first 8 hexadecimal characters of the amiibo ID.")
        }
        if (tail != nil && tail?.count != 8) {
            error = Self.createError(code: 2, message: "'tail' must be the last 8 hexadecimal characters of the amiibo ID.")
        }
        if let error = error { return .failure(error) }
        
        let args = [
            "head": head,
            "tail": tail,
            "name": name,
            "type": type,
            "character": character,
            "gameseries": gameSeries,
            "amiiboSeries": amiiboSeries,
        ]
            .filter { $0.value != nil }
            .map { "\($0.key)=\($0.value!)" }
            .joined(separator: "&")
            .append(if: showGames, "&showgames")
            .append(if: showUsage, "&showusage")
        
        return await fetchList(endpoint: "/amiibo/?\(args)")
    }
    
    /// Fetch a single amiibo by it's 16 character hexidecimal ID.
    ///
    /// Note: This does not support fetching games or usages due to API limitations.
    ///
    /// - Parameter id: The 16 character hexademical amiibo ID.
    ///
    /// - Returns: The amiibo with a matching ID.
    public static func amiibo(byID id: String) async -> Result<Optional<Amiibo>, Error> {
        if (id.count != 16) {
            return .failure(Self.createError(code: 3, message: "'id' must be the 16 character hexadecimal amiibo ID."))
        }
        
        return await fetch(endpoint: "/amiibo/?id=\(id)")
    }
    
    
    // MARK: Amiibo Type
    
    /// Fetch a list of all amiibo types.
    ///
    /// - Returns: A list of all amiibo types.
    public static func types() async -> Result<[AmiiboType], Error> {
        await fetchList(endpoint: "/type")
    }
    
    /// Fetch a single amiibo type by it's key.
    ///
    /// - Parameter key: The amiibo type's key.
    ///
    /// - Returns: The amiibo type with a matching key.
    public static func type(byKey key: String) async -> Result<Optional<AmiiboType>, Error> {
        await fetch(endpoint: "/type?key=\(key)")
    }
    
    /// Fetch a list of amiibo types by their name.
    ///
    /// - Parameter name: The amiibo type's name.
    ///
    /// - Returns: The amiibo types with matching names.
    public static func types(byName name: String) async -> Result<[AmiiboType], Error> {
        await fetchList(endpoint: "/type?name=\(name)")
    }
    
    
    // MARK: Amiibo Game Series
    
    /// Fetch a list of all amiibo game series.
    ///
    /// - Returns: A list of all amiibo games series.
    public static func gameSeries() async -> Result<[AmiiboGameSeries], Error> {
        await fetchList(endpoint: "/gameseries")
    }
    
    /// Fetch a single amiibo game series by it's key.
    ///
    /// - Parameter key: The amiibo game series' key.
    ///
    /// - Returns: The amiibo game series with a matching key.
    public static func gameSeries(byKey key: String) async -> Result<Optional<AmiiboGameSeries>, Error> {
        await fetch(endpoint: "/gameseries?key=\(key)")
    }
    
    /// Fetch a list of amiibo game series by their name.
    ///
    /// - Parameter name: The amiibo game series' name.
    ///
    /// - Returns: The amiibo game series with matching names.
    public static func gameSeries(byName name: String) async -> Result<[AmiiboGameSeries], Error> {
        await fetchList(endpoint: "/gameseries?name=\(name)")
    }
    
    
    // MARK: Amiibo Series
    
    /// Fetch a list of all amiibo series.
    ///
    /// - Returns: A list of all amiibo series.
    public static func series() async -> Result<[AmiiboSeries], Error> {
        await fetchList(endpoint: "/amiiboseries")
    }
    
    /// Fetch a single amiibo series by it's key.
    ///
    /// - Parameter key: The amiibo series' key.
    ///
    /// - Returns: The amiibo series with a matching key.
    public static func series(byKey key: String) async -> Result<Optional<AmiiboSeries>, Error> {
        await fetch(endpoint: "/amiiboseries?key=\(key)")
    }
    
    /// Fetch a list of amiibo series by their name.
    ///
    /// - Parameter name: The amiibo series' name.
    ///
    /// - Returns: The amiibo series with matching names.
    public static func series(byName name: String) async -> Result<[AmiiboSeries], Error> {
        await fetchList(endpoint: "/amiiboseries?name=\(name)")
    }
    
    
    // MARK: Amiibo Character
    
    /// Fetch a list of all amiibo characters.
    ///
    /// - Returns: A list of all amiibo characters.
    public static func characters() async -> Result<[AmiiboCharacter], Error> {
        await fetchList(endpoint: "/character")
    }
    
    /// Fetch a single amiibo character by it's key.
    ///
    /// - Parameter key: The amiibo character's key.
    ///
    /// - Returns: The amiibo character with a matching key.
    public static func character(byKey key: String) async -> Result<Optional<AmiiboCharacter>, Error> {
        await fetch(endpoint: "/character?key=\(key)")
    }
    
    /// Fetch a list of amiibo characters by their name.
    ///
    /// - Parameter name: The amiibo character's name.
    ///
    /// - Returns: The amiibo characters with matching names.
    public static func characters(byName name: String) async -> Result<[AmiiboCharacter], Error> {
        await fetchList(endpoint: "/character?name=\(encode(name))")
    }
    
    
    // MARK: Last Updated
    
    /// Fetch the last time the AmiiboAPI database was updated.
    ///
    /// - Returns: The last time the AmiiboAPI database was updated.
    public static func lastUpdated() async -> Result<Date, Error> {
        await fetch(endpoint: "/lastupdated", in: ResponseUpdated.self, parseData: { $0.lastUpdated })
    }
    
    
    // MARK: Helpers
    
    /// Convenience method to fetch a list using the standard `amiibo` response.
    ///
    /// - Parameters:
    ///   - endpoint: The AmiiboAPI endpoint.
    ///   - of: The data type of list.
    ///
    /// - Returns: A parsed API response in the form of a list.
    private static func fetchList<T: Decodable>(endpoint: String, of: T.Type = T.self) async -> Result<[T], Error> {
        await fetch(endpoint: endpoint, in: ResponseAmiibo<[T]>.self, parseData: { $0.amiibo ?? [] })
    }
    
    /// Convenience method to fetch a single object using the standard `amiibo` response.
    ///
    /// - Parameters:
    ///   - endpoint: The AmiiboAPI endpoint.
    ///   - of: The data type of the object.
    ///
    /// - Returns: A parsed API response.
    private static func fetch<T: Decodable>(endpoint: String, of: T.Type = T.self) async -> Result<Optional<T>, Error> {
        await fetch(endpoint: endpoint, in: ResponseAmiibo<T>.self, parseData: { $0.amiibo })
    }
    
    /// Fetch `endpoint` with the JSON format of `in.Type` which is then converted to `out.Type` by passing it through `passData`.
    ///
    /// - Parameters:
    ///   - endpoint: The AmiiboAPI endpoint.
    ///   - in: The API response type.
    ///   - out: The required response type.
    ///   - parseData: Parse `in` to `out`.
    ///
    /// - Returns: The parsed API response.
    private static func fetch<In: Decodable, Out: Decodable>(
        endpoint: String,
        in: In.Type = In.self,
        out: Out.Type = Out.self,
        parseData: @escaping (In) -> Out
    ) async -> Result<Out, Error> {
        guard let encodedEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return .failure(createError(code: 6, message: "Unable to encode API endpoint."))
        }
        
        return await withCheckedContinuation { continuation in
            AF.request(AmiiboAPI.baseURL + encodedEndpoint)
                .responseDecodable(of: In.self) { data in
                    switch(data.result) {
                    case let .success(data):
                        continuation.resume(returning: .success(parseData(data)))
                    case let .failure(error):
                        continuation.resume(returning: .failure(Self.handleError(error: error)))
                    }
                }
        }
    }
    
    /// Convenience method to create an error.
    ///
    /// - Parameters:
    ///   - code: The scoped error code.
    ///   - message: The error message.
    ///
    /// - Returns: An `Error`.
    private static func createError(code: Int, message: String) -> Error {
        NSError(domain: "AmiiboAPI", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    /// Convert an `AFError` into a generic `Error`.
    ///
    /// - Parameter error: The `AFError` to convert.
    ///
    /// - Returns: The converted `Error`.
    private static func handleError(error: AFError) -> Error {
        if let underlyingError = error.underlyingError {
            let nserror = underlyingError as NSError
            let code = nserror.code
            if code == NSURLErrorNotConnectedToInternet ||
               code == NSURLErrorTimedOut ||
               code == NSURLErrorInternationalRoamingOff ||
               code == NSURLErrorDataNotAllowed ||
               code == NSURLErrorCannotFindHost ||
               code == NSURLErrorCannotConnectToHost ||
               code == NSURLErrorNetworkConnectionLost {
                var userInfo = nserror.userInfo
                userInfo[NSLocalizedDescriptionKey] = "Unable to connect to the server"
                
                return NSError(
                    domain: nserror.domain,
                    code: code,
                    userInfo: userInfo
                )
            }
        }
        return error
    }
}
