import Foundation
import CoreLocation

protocol LocationServiceProtocol: Sendable {
    func requestCurrentLocation() async throws -> CLLocation
    func reverseGeocode(_ location: CLLocation) async throws -> String
}
