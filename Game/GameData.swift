
import Combine
import Foundation

class GameData: ObservableObject {
  private var goalCount = 0

  @Published var objectCount = 0
  @Published var gameStart = false
  @Published var gameOVer = false
  @Published var startSpawning = false
  @Published var highScore = 0
  
  @Published private(set) var successBadge: Int?
  private var shouldEvaluateResult = true

//    func compute(position: [CGPoint]) {
//        var tempo = 0
//        for i in 1..<position.count {
//            if (position[i].y - position[0].y > 20) {
//                tempo += 1
//                print(position[i].y - position[0].y > 20)
//            }
//        }
//        objectCount = tempo
//    }
    
  func start() {
    startSpawning = true
    gameStart = true
  }

  func didSpawn(count: Int) {
    goalCount = count
  }
    
    func setObjectsCount(_ count:Int){
        self.objectCount = count
        
//        print(objectCount)
//        print("CCC")
    }

    func setObjectsCount2(count:Int){
        print()
//        self.objectCount = count
//        print(objectCount)
//        print("bbb")
    }

    
  func checkObjectsCount(_ count: Int) {
//    if !shouldEvaluateResult {
//      return
//    }
//    if count == goalCount {
//      shouldEvaluateResult = false
//      successBadge = count
//
//      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//        self.successBadge = nil
//        self.startSpawning = true
//        self.shouldEvaluateResult = true
//          print("restarting")
//      }
//    }
  }
}
