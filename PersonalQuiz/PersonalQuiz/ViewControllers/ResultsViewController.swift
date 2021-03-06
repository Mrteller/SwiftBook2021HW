//
//  ResultsViewController.swift
//  PersonalQuiz
//
//  Created by brubru on 20.12.2021.
//

import UIKit

class ResultsViewController: UIViewController {
    
    
    // 1. Передать сюда массив с ответами
    // 2. Определить наиболее часто встречающийся тип животного
    // 3. Отобразить результат в соответсвии с этим животным
    // 4. Избавиться от кнопки возврата назад на экран результатов
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultDescriptionLabel: UILabel!
    
    // MARK: - Public vars
    
    // I would rather pass just an array of types to make the controller more universal
    // like this `var answers = [String]() {`
    var answers = [Answer]() {
        didSet {
            guard resultLabel != nil && resultDescriptionLabel != nil else { return }
            updateResults()
        }
    }
    // Should be `allAnsweredQuestions` instead provided by previous screen.
    // Because some questions could have been skipped.
    var allQuestions = Question.getQuestions()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        updateResults()
    }
    
    // MARK: - Private funcs
    
    private func updateResults() {
        let resultsScore = Dictionary(answers.map{ ($0.type, 1) }) { $0 + $1 }
        
#if DEBUG
        answers.forEach{ print("\"\($0.title)\" counts for \($0.type.rawValue)") }
        resultsScore.forEach{ print("\($0.key) score is \($0.value)")}
        
        // Alernative way to calculate the highest score answer
        let countedSet = NSCountedSet(array: answers.map(\.type))
        if let altResultWithHigherstScore = countedSet.allObjects.map({ ($0 as! AnimalType, countedSet.count(for: $0)) }).sorted(by: { $0.1 > $1.1 }).first {
            print("altResultWithHigherstScore (\(altResultWithHigherstScore.0.rawValue), \(altResultWithHigherstScore.1))")
        }
#endif
        
        if let resultWithHigherstScore = resultsScore.max(by: { $0.value < $1.value }) {
            guard let possiblePoints = totalPossiblePoints(for: resultWithHigherstScore.0) else { return }
            let percents = lrint((Double(resultWithHigherstScore.value) / Double(possiblePoints)) * 100)
            // Todo: use percents instead of points
            resultLabel.text = "Вы \(resultWithHigherstScore.key.rawValue)\n на \(String(format: NSLocalizedString("%d percent(s)", comment: ""), percents))"
            resultDescriptionLabel.text = resultWithHigherstScore.key.definition
        }
    }
    
    private func totalPossiblePoints(for type: AnimalType) -> Int? {
        let allAnswers = allQuestions.flatMap{ $0.answers }
        let answerCount = Dictionary(allAnswers.map{ ($0.type, 1) }) { $0 + $1 }
        return answerCount[type]
    }
        
}
