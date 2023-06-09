//
//  GameScene.swift
//  FunGenerate Shared
//
//  Created by Vladislav Balashov on 21.04.2023.
//

import SpriteKit

class GameScene: SKScene {

    var snake: SKSpriteNode!
    var food: SKSpriteNode!

    var snakeBody = [SKSpriteNode]()
    var currentDirection: Direction = .right
    
    static func newGameScene() -> SKScene? {
        // Create and configure the scene.
        let scene = GameScene(size: CGSize(width: 640, height: 480))
        scene.scaleMode = .aspectFill
        return scene
    }

    override func didMove(to view: SKView) {
        backgroundColor = .white
        createSnake()
        createFood()
    }

    override func update(_ currentTime: TimeInterval) {
        moveSnake()
    }

    func createSnake() {
        let head = SKSpriteNode(color: .green, size: CGSize(width: 20, height: 20))
        head.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(head)
        snakeBody.append(head)

        for i in 1...3 {
            let body = SKSpriteNode(color: .green, size: CGSize(width: 20, height: 20))
            body.position = CGPoint(x: head.position.x - CGFloat(i) * 20, y: head.position.y)
            addChild(body)
            snakeBody.append(body)
        }

        snake = head
    }

    func createFood() {
        food = SKSpriteNode(color: .red, size: CGSize(width: 20, height: 20))
        food.position = CGPoint(x: CGFloat.random(in: 0...(frame.width-20)), y: CGFloat.random(in: 0...(frame.height-20)))
        addChild(food)
    }

    func moveSnake() {
        var newPosition: CGPoint
        switch currentDirection {
        case .up:
            newPosition = CGPoint(x: snake.position.x, y: snake.position.y + 20)
        case .down:
            newPosition = CGPoint(x: snake.position.x, y: snake.position.y - 20)
        case .left:
            newPosition = CGPoint(x: snake.position.x - 20, y: snake.position.y)
        case .right:
            newPosition = CGPoint(x: snake.position.x + 20, y: snake.position.y)
        }

        let newHead = SKSpriteNode(color: .green, size: CGSize(width: 20, height: 20))
        newHead.position = newPosition
        addChild(newHead)
        snakeBody.insert(newHead, at: 0)
        snake.removeFromParent()
        snake = newHead
        checkCollision()
    }

    func checkCollision() {
        if snake.intersects(food) {
            food.removeFromParent()
            createFood()
            let body = SKSpriteNode(color: .green, size: CGSize(width: 20, height: 20))
            body.position = snakeBody.last!.position
            addChild(body)
            snakeBody.append(body)
        } else if snake.position.x > frame.width || snake.position.x < 0 || snake.position.y > frame.height || snake.position.y < 0 {
            // Game Over
        } else {
            for i in 1..<snakeBody.count {
                if snake.intersects(snakeBody[i]) {
                    // Game Over
                    break
                }
            }
        }
    }

    enum Direction {
        case up
        case down
        case left
        case right
    }

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 126: // Up Arrow
            if currentDirection != .down {
                currentDirection = .up
            }
        case 125: // Down Arrow
            if currentDirection != .up {
                currentDirection = .down
            }
        case 123: // Left Arrow
            if currentDirection != .right {
                currentDirection = .left
            }
        case 124: // Right Arrow
            if currentDirection != .left {
                currentDirection = .right
            }
        default:
            break
        }
    }
}
