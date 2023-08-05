//
//  Location.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/8/23.
//

import CoreLocation
import Foundation

public class LocationUtil: NSObject, CLLocationManagerDelegate {

  static let instance = LocationUtil()

  typealias Point = (latitude: Double, longitude: Double)
  let manager = CLLocationManager()

  public override init() {
    super.init()
    manager.delegate = self
  }

  private var pc: CheckedContinuation<Bool, Error>?
  func requestPermission(inApp: Bool = true) async throws -> Bool {
    return try await withCheckedThrowingContinuation { c in
      if inApp {
        if manager.authorizationStatus == .authorizedWhenInUse
          || manager.authorizationStatus == .authorizedAlways
        {
          print("have permission")
          c.resume(returning: true)
        } else {
          print("Request permission")
          self.pc = c
          publish {
            self.manager.requestWhenInUseAuthorization()
          }
        }
      } else {
        if manager.authorizationStatus == .authorizedAlways {
          print("Have alwayss permission")
          c.resume(returning: true)
        } else {
          self.pc = c
          publish {
            self.manager.requestAlwaysAuthorization()
          }
        }
      }
    }
  }

  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let permission =
      manager.authorizationStatus == .authorizedWhenInUse
      || manager.authorizationStatus == .authorizedAlways
    pc?.resume(
      returning: permission)
    print("Got permission", permission, "passed to pc", pc != nil)
    pc = nil
  }

  public static func requestPermission(inApp: Bool = true) async throws -> Bool {
    return try await instance.requestPermission(inApp: inApp)
  }

  private var c: CheckedContinuation<Point, Error>? = nil

  func fetch() async throws -> Point {
    if try await requestPermission() {
      print("Have permission")
      return try await withCheckedThrowingContinuation { c in
        self.c = c
        publish {
          print("request location")
          self.manager.startUpdatingLocation()
        }
      }
    } else {
      print("no permission")
      throw APIError.e("No permission")
    }
  }

  public func locationManager(
    _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
  ) {
    print("received locations", locations)
    if let loc = locations.first {
      c?.resume(returning: (latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude))
    } else {
      c?.resume(throwing: APIError(msg: "No location received", critical: false))
    }
    manager.stopUpdatingLocation()
    c = nil
  }

  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("location fail with error", error)
    c?.resume(throwing: error)
    c = nil
    pc?.resume(throwing: error)
    pc = nil
  }

  public static func fetch() async throws -> (latitude: Double, longitude: Double) {
    print("Getting location")
    return try await instance.fetch()
  }
}
