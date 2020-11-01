//
//  TraficViewModel.swift
//  TrafficLight
//
//  Created by Артем Галиев on 30.10.2020.
//

import Foundation
import RxCocoa
import RxSwift

protocol TraficViewModelProtocol {
    var isRedLightOnNow: Driver<Bool> { get }
    var isYellowPastRedLightOnNow: Driver<Bool> { get }
    var isGreenLightOnNow: Driver<Bool> { get }
    var isYellowPastGreenLightOnNow: Driver<Bool> { get }
    
    func startTrafficLights()
}

class TraficViewModel: TraficViewModelProtocol {
    
    private var redLightOnNow = BehaviorRelay<Bool>(value: false)
    private var yellowPastRedLightOnNow = BehaviorRelay<Bool>(value: false)
    private var greenLightOnNow = BehaviorRelay<Bool>(value: false)
    private var yellowPastGreenLightOnNow = BehaviorRelay<Bool>(value: false)
    
    private let disposedBag = DisposeBag()
    public var traficColor: TraficColor = .yellowPastGreen
    private var mainTimer = Timer()
    private var nextRedAndGreenTimeInterval: TimeInterval = 5
    private var nextYellowTimeInterval: TimeInterval = 1
    
    var isRedLightOnNow: Driver<Bool> {
        return redLightOnNow.asDriver()
    }
    var isYellowPastRedLightOnNow: Driver<Bool> {
        return yellowPastRedLightOnNow.asDriver()
    }
    var isGreenLightOnNow: Driver<Bool> {
        return greenLightOnNow.asDriver()
    }
    var isYellowPastGreenLightOnNow: Driver<Bool> {
        return yellowPastGreenLightOnNow.asDriver()
    }
    
    //Главный метод
    public func startTrafficLights() {
        startTimer(currentTimeInterval: 0)

    }

    //Переключатель светофора
    @objc func actionTimer() {
        switch traficColor {
        case .red:
            traficColor = .yellowPastRed
            startTimer(currentTimeInterval: nextYellowTimeInterval)
            yellowPastRedLightOnNow.accept(true)
            redLightOnNow.accept(false)
        case .yellowPastRed:
            traficColor = .green
            startTimer(currentTimeInterval: nextRedAndGreenTimeInterval)
            greenLightOnNow.accept(true)
            yellowPastRedLightOnNow.accept(false)
        case .green:
            startTimer(currentTimeInterval: nextYellowTimeInterval)
            traficColor = .yellowPastGreen
            yellowPastGreenLightOnNow.accept(true)
            greenLightOnNow.accept(false)
        case .yellowPastGreen:
            startTimer(currentTimeInterval: nextRedAndGreenTimeInterval)
            traficColor = .red
            redLightOnNow.accept(true)
            yellowPastGreenLightOnNow.accept(false)
        }
    }
    
    //Таймер светофора
    private func startTimer(currentTimeInterval: TimeInterval) {
        mainTimer.invalidate()
        mainTimer = Timer.scheduledTimer(timeInterval: currentTimeInterval, target: self, selector: #selector(actionTimer), userInfo: nil, repeats: true)
    }
}
