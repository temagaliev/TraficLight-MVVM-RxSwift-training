//
//  ViewController.swift
//  TrafficLight
//
//  Created by Артем Галиев on 23.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

class TrafficViewController: UIViewController {
    
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    var viewModel: TraficViewModelProtocol!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TraficViewModel()
        startVisualSettings()
        switchTraficLightObservers()
    }
    
    // Наблюдатель за переключениями
    private func switchTraficLightObservers() {
        viewModel.isRedLightOnNow.drive { (isNow) in
            if isNow == true {
                self.redView.backgroundColor = .red
                self.yellowView.backgroundColor = .gray
                self.greenView.backgroundColor = .gray
            }
        }.disposed(by: disposeBag)
        
        viewModel.isYellowPastRedLightOnNow.drive { (isNow) in
            if isNow == true {
                self.redView.backgroundColor = .red
                self.yellowView.backgroundColor = .yellow
                self.greenView.backgroundColor = .gray
            }
        }.disposed(by: disposeBag)
        
        viewModel.isGreenLightOnNow.drive { (isNow) in
            if isNow == true {
                self.redView.backgroundColor = .gray
                self.yellowView.backgroundColor = .gray
                self.greenView.backgroundColor = .green
            }
        }.disposed(by: disposeBag)
        
        viewModel.isYellowPastGreenLightOnNow.drive { (isNow) in
            if isNow == true {
                self.redView.backgroundColor = .gray
                self.yellowView.backgroundColor = .yellow
                self.greenView.backgroundColor = .gray
            }
        }.disposed(by: disposeBag)
    }
    
    //Кнопка запуска
    @IBAction func startTrafficLights(_ sender: UIButton) {
        viewModel.startTrafficLights()
    }
    
    //Стартовые настройки элементов
    private func startVisualSettings() {
        redView.layer.cornerRadius = redView.frame.width / 2
        redView.backgroundColor = .red
        yellowView.layer.cornerRadius = yellowView.frame.width / 2
        yellowView.backgroundColor = .yellow
        greenView.layer.cornerRadius = greenView.frame.width / 2
        greenView.backgroundColor = .green
        startButton.layer.cornerRadius = 5
        mainView.layer.cornerRadius = 30
    }
}
