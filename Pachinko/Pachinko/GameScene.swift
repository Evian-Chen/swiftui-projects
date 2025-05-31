//
//  GameScene.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/31.
//

import SpriteKit
import SwiftData
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    enum GameState {
        case waiting, playing, gameOver
    }

    // MARK: - 注入資料
    var gameData: GameData!
    var modelContext: ModelContext!

    func configure(gameData: GameData, context: ModelContext) {
        self.gameData = gameData
        self.modelContext = context
    }

    // MARK: - 角色與物件
    var dino: SKSpriteNode!
    var ground: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var resetButton: SKSpriteNode?

    // MARK: - 遊戲狀態
    var runFrames: [SKTexture] = []
    var gameState: GameState = .waiting
    var score = 0
    var gameSpeed: CGFloat = 5.0
    var spawnTimer: Timer?
    var scoreTimer: Timer?
    var isOnGround = true


    struct PhysicsCategory {
        static let dino: UInt32 = 0x1 << 0
        static let ground: UInt32 = 0x1 << 1
        static let obstacle: UInt32 = 0x1 << 2
    }

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setupScene()
    }

    func setupScene() {
        removeAllChildren()
        backgroundColor = .white
        addBackground()
        addGround()
        addDino()
        addScoreLabel()
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
        ground.position = .zero
        ground.zPosition = 1
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.contactTestBitMask = 0
        ground.physicsBody?.collisionBitMask = PhysicsCategory.dino  // ✅ 恐龍可以站上去
        addChild(ground)
    }


    func addDino() {
        let base = gameData.selectedDino

        let run1 = safeTexture(named: "\(base)_run1", fallback: "default_dino_run1")
        let run2 = safeTexture(named: "\(base)_run2", fallback: "default_dino_run2")
        runFrames = [run1, run2]

        dino = SKSpriteNode(texture: runFrames[0])
        dino.anchorPoint = CGPoint(x: 0.5, y: 0)
        dino.position = CGPoint(x: size.width * 0.2, y: ground.size.height)
        dino.zPosition = 2
        dino.setScale(0.5)

        dino.physicsBody = SKPhysicsBody(rectangleOf: dino.size)
        dino.physicsBody?.affectedByGravity = true
        dino.physicsBody?.allowsRotation = false
        dino.physicsBody?.categoryBitMask = PhysicsCategory.dino
        dino.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle
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

    func startGame() {
        gameState = .playing
        physicsWorld.gravity = CGVector(dx: 0, dy: -15)
        score = 0
        gameSpeed = 5.0

        spawnTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.spawnObstacle()
        }

        scoreTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.score += 1
            self.scoreLabel.text = "Score: \(self.score)"
        }

        let speedUp = SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.run { self.gameSpeed += 0.5 }
        ]))
        run(speedUp, withKey: "speedUp")
    }

    func spawnObstacle() {
        let isBird = Bool.random()
        let name = isBird ? ["bird_1", "bird_2"].randomElement()! : ["cactus_one", "cactus_two"].randomElement()!
        let obstacle = SKSpriteNode(imageNamed: name)
        let yOffset: CGFloat = isBird ? ground.size.height + 120 : ground.size.height + 20

        obstacle.position = CGPoint(x: size.width + 50, y: yOffset)
        obstacle.setScale(0.5)
        obstacle.zPosition = 2

        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle

        addChild(obstacle)

        let moveDuration = TimeInterval((size.width + 100) / (gameSpeed * 2.0))
        let move = SKAction.moveBy(x: -size.width - 100, y: 0, duration: moveDuration)
        let remove = SKAction.removeFromParent()
        obstacle.run(SKAction.sequence([move, remove]))
    }


    func gameOver() {
        gameState = .gameOver
        spawnTimer?.invalidate()
        scoreTimer?.invalidate()
        removeAction(forKey: "speedUp")

        dino.removeAllActions()
        dino.texture = safeTexture(named: "\(gameData.selectedDino)_dead", fallback: "default_dino_dead")

        gameData.sortScore(score: score)
        gameData.totalCoins += score
        GameDataManager.shared.save()

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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        switch gameState {
        case .waiting:
            startGame()
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
        body.applyImpulse(CGVector(dx: 0, dy: 350))
        isOnGround = false
    }


    func duck() {
        let duckTexture = safeTexture(named: "\(gameData.selectedDino)_duck", fallback: "default_dino_duck")
        dino.texture = duckTexture
        dino.removeAction(forKey: "running")

        let wait = SKAction.wait(forDuration: 0.6)
        let restore = SKAction.run {
            self.dino.run(SKAction.repeatForever(SKAction.animate(with: self.runFrames, timePerFrame: 0.2)), withKey: "running")
        }

        dino.run(SKAction.sequence([wait, restore]))
    }


    func didBegin(_ contact: SKPhysicsContact) {
        let bodies = [contact.bodyA, contact.bodyB]

        if bodies.contains(where: { $0.categoryBitMask == PhysicsCategory.ground }) &&
            bodies.contains(where: { $0.categoryBitMask == PhysicsCategory.dino }) {
            isOnGround = true
        }

        if bodies.contains(where: { $0.categoryBitMask == PhysicsCategory.dino }) &&
            bodies.contains(where: { $0.categoryBitMask == PhysicsCategory.obstacle }) {
            gameOver()
        }
    }


    func safeTexture(named name: String, fallback: String) -> SKTexture {
        if UIImage(named: name) != nil {
            return SKTexture(imageNamed: name)
        } else {
            print("⚠️ 無法載入 \(name)，使用預設 \(fallback)")
            return SKTexture(imageNamed: fallback)
        }
    }
}
