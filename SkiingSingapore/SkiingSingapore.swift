//
//  SkiingSingapore.swift
//  SkiingSingapore
//
//  Created by Buu Bui on 5/13/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

class SkiingSingapore {
  let nx: Int
  let ny:Int
  let items: [[Int]]

  init(nx: Int, ny: Int, items: [[Int]]) {
    self.nx = nx
    self.ny = ny
    self.items = items
  }

  func valueOf(point: (x: Int, y: Int)) -> Int {
    return items[point.x][point.y]
  }

  func nextPoints(x x: Int,y: Int) -> [(x: Int, y: Int)] {
    var points = [(x: Int, y: Int)]()
    if x - 1 >= 0 && valueOf((x: x, y: y)) > valueOf((x: x - 1, y: y)) {
      points.append((x: x - 1, y: y))
    }

    if y - 1 >= 0 {
      if valueOf((x: x, y: y)) > valueOf((x: x, y: y - 1)) {
        points.append((x: x, y: y - 1))
      }
    }

    if x + 1 < nx && valueOf((x: x, y: y)) > valueOf((x: x + 1, y: y)) {
      points.append((x: x + 1, y: y))
    }

    if y + 1 < ny && valueOf((x: x, y: y)) > valueOf((x: x, y: y + 1)) {
      points.append((x: x, y: y + 1))
    }

    return points
  }

  func getPath(x x: Int,y: Int) -> [[(x: Int, y: Int)]] {
    var paths = [[(x: x, y: y)]]
    var next = true
    while next {
      next = false
      let copyPaths = paths
      for path in copyPaths {
        paths.removeFirst()
        let point = path.last!
        let newPoints = nextPoints(x: point.x, y: point.y)
        if newPoints.isEmpty {
          paths.append(path)
          continue
        }
        next = true
        paths.appendContentsOf( newPoints.map {
          var newPath = path
          newPath.append($0)
          return newPath
          } )
      }
    }
    return paths
  }

  func calc() -> [(x: Int, y: Int)]{
    var paths = [[(x: Int, y: Int)]]()

    for x in 0..<nx {
      for y in 0..<ny {
        if let path = longestPath(getPath(x: x, y: y)) {
          paths.append(path)
        }
      }
    }

    let path = longestPath(paths)!
    return path
  }

  func dropValue(path path: [(x: Int, y: Int)]) -> Int {
    return valueOf(path.first!) - valueOf(path.last!)
  }

  func longestPath(paths: [[(x: Int, y: Int)]]) -> [(x: Int, y: Int)]? {
    var longestPath: [(x: Int, y: Int)]?
    for path in paths {
      if let _ = longestPath {
        if path.count > longestPath?.count {
          longestPath = path
        } else if path.count > 0 && path.count == longestPath?.count {
          let dropValue1 = dropValue(path: path)
          let dropValue2 = dropValue(path: longestPath!)
          if dropValue1 > dropValue2 {
            longestPath = path
          }
        }
      } else {
        longestPath = path
      }
    }
    return longestPath
  }  
}
