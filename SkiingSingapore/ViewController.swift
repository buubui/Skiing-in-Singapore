//
//  ViewController.swift
//  SkiingSingapore
//
//  Created by Buu Bui on 5/13/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import Cocoa

func runInMainThread(completion: (() -> Void)) {
  dispatch_async(dispatch_get_main_queue()) {
    completion()
  }
}

class ViewController: NSViewController {
  @IBOutlet weak var resultLabel: NSTextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    performSelectorInBackground(#selector(ViewController.calc), withObject: nil)
  }

  func calc() {
    runInMainThread {
      self.resultLabel.stringValue = "Reading file..."
    }
    let bundle = NSBundle.mainBundle()
    let filePath = bundle.pathForResource("map", ofType: "txt")

    let content = try! String(contentsOfFile: filePath!)
    let lines = content.componentsSeparatedByString("\n")
    let config = lines.first!.componentsSeparatedByString(" ").map { Int($0)! }
    let nx = config.first!
    let ny = config.last!
    var items = [[Int]]()

    for line in lines[1...nx] {
      items.append(line.componentsSeparatedByString(" ").map { Int($0)! })
    }

    let service = SkiingSingapore(nx: nx, ny: ny, items: items)
    runInMainThread {
      self.resultLabel.stringValue = "Calculating..."
    }

    let path = service.calc()
    let values = path.map{String(service.valueOf($0))}
    var text = "The longest path is:\n".stringByAppendingString(values.joinWithSeparator(" - "))
    text.appendContentsOf("\n Drop = \(service.dropValue(path: path)) \n Length = \(path.count)")
    runInMainThread {
      self.resultLabel.hidden = false
      self.resultLabel.stringValue = text
    }
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

