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
        #endif
        
        if let resultWithHigherstScore = resultsScore.map({ ($0.key, $0.value) })
            .sorted(by: { $0.1 > $1.1 })
            .first {
            resultLabel.text = "Вы \(resultWithHigherstScore.0.rawValue)\n на " + String(format: NSLocalizedString("%d point(s)", comment: ""), resultWithHigherstScore.1)
            resultDescriptionLabel.text = resultWithHigherstScore.0.definition
        }
        
    }
        
}
