//
//  ViewController.swift
//  testproject
//
//  Created by Simon Butenko on 05.01.2024.
//

import UIKit


fileprivate var counter = Counter()

final class Counter {
    fileprivate var value = 0
    fileprivate var history: [String] = []
    
    fileprivate func increment() {
        value += 1
        history.append("[\(getDate())] Увеличение до \(value)")
    }
    
    fileprivate func decrement() {
        value -= 1
        history.append("[\(getDate())] Уменьшение до \(value)")
    }
    
    fileprivate func clear() {
        value = 0
        history.append("[\(getDate())] Сброс до 0")
    }
    
    private func getDate() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        return formatter.string(from: currentDateTime)
    }
}


final class HistoryViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "История"
        view.backgroundColor = .systemBackground
        
        setupViews()
    }
    
    private func setupViews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counter.history.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        
        let reversedIndex = counter.history.count - 1 - indexPath.row
        cell.textLabel?.text = counter.history[reversedIndex]
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    fileprivate func showSheet(view: UIViewController) {
        let navigationController = UINavigationController(rootViewController: self)
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [ .medium(), .large()]
        }
        
        view.present(navigationController, animated: true)
    }
}

final class ViewController: UIViewController {
    @IBOutlet weak var counterLabel: UILabel!
    
    private var historyViewController: HistoryViewController = HistoryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCounterLabel()
    }
    
    private func updateCounterLabel() {
        counterLabel.text = "\(counter.value)"
    }
    
    @IBAction private func clickIncrementButton(_ sender: Any) {
        counter.increment()
        updateCounterLabel()
    }
    
    @IBAction private func clickDecrementButton(_ sender: Any) {
        counter.decrement()
        updateCounterLabel()
    }
    
    @IBAction private func clickClearButton(_ sender: Any) {
        counter.clear()
        updateCounterLabel()
    }
    
    @IBAction private func clickHistoryButton(_ sender: Any) {
        historyViewController.showSheet(view: self)
    }
}
