import Foundation

/// Represents the result of a GraphQL operation.
public struct GraphQLResult<Data> {
    
    /// The typed result data, or `nil` if an error was encountered that prevented a valid response.
    public let data: Data?
    /// A list of errors, or `nil` if the operation completed without encountering any errors.
    public let errors: [GraphQLError]?
    /// A dictionary which services can use however they see fit to provide additional information to clients.
    public let extensions: [String: Any]?
    
    /// Represents source of data
    public enum Source {
        case cache
        case server
    }
    /// Source of data
    public let source: Source
    
    let dependentKeys: Set<CacheKey>?
    
    public init(data: Data?,
                extensions: [String: Any]?,
                errors: [GraphQLError]?,
                source: Source,
                dependentKeys: Set<CacheKey>?) {
        self.data = data
        self.extensions = extensions
        let filtredErrors = errors?.filter({ error in
            if let name = error["name"] as? String {
                if name == "AccessDeniedError" {
                    return false
                }
            }
            return true
        }) ?? []
        self.errors = filtredErrors.count > 0 ? filtredErrors : nil
        self.source = source
        self.dependentKeys = dependentKeys
    }
}
