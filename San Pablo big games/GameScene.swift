//  GameScene.swift
//  San Pablo big games
//
//  Created by Mac on 21.05.2025.
//

import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    var dismissAction: (() -> Void)?
    var shouldDismiss = false {
        didSet {
            if shouldDismiss {
                dismissAction?()
            }
        }
    }
    weak var gameState: GameData!
    var selectedHorse: Horse!
    var horseSkin: String
    var backgroundImage: String
    var isTournament: Bool
    
    // Custom initializer
    init(size: CGSize, gameState: GameData, selectedHorse: Horse, horseSkin: String, backgroundImage: String, isTournament: Bool) {
        self.horseSkin = horseSkin
        self.backgroundImage = backgroundImage
        self.isTournament = isTournament
        super.init(size: size)
        self.gameState = gameState
        self.selectedHorse = selectedHorse
        self.scaleMode = .fill
    }
    
    // Required initializer for NSCoding
    required init?(coder aDecoder: NSCoder) {
        // Provide default values
        self.horseSkin = "thunder"
        self.backgroundImage = "race_bg_1"
        self.isTournament = false
        super.init(coder: aDecoder)
    }

    private var horseNode: SKSpriteNode!
    private var backgroundNode: SKSpriteNode!
    private var backgroundNode2: SKSpriteNode!
    private var obstacles = [SKSpriteNode]()
    private var otherHorses = [SKSpriteNode]()
    private var lanes = [CGFloat]()
    private var currentLane = 1 // middle lane
    
    private var isJumping = false
    private var isBoosting = false
    private var distance: CGFloat = 0
    private var baseSpeed: CGFloat = 350
    private var maxSpeed: CGFloat = 400
    private var stamina: CGFloat = 100
    var gameOver = false
    
    // Увеличиваем длину уровня до 5000 метров
    private let levelDistance: CGFloat = 5000
    
    private let horseCategory: UInt32 = 0x1 << 0
    private let obstacleCategory: UInt32 = 0x1 << 1
    private let boostCategory: UInt32 = 0x1 << 2
    
    private var jumpButton: SKShapeNode!
    private var backButton: SKSpriteNode!
    private var restartButton: SKShapeNode!
    private var distanceLabel: SKLabelNode!
    
    enum ObstacleType: CaseIterable {
        case igle
        case arrows
        case pero
        
        var imageName: String {
            switch self {
            case .igle: return "igle"
            case .arrows: return "arrows"
            case .pero: return "pero"
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        // Сбрасываем состояние игры
        gameOver = false
        distance = 0
        stamina = 100
        isJumping = false
        isBoosting = false
        
        physicsWorld.contactDelegate = self
        setupScene()
        setupUI()
        
        if isTournament {
            setupTournament()
        }
        
        startGeneratingObstacles()
    }
    private func setupScene() {
        // Настройка фона на весь экран
        backgroundColor = .black // Фон на случай, если изображение не покроет весь экран
        
        backgroundNode = SKSpriteNode(imageNamed: backgroundImage)
        backgroundNode.zPosition = -1
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.size = self.size  // Простое решение — растянуть на весь экран

        // Рассчитываем соотношение сторон и масштабируем фон
        let backgroundAspect = backgroundNode.size.width / backgroundNode.size.height
        let screenAspect = size.width / size.height
        
        if backgroundAspect > screenAspect {
            // Фон шире экрана - подгоняем по высоте
            backgroundNode.size.height = size.height
            backgroundNode.size.width = size.height * backgroundAspect
        } else {
            // Фон уже экрана - подгоняем по ширине
            backgroundNode.size.width = size.width
            backgroundNode.size.height = size.width / backgroundAspect
        }
        
        addChild(backgroundNode)
        
        // Второй фон для бесконечного эффекта
        backgroundNode2 = SKSpriteNode(imageNamed: backgroundImage)  // Add this line
        backgroundNode2.zPosition = -1
        backgroundNode2.position = CGPoint(x: size.width + size.width/2, y: size.height/2)
        backgroundNode2.size = backgroundNode.size
        backgroundNode2.size = self.size

        addChild(backgroundNode2)
        
        // Настройка полос (3 полосы в нижних 2/3 экрана)
        let laneHeight = size.height * 2/3
        let laneSpacing = laneHeight / 3
        lanes = [
            laneSpacing / 2,
            laneSpacing + laneSpacing / 2,
            laneSpacing * 2 + laneSpacing / 2
        ]
        
        // Настройка лошади игрока
        horseNode = SKSpriteNode(imageNamed: "horse_\(horseSkin)")
        horseNode.position = CGPoint(x: size.width * 0.2, y: lanes[currentLane])
        horseNode.zPosition = 10
        horseNode.size = CGSize(width: 80, height: 80)

        horseNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: horseNode.size.width * 0.8, height: horseNode.size.height * 0.8))
        horseNode.physicsBody?.isDynamic = true
        horseNode.physicsBody?.affectedByGravity = false
        horseNode.physicsBody?.categoryBitMask = horseCategory
        horseNode.physicsBody?.contactTestBitMask = obstacleCategory | boostCategory
        horseNode.physicsBody?.collisionBitMask = 0
        
        addChild(horseNode)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
//        baseSpeed = 370
    }
    
    private func setupUI() {
        // Уменьшаем размер кнопок
        let buttonRadius: CGFloat = 30 // Было 40 для jump и 30 для restart
        
        // Кнопка прыжка - коричневый круг с текстом (теперь меньше)
        jumpButton = SKShapeNode(circleOfRadius: buttonRadius)
        jumpButton.position = CGPoint(x: size.width - 80, y: 70) // Сдвигаем чуть левее
        jumpButton.zPosition = 100
        jumpButton.fillColor = UIColor(red: 139/255, green: 69/255, blue: 19/255, alpha: 1)
        jumpButton.strokeColor = .clear
        jumpButton.name = "jumpButton"
        
        let jumpLabel = SKLabelNode(fontNamed: "Arial-Bold")
        jumpLabel.text = "JUMP"
        jumpLabel.fontSize = 14 // Уменьшаем размер текста
        jumpLabel.fontColor = .white
        jumpLabel.position = CGPoint(x: 0, y: -7)
        jumpButton.addChild(jumpLabel)
        
        addChild(jumpButton)
        
        // Новая кнопка boost - оранжевый круг
        let boostButton = SKShapeNode(circleOfRadius: buttonRadius)
        boostButton.position = CGPoint(x: size.width - 150, y: 70) // Левее кнопки jump
        boostButton.zPosition = 100
        boostButton.fillColor = UIColor(red: 139/255, green: 69/255, blue: 19/255, alpha: 1)
        boostButton.strokeColor = .clear
        boostButton.name = "boostButton"
        
        let boostLabel = SKLabelNode(fontNamed: "Arial-Bold")
        boostLabel.text = "BOOST"
        boostLabel.fontSize = 12 // Чуть меньше, чем у JUMP
        boostLabel.fontColor = .white
        boostLabel.position = CGPoint(x: 0, y: -7)
        boostButton.addChild(boostLabel)
        
        addChild(boostButton)
        
        // Кнопка назад (уменьшаем размер)
        backButton = SKSpriteNode(imageNamed: "arrow")
        backButton.position = CGPoint(x: 70, y: size.height - 50)
        backButton.zPosition = 100
        backButton.size = CGSize(width: 50, height: 50) // Было 60x60
        backButton.name = "backButton"
        addChild(backButton)
        
        // Кнопка рестарта (уменьшаем размер)
        restartButton = SKShapeNode(circleOfRadius: 25) // Было 30
        restartButton.position = CGPoint(x: 130, y: size.height - 50) // Подвигаем из-за уменьшения
        restartButton.zPosition = 100
        restartButton.fillColor = UIColor(red: 139/255, green: 69/255, blue: 19/255, alpha: 1)
        restartButton.strokeColor = .clear
        restartButton.name = "restartButton"
        
        let restartLabel = SKLabelNode(fontNamed: "Arial-Bold")
        restartLabel.text = "↻"
        restartLabel.fontSize = 25 // Было 30
        restartLabel.fontColor = .white
        restartLabel.position = CGPoint(x: 0, y: -10)
        restartButton.addChild(restartLabel)
        
        addChild(restartButton)
        
        // Счетчик расстояния (можно уменьшить немного)
        distanceLabel = SKLabelNode(fontNamed: "Arial-Bold")
        distanceLabel.fontSize = 22 // Было 24
        distanceLabel.fontColor = .white
        distanceLabel.position = CGPoint(x: size.width/2, y: size.height - 50)
        distanceLabel.zPosition = 100
        distanceLabel.text = "Distance: 0m"
        addChild(distanceLabel)
    }

    private func setupTournament() {
        for i in 0..<2 {
            let laneIndex = i == 0 ? 0 : 2
            let horse = SKSpriteNode(imageNamed: "horse_lightning") // или другой скин для соперников
            horse.position = CGPoint(x: size.width * 0.15, y: lanes[laneIndex])
            horse.zPosition = 5
            horse.size = CGSize(width: 80, height: 80)
            addChild(horse)
            otherHorses.append(horse)
        }
    }

    private func startGeneratingObstacles() {
        let wait = SKAction.wait(forDuration: 1.5)
        let generate = SKAction.run { [weak self] in
            self?.generateObstacle()
        }
        let sequence = SKAction.sequence([wait, generate])
        run(SKAction.repeatForever(sequence), withKey: "obstacleGeneration")
    }
    
    private func generateObstacle() {
        let obstacleType = ObstacleType.allCases.randomElement()!
        let lane = Int.random(in: 0..<3)
        
        let obstacle = SKSpriteNode(imageNamed: obstacleType.imageName)
        obstacle.position = CGPoint(x: size.width + 50, y: lanes[lane])
        obstacle.zPosition = 5
        obstacle.size = CGSize(width: 50, height: 50)
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = obstacleCategory
        obstacle.physicsBody?.contactTestBitMask = horseCategory
        obstacle.physicsBody?.collisionBitMask = 0
        
        addChild(obstacle)
        obstacles.append(obstacle)
        
        let moveDuration = 4.0
        let move = SKAction.moveTo(x: -100, duration: moveDuration)
        let remove = SKAction.removeFromParent()
        obstacle.run(SKAction.sequence([move, remove])) { [weak self] in
            if let index = self?.obstacles.firstIndex(of: obstacle) {
                self?.obstacles.remove(at: index)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameOver { return }
        
        distance += baseSpeed * CGFloat(0.00016)
        distanceLabel.text = "Distance: \(Int(distance))m"
        
        if distance >= levelDistance {
            finishGame(didWin: true)
            return
        }
        
        let backgroundSpeed = baseSpeed * 0.5
        backgroundNode.position.x -= backgroundSpeed * 0.016
        backgroundNode2.position.x -= backgroundSpeed * 0.016
        
        if backgroundNode.position.x <= -size.width/2 {
            backgroundNode.position.x = backgroundNode2.position.x + size.width
        }
        if backgroundNode2.position.x <= -size.width/2 {
            backgroundNode2.position.x = backgroundNode.position.x + size.width
        }
        
        if isBoosting {
            stamina -= 1
            if stamina <= 0 {
                isBoosting = false
            }
        } else {
            stamina = min(stamina + 0.2, 100)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if gameOver {
            if let retryButton = childNode(withName: "retryButton"), retryButton.contains(location) {
                restartGame()
                return
            }
            
            if let menuButton = childNode(withName: "menuButton"), menuButton.contains(location) {
                shouldDismiss = true
//                returnToMenu()
                return
            }
        }

        // Обработка нажатия на кнопку boost
        if let boostButton = childNode(withName: "boostButton"), boostButton.contains(location) {
            boost()
            return
        }

        if jumpButton.contains(location) {
            jump()
            return
        }
        
        if backButton.contains(location) {
            shouldDismiss = true
//            returnToMenu()
            return
        }
        
        if restartButton.contains(location) {
            
            restartGame()
            return
        }
        
        if gameOver, let menuButton = childNode(withName: "menuButton"), menuButton.contains(location) {
            shouldDismiss = true
            return
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, !isJumping else { return }
        
        // Если режим не турнир, разрешаем свайпы
        if !isTournament {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            let deltaY = location.y - previousLocation.y
            
            if abs(deltaY) > 30 {
                if deltaY > 0 && currentLane < 2 {
                    // Свайп вверх
                    currentLane += 1
                    moveLane(to: currentLane)
                } else if deltaY < 0 && currentLane > 0 {
                    // Свайп вниз
                    currentLane -= 1
                    moveLane(to: currentLane)
                }
            }
        }
    }

    private func moveLane(to lane: Int) {
        let moveAction = SKAction.moveTo(y: lanes[lane], duration: 0.2)
        horseNode.run(moveAction)
    }
    
    private func jump() {
        guard !isJumping else { return }
        
        isJumping = true
        
        // Уменьшаем высоту прыжка (было 100, стало 70)
        let jumpHeight: CGFloat = 90
        
        // Увеличиваем длительность прыжка (было 0.4, стало 0.6)
        let jumpUpDuration: TimeInterval = 0.6
        let jumpDownDuration: TimeInterval = 0.6
        
        let jumpUp = SKAction.moveBy(x: 0, y: jumpHeight, duration: jumpUpDuration)
        jumpUp.timingMode = .easeOut // Плавное замедление в верхней точке
        
        let jumpDown = SKAction.moveBy(x: 0, y: -jumpHeight, duration: jumpDownDuration)
        jumpDown.timingMode = .easeIn // Плавное ускорение при падении
        
        let jumpSequence = SKAction.sequence([jumpUp, jumpDown])
        
        horseNode.run(jumpSequence) { [weak self] in
            self?.isJumping = false
        }
        
        // Добавляем анимацию наклона лошади при прыжке
        let tiltUp = SKAction.rotate(toAngle: -0.1, duration: jumpUpDuration/2)
        let tiltDown = SKAction.rotate(toAngle: 0.1, duration: jumpUpDuration/2)
        let tiltSequence = SKAction.sequence([tiltUp, tiltDown])
        horseNode.run(tiltSequence)
    }
    
    private func boost() {
        guard !isBoosting && stamina >= 20 else { return } // Минимальный порог выносливости
        
        isBoosting = true
        baseSpeed = min(baseSpeed * 1.5, maxSpeed)
    }

    private func finishGame(didWin: Bool) {
        gameOver = true
        removeAction(forKey: "obstacleGeneration")
        
        let reward = isTournament ? (didWin ? 200 : 0) : 50
        
        if didWin && reward > 0 {
            gameState.addCoins(reward)
        }
        
        // Фоновая картинка
        let resultBackground = SKSpriteNode(imageNamed: "bg")
        resultBackground.position = CGPoint(x: size.width/2, y: size.height/2)
        resultBackground.zPosition = 1000
        resultBackground.size = CGSize(width: size.width, height: size.height)
        resultBackground.name = "bg"
        addChild(resultBackground)
        
        // Текст результата
        let resultText = didWin ? "YOU WIN" : "YOU LOSE"
        let resultLabel = SKLabelNode(fontNamed: "Arial-Bold")
        resultLabel.text = resultText
        resultLabel.fontSize = 60
        resultLabel.fontColor = .white
        resultLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        resultLabel.zPosition = 1001
        resultLabel.name = "resultLabel"
        addChild(resultLabel)
        
        // Награда (только при победе)
        if didWin {
            let coinNode = SKSpriteNode(imageNamed: "coin")
            coinNode.position = CGPoint(x: size.width/2, y: size.height/2 + 20)
            coinNode.zPosition = 1001
            coinNode.setScale(1.5)
            addChild(coinNode)
            
            let rewardLabel = SKLabelNode(fontNamed: "Arial-Bold")
            rewardLabel.text = "+\(reward)"
            rewardLabel.fontSize = 40
            rewardLabel.fontColor = .yellow
            rewardLabel.position = CGPoint(x: size.width/2 + 50, y: size.height/2 + 20)
            rewardLabel.zPosition = 1001
            rewardLabel.name = "rewardLabel"
            addChild(rewardLabel)
        }
        
        // Кнопка RETRY
        let retryButton = SKSpriteNode(color: .clear, size: CGSize(width: 200, height: 60))
        retryButton.position = CGPoint(x: size.width/2, y: size.height/2 - 50)
        retryButton.zPosition = 1001
        retryButton.name = "retryButton"
        
        let retryBackground = SKSpriteNode(imageNamed: "image")
        retryBackground.size = CGSize(width: 160, height: 90)
        retryButton.addChild(retryBackground)
        
        let retryLabel = SKLabelNode(fontNamed: "Arial-Bold")
        retryLabel.text = "RETRY"
        retryLabel.fontSize = 30
        retryLabel.fontColor = .white
        retryLabel.position = CGPoint(x: 0, y: -5)
        retryLabel.zPosition = 1001
        retryButton.addChild(retryLabel)
        
        addChild(retryButton)
        
        // Кнопка MENU
        let menuButton = SKSpriteNode(color: .clear, size: CGSize(width: 200, height: 60))
        menuButton.position = CGPoint(x: size.width/2, y: size.height/2 - 150)
        menuButton.zPosition = 1001
        menuButton.name = "menuButton"
        
        let menuBackground = SKSpriteNode(imageNamed: "image")
        menuBackground.size = CGSize(width: 160, height: 90)
        menuButton.addChild(menuBackground)
        
        let menuLabel = SKLabelNode(fontNamed: "Arial-Bold")
        menuLabel.text = "MENU"
        menuLabel.fontSize = 30
        menuLabel.fontColor = .white
        retryLabel.position = CGPoint(x: 0, y: -5)
        menuLabel.zPosition = 1001
        menuButton.addChild(menuLabel)
        
        addChild(menuButton)
        
        // Анимация появления
        resultBackground.alpha = 0
        resultLabel.alpha = 0
        retryButton.alpha = 0
        menuButton.alpha = 0
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        resultBackground.run(fadeIn)
        resultLabel.run(SKAction.sequence([SKAction.wait(forDuration: 0.2), fadeIn]))
        retryButton.run(SKAction.sequence([SKAction.wait(forDuration: 0.4), fadeIn]))
        menuButton.run(SKAction.sequence([SKAction.wait(forDuration: 0.6), fadeIn]))
    }
    
    
//    private func returnToMenu() {
//        if let view = self.view {
//            let menuView = MainMenuView()
//            let hostingController = UIHostingController(rootView: menuView)
//            
//            UserDefaults.standard.set(false, forKey: "showWinView")
//            
//            // Сбрасываем состояние игры
//            self.gameOver = false
//            
//            view.window?.rootViewController?.dismiss(animated: true) {
//                view.window?.rootViewController?.present(hostingController, animated: true)
//            }
//        }
//    }

    private func restartGame() {
        if UIDevice.current.userInterfaceIdiom == .pad{
            shouldDismiss = true
        } else {
            if let view = self.view {
                UserDefaults.standard.set(false, forKey: "showWinView")
                
                let sceneView = GameSceneView(gameState: gameState, selectedHorse: selectedHorse, horseSkin: horseSkin, backgroundImage: backgroundImage, isTournament: isTournament)
                let hostingController = UIHostingController(rootView: sceneView)
                
                view.window?.rootViewController?.dismiss(animated: false) {
                    view.window?.rootViewController?.present(hostingController, animated: false)
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == horseCategory | obstacleCategory {
            // Теперь умираем при любом столкновении, даже во время прыжка
            finishGame(didWin: false)
        }
    }
}
