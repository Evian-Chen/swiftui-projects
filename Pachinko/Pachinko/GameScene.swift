////
////  GameScene.swift
////  Pachinko
////
////  Created by Mac25 on 2025/3/19.
////
//
//import SpriteKit
//import GameplayKit
//
//class GameScene: SKScene, SKPhysicsContactDelegate {
//    enum GameState {
//        case waiting, playing, gameOver
//    }
//
//    var dino: SKSpriteNode!
//    var ground: SKSpriteNode!
//    var scoreLabel: SKLabelNode!
//    var gameState: GameState = .waiting
//    var score = 0
//    var gameSpeed: CGFloat = 5.0
//    var spawnTimer: Timer?
//
//    struct PhysicsCategory {
//        static let dino: UInt32 = 0x1 << 0
//        static let obstacle: UInt32 = 0x1 << 1
//    }
//
//    override func didMove(to view: SKView) {
//        physicsWorld.contactDelegate = self
//        setupScene()
//    }
//
//    func setupScene() {
//        backgroundColor = .white
//        addBackground()
//        addGround()
//        addDino()
//        addScoreLabel()
//    }
//
//    func addBackground() {
//        let bg = SKSpriteNode(imageNamed: "background")
//        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        bg.zPosition = -1
//        addChild(bg)
//    }
//
//    func addGround() {
//        ground = SKSpriteNode(imageNamed: "ground")
//        ground.anchorPoint = .zero
//        ground.position = .zero
//        ground.zPosition = 1
//        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
//        ground.physicsBody?.isDynamic = false
//        ground.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
//        addChild(ground)
//    }
//
//    func addDino() {
//        dino = SKSpriteNode(imageNamed: selectedSkin)
//        dino.position = CGPoint(x: size.width * 0.2, y: ground.size.height + 40)
//        dino.zPosition = 2
//        dino.setScale(0.5)
//        dino.physicsBody = SKPhysicsBody(rectangleOf: dino.size)
//        dino.physicsBody?.categoryBitMask = PhysicsCategory.dino
//        dino.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle
//        dino.physicsBody?.collisionBitMask = PhysicsCategory.obstacle
//        dino.physicsBody?.affectedByGravity = true
//        addChild(dino)
//    }
//
//    func addScoreLabel() {
//        scoreLabel = SKLabelNode(fontNamed: "ArialRoundedMTBold")
//        scoreLabel.fontSize = 24
//        scoreLabel.fontColor = .black
//        scoreLabel.position = CGPoint(x: size.width - 80, y: size.height - 50)
//        scoreLabel.text = "Score: 0"
//        addChild(scoreLabel)
//    }
//
//    func startGame() {
//        gameState = .playing
//        physicsWorld.gravity = CGVector(dx: 0, dy: -15)
//        score = 0
//        gameSpeed = 5.0
//        spawnTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
//            self.spawnObstacle()
//        }
//
//        let increaseSpeed = SKAction.repeatForever(
//            SKAction.sequence([
//                SKAction.wait(forDuration: 5.0),
//                SKAction.run { self.gameSpeed += 0.5 }
//            ])
//        )
//        run(increaseSpeed, withKey: "speedUp")
//    }
//
//    func gameOver() {
//        gameState = .gameOver
//        spawnTimer?.invalidate()
//        removeAction(forKey: "speedUp")
//
//        // 儲存分數至排行榜
//        var scores = highScores
//        scores.append(score)
//        scores.sort(by: >)
//        highScores = Array(scores.prefix(5))
//    }
//
//    func spawnObstacle() {
//        let isBird = Bool.random()
//        let obstacle = SKSpriteNode(imageNamed: isBird ? "bird" : "cactus")
//        obstacle.position = CGPoint(x: size.width + 50, y: isBird ? ground.size.height + 120 : ground.size.height + 20)
//        obstacle.setScale(0.5)
//        obstacle.zPosition = 2
//
//        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
//        obstacle.physicsBody?.isDynamic = false
//        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
//
//        addChild(obstacle)
//
//        let moveAction = SKAction.moveBy(x: -size.width - 100, y: 0, duration: TimeInterval(size.width / gameSpeed))
//        let removeAction = SKAction.removeFromParent()
//        obstacle.run(SKAction.sequence([moveAction, removeAction]))
//
//        score += 1
//        scoreLabel.text = "Score: \(score)"
//    }
//
//    // MARK: - Touch Handling
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//
//        switch gameState {
//        case .waiting:
//            startGame()
//        case .playing:
//            break
//        case .gameOver:
//            removeAllChildren()
//            setupScene()
//            gameState = .waiting
//        }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard gameState == .playing, let touch = touches.first else { return }
//
//        let start = touch.previousLocation(in: self)
//        let end = touch.location(in: self)
//        let dy = end.y - start.y
//
//        if dy > 30 {
//            jump()
//        } else if dy < -30 {
//            duck()
//        }
//    }
//
//    func jump() {
//        if dino.physicsBody?.velocity.dy == 0 {
//            dino.texture = SKTexture(imageNamed: "dino_jump")
//            dino.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 350))
//        }
//    }
//
//    func duck() {
//        dino.texture = SKTexture(imageNamed: "dino_duck")
//        let wait = SKAction.wait(forDuration: 0.8)
//        let run = SKAction.run {
//            self.dino.texture = SKTexture(imageNamed: "dino_run")
//        }
//        run(SKAction.sequence([wait, run]))
//    }
//
//    // MARK: - Physics Delegate
//    func didBegin(_ contact: SKPhysicsContact) {
//        gameOver()
//    }
//}
