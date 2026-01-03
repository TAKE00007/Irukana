import Foundation

protocol UserRepository {
    func fetchUser(id: UUID) async throws -> User?
}
