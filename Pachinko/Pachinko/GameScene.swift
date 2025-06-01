//
//  GameScene.swift
//  Pachinko
//

import SpriteKit
import SwiftUI
import SwiftData

class GameScene: SKScene, SKPhysicsContactDelegate {
    enum GameState {
        case waiting, playing, gameOver
    }

    // MARK: - Properties
    var gameData: GameData!
    var modelContext: ModelContext!

    var dino: SKSpriteNode!
    var ground: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var resetButton: SKSpriteNode?
    var startButton: SKSpriteNode?

    var runFrames: [SKTexture] = []
    var gameState: GameState = .waiting
    var score = 0
    var gameSpeed: CGFloat = 400.0
    var isDucking = false
    let dinoStandY: CGFloat = 280

    var isOnGround = false
    var spawnTimer: Timer?
    var scoreTimer: Timer?

    struct PhysicsCategory {
        static let dino: UInt32     = 0x1 << 0
        static let ground: UInt32   = 0x1 << 1
        static let obstacle: UInt32 = 0x1 << 2
    }

    func configure(gameData: GameData, context: ModelContext) {
        self.gameData = gameData
        self.modelContext = context
    }

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setupScene()
    }

    // MARK: - Scene Setup
    func setupScene() {
        backgroundColor = .white
        addBackground()
        addGround()
        addDino()
        addScoreLabel()
        addStartButton()
    }

    func addBackground() {
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.size = size
        bg.zPosition = -1
        addChild(bg)
    }

    func addGround() {
        ground = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: 40))
        ground.anchorPoint = .zero
        let groundY: CGFloat = 220  // 地面往上抬高
        let groundHeight: CGFloat = 60

        ground = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: groundHeight))
        ground.anchorPoint = .zero
        ground.position = CGPoint(x: 0, y: groundY)


        ground.zPosition = 1

        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.dino
        ground.physicsBody?.collisionBitMask = PhysicsCategory.dino

        addChild(ground)
    }

    func addDino() {
        let base = gameData.selectedDino

        runFrames = [
            safeTexture(named: "\(base)_run1", fallback: "default_dino_run1"),
            safeTexture(named: "\(base)_run2", fallback: "default_dino_run2")
        ]

        dino = SKSpriteNode(texture: runFrames[0])
        dino.anchorPoint = CGPoint(x: 0.5, y: 0)
        let yOffset: CGFloat = 500 // 想要往上移多少就調整這裡
        dino.position = CGPoint(x: size.width * 0.2, y: ground.position.y + ground.size.height + yOffset)
        dino.setScale(0.5)
        dino.zPosition = 2

        dino.physicsBody = SKPhysicsBody(rectangleOf: dino.size)
        dino.physicsBody?.affectedByGravity = true
        dino.physicsBody?.allowsRotation = false
        dino.physicsBody?.categoryBitMask = PhysicsCategory.dino
        dino.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.ground
        dino.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.obstacle

        addChild(dino)

        let runAction = SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.2))
        dino.run(runAction, withKey: "running")
    }

    func addScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .black
        scoreLabel.position = CGPoint(x: size.width - 100, y: size.height - 50)
        scoreLabel.zPosition = 100
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
    }
    
    func addStartButton() {
        let button = SKSpriteNode(imageNamed: "startButton")
        button.name = "start"
        button.position = CGPoint(x: size.width / 2, y: size.height / 2)
        button.setScale(0.5)
        button.zPosition = 10
        addChild(button)
        startButton = button
    }


    // MARK: - Game Flow
    func startGame() {
        gameState = .playing
        isOnGround = true
        physicsWorld.gravity = CGVector(dx: 0, dy: -15)
        score = 0
        self.gameSpeed = 400.0

        scoreTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.score += 1
            self.scoreLabel.text = "Score: \(self.score)"
            self.gameSpeed = min(self.gameSpeed + 20, 1200) // 設最大值
        }

        spawnObstacle()
    }

    func spawnObstacle() {
        guard gameState == .playing else { return }

        let isBird = Bool.random()
        let name = isBird ? ["bird_1", "bird_2"].randomElement()! : ["cactus_one", "cactus_two"].randomElement()!
        
        let obstacle = SKSpriteNode(imageNamed: name)
        obstacle.name = "obstacle"
        obstacle.zPosition = 2

        if !isBird {
            // 是仙人掌
            obstacle.setScale(0.3)
            obstacle.anchorPoint = CGPoint(x: 0.5, y: 0)
            let groundTopY = ground.position.y + ground.size.height
            obstacle.position = CGPoint(x: size.width + 50, y: groundTopY + 30)

            let bodySize = CGSize(width: obstacle.size.width * 0.8, height: obstacle.size.height * 0.8)
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: bodySize, center: CGPoint(x: 0, y: bodySize.height / 2))
        } else {
            // 是鳥
            obstacle.setScale(0.5)
            obstacle.position = CGPoint(x: size.width + 50, y: ground.position.y + 220)
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        }

        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        addChild(obstacle)

        let moveDistance = size.width + 100
        let moveDuration = TimeInterval(moveDistance / gameSpeed)
        let move = SKAction.moveBy(x: -moveDistance, y: 0, duration: moveDuration)
        let afterMove = SKAction.run { [weak self] in
            obstacle.removeFromParent()
            self?.spawnObstacle()
        }

        obstacle.run(SKAction.sequence([move, afterMove]))
    }

    func gameOver() {
        gameState = .gameOver
        spawnTimer?.invalidate()
        scoreTimer?.invalidate()
        removeAllActions()
        isOnGround = false

        dino.removeAllActions()
        dino.texture = safeTexture(named: "\(gameData.selectedDino)_dead", fallback: "default_dino_dead")

        for node in children {
            node.removeAllActions()
        }
        
        gameData.sortScore(score: score)
        gameData.totalCoins += score
        try? modelContext.save()

        let button = SKSpriteNode(imageNamed: "resetButton")
        button.name = "reset"
        button.position = CGPoint(x: size.width / 2, y: size.height / 2)
        button.setScale(0.5)
        button.zPosition = 10
        addChild(button)
        resetButton = button
    }

    func resetGame() {
        removeAllChildren()
        removeAllActions()
        gameState = .waiting
        setupScene()
    }

    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        switch gameState {
        case .waiting:
            if let node = nodes(at: location).first(where: { $0.name == "start" }) {
                node.removeFromParent()
                startGame()
            }
        case .playing:
            break
        case .gameOver:
            if let node = nodes(at: location).first(where: { $0.name == "reset" }) {
                resetGame()
            }
        }
    }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard gameState == .playing, let touch = touches.first else { return }

        let start = touch.previousLocation(in: self)
        let end = touch.location(in: self)
        let dy = end.y - start.y

        if dy > 30 {
            jump()
        } else if dy < -30 {
            duck()
        }
    }

    func jump() {
        guard let body = dino.physicsBody, isOnGround else { return }

        let jumpTexture = safeTexture(named: "\(gameData.selectedDino)_jump", fallback: "default_dino_jump")
        dino.texture = jumpTexture
        body.applyImpulse(CGVector(dx: 0, dy: 800))
        isOnGround = false
    }

    func duck() {
        guard !isDucking else { return }
        isDucking = true

        dino.texture = safeTexture(named: "\(gameData.selectedDino)_duck", fallback: "default_dino_duck")
        dino.removeAction(forKey: "running")

        let offset: CGFloat = 10
        dino.physicsBody?.isDynamic = false
        dino.position = CGPoint(x: dino.position.x, y: dinoStandY - offset)

        let wait = SKAction.wait(forDuration: 0.8)
        let restore = SKAction.run {
            self.dino.position = CGPoint(x: self.dino.position.x, y: self.dinoStandY)
            self.dino.physicsBody?.isDynamic = true
            self.dino.run(SKAction.repeatForever(SKAction.animate(with: self.runFrames, timePerFrame: 0.2)), withKey: "running")
            self.isDucking = false
        }

        dino.run(SKAction.sequence([wait, restore]))
    }


    // MARK: - Physics Contact
    func didBegin(_ contact: SKPhysicsContact) {
        let maskA = contact.bodyA.categoryBitMask
        let maskB = contact.bodyB.categoryBitMask
        let combined = maskA | maskB

        if combined == (PhysicsCategory.dino | PhysicsCategory.ground) {
            isOnGround = true
        }

        if combined == (PhysicsCategory.dino | PhysicsCategory.obstacle) {
            gameOver()
        }
    }

    // MARK: - Helpers
    func safeTexture(named name: String, fallback: String) -> SKTexture {
        if UIImage(named: name) != nil {
            return SKTexture(imageNamed: name)
        } else {
            print("找不到圖：\(name)，使用 fallback：\(fallback)")
            return SKTexture(imageNamed: fallback)
        }
    }
}
