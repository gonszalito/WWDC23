import Foundation
import SpriteKit
import SwiftUI

protocol GameSceneViewControllerDelegate: AnyObject {
  func didStartSpawning(count: Int)
    
}

protocol FingerCountDelegate {
    func setFinger(fingers: Int)
}


struct GameSceneViewContainer: UIViewControllerRepresentable {
   
    @Binding var startSpawning: Bool
    @Binding var objectCount: Int
    var startGame = false
  var numberOfDucksHandler: (Int) -> Void
  
  class Coordinator: NSObject, GameSceneViewControllerDelegate {
    var parent: GameSceneViewContainer
    
    init(_ parent: GameSceneViewContainer) {
      self.parent = parent
    }
    
    func didStartSpawning(count: Int) {
//        parent.startSpawning = false
//        self.parent.spawnAllowed = false
//      parent.numberOfDucksHandler(count)
    }
      
      func changeState() {
//          parent.startSpawning = false
      }
  }

    func makeUIViewController(context: Context) -> GameSceneViewController {
        let gameScene = GameSceneViewController()
        gameScene.delegate = context.coordinator
        return gameScene
    }
    
    func makeCoordinator() -> Coordinator {
      return Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: GameSceneViewController,context: Context) {

        if (uiViewController.compareAnswer(answer: objectCount) && !uiViewController.gameOver) {
           
            uiViewController.timer!.invalidate()
            uiViewController.timer = nil
            uiViewController.updatePoints()
            uiViewController.canContinue = true
   
            
        }
        if (startSpawning && uiViewController.canContinue) {
          uiViewController.startGame()
            uiViewController.runTimer()
            print("start game")
      }
        
        if (uiViewController.progressView.progress == 1){
            uiViewController.scene.removeAllChildren()
            uiViewController.loseGame()
            
        }
    }
    

}

class GameSceneViewController: UIViewController, FingerCountDelegate {
    
    var fingerDelegate: FingerCountDelegate?
    
    func setFinger(fingers: Int) {
        self.objecCount = fingers
    }
    
    
    @State var gameOver : Bool = false
    
    func setObjectCount(count: Int) {
        self.objecCount = count
        print(count)
        print("this")
    }
    var canContinue : Bool = true
    var objecCount : Int = 0
    var timer :
    Timer?
    
  weak var delegate: GameSceneViewControllerDelegate?
    
  let scene = GameScene()
    var points: Int = 0
    
    let textView = UITextView(frame: CGRect(x: 100, y: 50, width: 200, height: 150))
    let gameOverText = UITextView(frame: CGRect(x: 100, y: 50, width: 300, height: 300))
    

  
    var progressView = UIProgressView(progressViewStyle: .bar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.fingerDelegate = self
        gameOverText.center = view.center
        gameOverText.text = "GAME OVER"
        gameOverText.font = UIFont.boldSystemFont(ofSize: 80)
        gameOverText.textAlignment = .center
        gameOverText.backgroundColor = .clear
        gameOverText.textColor = .clear
        view.addSubview(gameOverText)
        
        progressView.frame = CGRect(x: 100, y: 150, width: 200, height: 200)
        
        progressView.layer.cornerRadius = 4
        progressView.transform=CGAffineTransformMakeScale(1.0, 3)

        progressView.clipsToBounds = true
//        progressView.setProgress(1, animated: true)
        progressView.trackTintColor = .systemBlue
        progressView.tintColor = .gray
        view.addSubview(progressView)
        
        textView.text = "\(self.points)"
        textView.backgroundColor = .clear
        textView.textAlignment = .center
//        textView.font = UIFont.systemFont(ofSize: 50)
        textView.font = UIFont.boldSystemFont(ofSize: 65)
        textView.textColor = .systemYellow
        
        let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        scene.size = view.frame.size
        scene.backgroundColor = .clear
        scene.scaleMode = .aspectFill

        view.addSubview(sceneView)
        view.addSubview(textView)
        view.backgroundColor = .clear
        sceneView.presentScene(scene)

    }
    
    func loseGame() {
        gameOverText.textColor = .black
    }
    
    func runTimer() {
        var progress: Float = 0.0
        self.progressView.progress = progress
    
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
            progress += 0.01
            self.progressView.progress = progress
            
            if self.progressView.progress == 1
            {
                self.gameOver = true
            }
            
            
        })
    }
    
    func updatePoints() {
       
            self.points += 1
            print(self.points)
            self.textView.text = "\(self.points)"
        
        
    }
    
    func compareAnswer(answer: Int) -> Bool {
      
        return self.scene.compareAnswer(answer: answer)
    }
  
    func startGame() {
        canContinue = false
        
        let objectCount = Int.random(in: 1..<11)
        DispatchQueue.main.async {
          
            
            self.scene.startGame(objectCount: objectCount, points: self.points)
           
        }
        
        delegate?.didStartSpawning(count: objectCount)
        
    }
    
  func spawn(shouldClearCanvas: Bool) {
      canContinue = false
      let objectCount = Int.random(in: 1..<11)
          
        self.scene.spawn(shouldClearCanvas: shouldClearCanvas, objectCount: objectCount, points: self.points)
      
      delegate?.didStartSpawning(count: objectCount)
  }
  
}
