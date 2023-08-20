import SpriteKit


    class GameScene: SKScene {
        
        private enum Constants {
            static let animationDelay: TimeInterval = 0.1
            static let defaultAnimationDuration: TimeInterval = 0.5
            static let cleanupDelay: TimeInterval = 5
            //    static let starWidth: CGFloat = 16
            static let maxObjectCount: Int = 10
        }
        
        private var cleanupWorkItem: DispatchWorkItem?
        
        var points: Int = 0
        var objectCount: Int!
        let scoreText = SKLabelNode()
        
        override func didMove(to view: SKView) {
            print("Game Scene Loaded")
            self.view?.backgroundColor = .clear
            physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
            addPhysicsBoundariesToScene()
        }
        
        func startGame(objectCount: Int, points: Int) {
            self.objectCount = objectCount
            spawn(shouldClearCanvas: true, objectCount: objectCount, points: points)
        }
        
        func compareAnswer(answer: Int) -> Bool {
            if self.objectCount == answer {
                self.points += 1
                return true
            }
            else{ return false
            }
            
        }
        
        func spawn(shouldClearCanvas: Bool, objectCount: Int, points: Int) {
            self.objectCount = objectCount
            if shouldClearCanvas {
                cleanup()
            }
            
            if points > 5 {
                
                for _ in 0...5 {
                    spawnOthers()
                }
            }else if points > 10 {
                    for _ in 0...5 {
                        spawnOthers()
                    }
                    
                }
                
                
                for _ in 1...objectCount {
                    
                    spawnObjects()
                }
                
            }
            
        
        func spawnOthers() {
            let others = ["🌝", "🪨","🗿","🚀","🌞","🛸","🛰️"]
            
            let objectSizes = [50,75,100]
            
            let speed = [-12,-10,-7-5,5,7,10,12]
            
            var object = SKSpriteNode()
            
            let image = others.randomElement()?.image(sizes: objectSizes.randomElement() ?? 100)
            let texture = SKTexture(image: image!)
            object = SKSpriteNode(texture: texture)
            
            object.anchorPoint = CGPoint(x: CGFloat(0), y: CGFloat(0))
            
            let rotate = SKAction.rotate(toAngle: CGFloat(3.14), duration: 5)
            let repeatRotation = SKAction.repeatForever(rotate)
            object.run(repeatRotation)
            
            let physicsBody = SKPhysicsBody(circleOfRadius: object.frame.width / 2)
            physicsBody.restitution = 1
            physicsBody.friction = 0
            physicsBody.allowsRotation = true
            physicsBody.linearDamping = 0
            physicsBody.angularDamping = 1
            physicsBody.angularVelocity = 1
            object.physicsBody = physicsBody
            
            object.position = getRandomPoint()
            
            addChild(object)
            object.physicsBody!.applyImpulse(CGVector(dx: speed.randomElement()!, dy: speed.randomElement()!))
        }
        
        
        @objc private func cleanup() {

            self.removeAllChildren()

        }
        
        func spawnObjects() {
            
            let objectSizes = [50,75,100]
            
            let speed = [-12,-10,-7-5,5,7,10,12]
            
            var object = SKSpriteNode()
            
            let image = "⭐️".image(sizes: objectSizes.randomElement() ?? 100)
            let texture = SKTexture(image: image!)
            object = SKSpriteNode(texture: texture)
            
            object.anchorPoint = CGPoint(x: CGFloat(0), y: CGFloat(0))
            
            var rotate = SKAction.rotate(toAngle: CGFloat(3.14), duration: 5)
            let repeatRotation = SKAction.repeatForever(rotate)
            object.run(repeatRotation)
            
            let physicsBody = SKPhysicsBody(circleOfRadius: object.frame.width / 2)
            physicsBody.restitution = 1
            physicsBody.friction = 0
            physicsBody.allowsRotation = true
            physicsBody.linearDamping = 0
            physicsBody.angularDamping = 1
            physicsBody.angularVelocity = 1
            object.physicsBody = physicsBody
            
            object.position = getRandomPoint()
            
            addChild(object)
            object.physicsBody!.applyImpulse(CGVector(dx: speed.randomElement()!, dy: speed.randomElement()!))
            
            UIView.animate(withDuration: Constants.defaultAnimationDuration, delay: Constants.animationDelay * Double(20)) {
//              star.alpha = 1
            }
            
        }
        
        func getRandomPoint(withinRect rect:CGRect)->CGPoint{
            
            let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: rect.size.width)
            let y = CGFloat(arc4random()).truncatingRemainder(dividingBy: rect.size.height)
            
            return CGPoint(x: x, y: y)
        }
        
        private func prepareText() {
        
            scoreText.text = "Score \(self.points)"
            scoreText.name = "Score"
            scoreText.fontSize = 65
            scoreText.fontColor = SKColor.green
            scoreText.position = CGPoint(x: frame.midX, y: frame.midY)
               
            addChild(scoreText)

        }
        
        func updateText() {
            scoreText.text = "Score \(self.points)"
        }
        
        private func addPhysicsBoundariesToScene() {
            let physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
            //        physicsBody.isDynamic = false
            physicsBody .friction = 0
            self.physicsBody = physicsBody
        }
        
        func getRandomPoint() -> CGPoint {
            let x = randomInRange(lo: 100, hi: Int(self.view!.frame.width - 100))
            let y = randomInRange(lo: 100, hi: Int(self.view!.frame.height - 100))
            
            let position = CGPoint(x: x, y: y)
            return position
        }
        
        func randomInRange(lo: Int, hi : Int) -> Int {
            return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
        }
        
        
    }


