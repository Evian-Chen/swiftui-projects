//
//  GameScene.swift
//  Ninja
//
//  Created by hpclab on 2025/3/24.
//
import SwiftUI
import SpriteKit
import AVFoundation

enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}

enum ForceBomb {
    case never, always, random
}

enum EnemyType: CaseIterable {
    case cplus, caculus, linearMath, eletric
    
    var imageName: String {
        switch self {
        case .cplus: return "enemyCplus"
        case .caculus: return "enemyCaculus"
        case .linearMath: return "enemylinearMath"
        case .eletric: return "enemyEletric"
        }
    }
    
    var isRare: Bool {
        return self == .cplus
    }
}


class GameScene: SKScene {
    
    var gameScore: SKLabelNode!
    
    var pauseButton: SKSpriteNode!
    var isGamePaused = false
    
    var isGameEnded = false
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    
    var activeSlicePoints = [CGPoint]()
    
    var isSwooshSoundActive = false
    
    var activeEnemies = [SKSpriteNode]()
    
    var bombSoundEffect: AVAudioPlayer?
    
    var popupTime = 0.9
    var sequence = [SequenceType]()
    var sequencePosition = 0
    var chainDelay = 3.0
    var nextSequenceQueued = true
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x:0, y:0) //設定場景左下角對齊View左下角
        
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        
        sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        
        for _ in 0 ... 1000 {
            if let nextSequence = SequenceType.allCases.randomElement() {
                sequence.append(nextSequence)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.tossEnemies()
        }
        
        func createPauseButton() {
            pauseButton = SKSpriteNode(imageNamed: "pauseButton")
            pauseButton.name = "pauseButton"
            pauseButton.position = CGPoint(x: 60, y: 700)
            pauseButton.zPosition = 10
            pauseButton.setScale(0.5)
            addChild(pauseButton)
        }

        createPauseButton()
    }
    
    
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
    }
    
    func createLives() {
        for i in 0 ..< 3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            
            livesImages.append(spriteNode)
        }
    }
    
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    func togglePause() {
        isGamePaused.toggle()
        isPaused = isGamePaused

        let textureName = isGamePaused ? "playButton" : "pauseButton"
        pauseButton.texture = SKTexture(imageNamed: textureName)

        // 加入暫停與繼續的音效
        let soundName = isGamePaused ? "pause.caf" : "resume.caf"
        run(SKAction.playSoundFileNamed(soundName, waitForCompletion: false))
    }

    func restartGame() {
        // 清除所有節點（除了自己）
        removeAllChildren()
        activeEnemies.removeAll()

        // 重設所有狀態
        isGameEnded = false
        isUserInteractionEnabled = true
        score = 0
        lives = 3
        popupTime = 0.9
        sequencePosition = 0
        chainDelay = 3.0
        nextSequenceQueued = true

        // 重建場景內容
        didMove(to: self.view!)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if node.name == "pauseButton" {
                togglePause()
                return
            } else if node.name == "restartButton" {
                restartGame()
                return
            }
        }
        
        
        // 1
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        // 2
//        let location = touch.location(in: self)
        
        activeSlicePoints.append(location)
        
        // 3
        redrawActiveSlice()
        
        // 4
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        
        // 5
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameEnded {
            return
        }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
        
        let nodesAtPoint = nodes(at: location)
        for case let node as SKSpriteNode in nodesAtPoint {
            if node.name?.starts(with: "enemy:") ?? false {
                // 1
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emitter.position = node.position
                    addChild(emitter)
                }
                
                // 2
                node.name = ""
                
                // 3
                node.physicsBody?.isDynamic = false
                
                // 4
                let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                
                // 5
                let seq = SKAction.sequence([group, .removeFromParent()])
                node.run(seq)
                
                // 6
                let isRare = node.name?.contains("Cplus") ?? false
                score += isRare ? 5 : 1
                
                // 7
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                
                // 8
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "bomb" {
                guard let bombContainer = node.parent as? SKSpriteNode else { continue }
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
                    emitter.position = bombContainer.position
                    addChild(emitter)
                }
                node.name = ""
                bombContainer.physicsBody?.isDynamic = false
                let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                let seq = SKAction.sequence([group, .removeFromParent()])
                bombContainer.run(seq)
                if let index = activeEnemies.firstIndex(of: bombContainer) {
                    activeEnemies.remove(at: index)
                }
                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                endGame(triggeredByBomb: true)
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    func playSwooshSound() {
        isSwooshSoundActive = true
        
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        run(swooshSound) { [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
    
    
    func redrawActiveSlice() {
        // 1
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        // 2
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        // 3
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        // 4
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    
    func createEnemy(forceBomb: ForceBomb = .random) {
        let enemy: SKSpriteNode
        
        
        var enemyType = Int.random(in: 0...6)
        let randomEnemyType = EnemyType.allCases.randomElement()!
        
        if forceBomb == .never {
            enemyType = 1
        } else if forceBomb == .always {
            enemyType = 0
        }

        if enemyType == 0 {
            // bombContainer 的外觀保持固定（你原本是用 randomEnemyType，但這邊其實應該用炸彈的圖）
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"

            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)

            // 播放 fuse 音效
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf"),
               let sound = try? AVAudioPlayer(contentsOf: path) {
                bombSoundEffect = sound
                sound.play()
            }

            if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }

        } else {
            // 一般敵人使用 randomEnemyType
            enemy = SKSpriteNode(imageNamed: randomEnemyType.imageName)
            enemy.setScale(0.5)
            enemy.name = "enemy:\(randomEnemyType)"

            if randomEnemyType.isRare {
                let glow = SKShapeNode(circleOfRadius: 70)
                glow.strokeColor = .red
                glow.lineWidth = 6
                glow.glowWidth = 15
                glow.zPosition = -1
                enemy.addChild(glow)
                enemy.setScale(0.6)
            }

            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
        }

        // 通用的敵人配置（位置、物理效果）
        let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
        enemy.position = randomPosition

        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomXVelocity: Int

        if randomPosition.x < 256 {
            randomXVelocity = Int.random(in: 8...15)
        } else if randomPosition.x < 512 {
            randomXVelocity = Int.random(in: 3...5)
        } else if randomPosition.x < 768 {
            randomXVelocity = -Int.random(in: 3...5)
        } else {
            randomXVelocity = -Int.random(in: 8...15)
        }

        let randomYVelocity = Int.random(in: 24...32)

        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        let speedMultiplier: CGFloat = randomEnemyType.isRare ? 50 : 30
        enemy.physicsBody?.velocity = CGVector(dx: CGFloat(randomXVelocity) * speedMultiplier, dy: CGFloat(randomYVelocity) * speedMultiplier)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0

        addChild(enemy)
        activeEnemies.append(enemy)
    }

    
    func tossEnemies() {
        if isGameEnded {
            return
        }
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
            
        case .one:
            createEnemy()
            
        case .twoWithOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)
            
        case .two:
            createEnemy()
            createEnemy()
            
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .chain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [weak self] in self?.createEnemy() }
            
        case .fastChain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [weak self] in self?.createEnemy() }
        }
        
        sequencePosition += 1
        nextSequenceQueued = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    node.removeAllActions()
                    if node.name?.starts(with: "enemy") ?? false {
                        node.name = ""
                        subtractLife()
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    } else if node.name == "bombContainer" {
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                }
            }
        } else {
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [weak self] in
                    self?.tossEnemies()
                }
                
                nextSequenceQueued = true
            }
        }
        
        
        
        var bombCount = 0
        
        for node in activeEnemies {
            if node.name == "bombContainer" {
                bombCount += 1
                break
            }
        }
        
        if bombCount == 0 {
            // no bombs – stop the fuse sound!
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
    }
    
    func subtractLife() {
        lives -= 1
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        var life: SKSpriteNode
        if lives == 2 {
            life = livesImages[ 0]
        } else if lives == 1 {
            life = livesImages[ 1]
        } else {
            life = livesImages[ 2]
            endGame(triggeredByBomb: false)
        }
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration:0.1))
    }
    
    func endGame(triggeredByBomb: Bool) {
        if isGameEnded {
            return
        }
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        bombSoundEffect?.stop()
        bombSoundEffect = nil
        if triggeredByBomb {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
        
        showGameOver()
    }
    
    func showGameOver() {
        // 遮罩背景
        let overlay = SKSpriteNode(color: UIColor(white: 0, alpha: 0.7), size: size)
        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.zPosition = 100
        overlay.name = "gameOverOverlay"
        addChild(overlay)

        // 顯示文字
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontName = "Chalkduster"
        gameOverLabel.fontSize = 64
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        gameOverLabel.zPosition = 101
        addChild(gameOverLabel)

        // 顯示分數
        let scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 44
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        scoreLabel.zPosition = 101
        addChild(scoreLabel)

        // 重新開始按鈕
        let restartButton = SKSpriteNode(imageNamed: "restartButton") // 請準備一個圖片
        restartButton.name = "restartButton"
        restartButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 60)
        restartButton.zPosition = 101
        restartButton.setScale(0.5)
        addChild(restartButton)
    }

}



struct GameView: View {
    var scene: SKScene {
        let scene = GameScene(size: CGSize(width: 1024, height: 768)) // 設定遊戲場景大小
        scene.scaleMode = .aspectFit
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea() // 讓畫面全螢幕顯示
    }
}
