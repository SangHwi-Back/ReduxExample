//
//  ViewController.swift
//  ReduxExample
//
//  Created by 백상휘 on 4/26/24.
//

import UIKit
import RxSwift

class ViewController: UIViewController, ReduxView {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var stepperLabel: UILabel!
    @IBOutlet weak var countingStepper: UIStepper!
    @IBOutlet weak var tableView: UITableView!
    
    var reducer: MainReducer = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reducer.actionCommit
            .bind { currentState in
                self.stepperLabel.text = "\(currentState.stepperValue)"
                
                if currentState.models.count != self.tableView.numberOfRows(inSection: 0) {
                    self.tableView.reloadData()
                }
            }
            .disposed(by: reducer.disposeBag)
        
        start()
    }
    
    @IBAction func countingStepperChanged(_ sender: UIStepper) {
        reducer.actionSubject.onNext(
            .stepperChanged(Int(sender.value) > reducer.state.stepperValue ? .plus : .minus)
        )
    }
    
    @IBAction func asyncWorkStartTouchUpInside(_ sender: UIButton) {
        reducer.actionSubject.onNext(.randomTable)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reducer.state.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainTableViewCell.self), for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = reducer.state.models[indexPath.row]
        
        return cell
    }
}

extension ViewController: UITableViewDelegate { 
    
}
