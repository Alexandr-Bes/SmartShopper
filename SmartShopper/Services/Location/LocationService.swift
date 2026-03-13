import Foundation

protocol LocationServiceProtocol {
    func requestPermissionIfNeeded()
    func start()
    func stop()
    func nearestStore(from stores: [GroceryStore]) -> GroceryStore?
}

final class LocationService: LocationServiceProtocol {
    func requestPermissionIfNeeded() {
        // TODO: Integrate CLLocationManager authorization flow.
    }

    func start() {
        // TODO: Start location updates.
    }

    func stop() {
        // TODO: Stop location updates.
    }

    func nearestStore(from stores: [GroceryStore]) -> GroceryStore? {
        // TODO: Return nearest store based on stored coordinates.
        stores.first
    }
}
