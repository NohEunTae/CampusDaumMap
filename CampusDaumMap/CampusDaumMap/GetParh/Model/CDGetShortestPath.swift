//
//  CDGetShortestPath.swift
//  CampusDaumMap
//
//  Created by user on 2018. 10. 5..
//  Copyright © 2018년 user. All rights reserved.
//

import Foundation

public enum pathType {
    case walk
    case wheelChair
}

public class Node {
    var visited = false
    var connections: [Connect] = [Connect]()
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public class Path {
    public let cumulativeWeight: Double
    public let node: Node
    public let previousPath: Path?
    
    init(to node: Node, via connection: Connect? = nil, previousPath path: Path? = nil) {
        if  let previousPath = path, let viaConnection = connection {
            self.cumulativeWeight = viaConnection.weight + previousPath.cumulativeWeight
        } else {
            self.cumulativeWeight = 0
        }
        
        self.node = node
        self.previousPath = path
    }
}

extension Path {
    var array: [Node] {
        var array: [Node] = [self.node]
        
        var iterativePath = self
        while let path = iterativePath.previousPath {
            array.append(path.node)
            
            iterativePath = path
        }
        
        return array
    }
}

class Connect {
    public let to: Node
    public let weight: Double
    
    public init(to node: Node, weight: Double) {
        assert(weight >= 0, "weight has to be equal or greater than zero")
        self.to = node
        self.weight = weight
    }
}

func shortestPath(source: Node, destination: Node) -> Path? {
    var frontier: [Path] = [] {
        didSet { frontier.sort { $0.cumulativeWeight < $1.cumulativeWeight } } // the frontier has to be always ordered
    }
    
    frontier.append(Path(to: source)) // the frontier is made by a path that starts nowhere and ends in the source
    
    while !frontier.isEmpty {
        let cheapestPathInFrontier = frontier.removeFirst() // getting the cheapest path available
        guard !cheapestPathInFrontier.node.visited else { continue } // making sure we haven't visited the node already
        
        if cheapestPathInFrontier.node === destination {
            return cheapestPathInFrontier // found the cheapest path 😎
        }
        
        cheapestPathInFrontier.node.visited = true
        for connection in cheapestPathInFrontier.node.connections where !connection.to.visited { // adding new paths to our frontier
            frontier.append(Path(to: connection.to, via: connection, previousPath: cheapestPathInFrontier))
        }
    } // end while
    return nil // we didn't find a path 😣
}

public func getShortestPathWithGraph(from: Node, to: Node, type: pathType) -> Path? {
    let gpsInfos = CDCoreDataManager.store.selectAllCoreDataObjectFromGPSInfo()
    var nodes = [Node]()
    for gpsInfo in gpsInfos {
        let node: Node = Node(latitude: gpsInfo.latitude, longitude: gpsInfo.longitude)
        nodes.append(node)
    }
    
    let connections = CDCoreDataManager.store.selectAllCoreDataObjectFromConnection()
    for connection in connections {
        let from = nodes.filter { $0.latitude == connection.fromGPS?.latitude && $0.longitude == connection.fromGPS?.longitude }.first!
        let to = nodes.filter { $0.latitude == connection.nextGPS?.latitude && $0.longitude == connection.nextGPS?.longitude }.first!
        
        switch type {
        case .walk:
            from.connections.append(Connect(to: to, weight: calDistance(from: from, to: to)))
            to.connections.append(Connect(to: from, weight: calDistance(from: from, to: to)))
            break
        case .wheelChair:
            from.connections.append(Connect(to: to, weight: connection.weight * calDistance(from: from, to: to)))
            to.connections.append(Connect(to: from, weight: connection.weight * calDistance(from: from, to: to)))
            break
        }
    }
    
    let fromNode = nodes.filter { $0.latitude == from.latitude && $0.longitude == from.longitude }.first!
    let toNode = nodes.filter { $0.latitude == to.latitude && $0.longitude == to.longitude }.first!

    let path = shortestPath(source: fromNode, destination: toNode)
    return path
}

private func calDistance(from: Node, to: Node) -> Double {
    func deg2rad(deg: Double) -> Double {
        return (deg * Double.pi / 180.0)
    }
    
    func rad2deg(rad: Double) -> Double {
        return (rad * 180.0 / Double.pi)
    }
    
    var theta :Double, dist: Double
    theta = from.longitude - to.longitude
    dist = sin(deg2rad(deg: from.latitude)) * sin(deg2rad(deg: to.latitude)) + cos(deg2rad(deg: from.latitude)) * cos(deg2rad(deg: to.latitude)) * cos(deg2rad(deg: theta))
    dist = acos(dist)
    dist = rad2deg(rad: dist)
    dist *= 60 * 1.1515
    dist *= 1.609344
    dist *= 1000.0
    
    return dist
}
