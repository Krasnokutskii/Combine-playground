//
//  LoginViewModel.swift
//  CombineInUIkitMVVM
//
//  Created by Yaroslav Krasnokutskiy on 4.3.23..
//

import Foundation
import Combine

class LoginViewModel {
    @Published var name: String = "Welcome"
    @Published var timerCount = 0
       
    var cancellable: Set<AnyCancellable> = []
    func startTimer(){
        Timer.publish(every: 1, on: RunLoop.main, in: .common)
            .autoconnect()
            .receive(on: RunLoop.main)
            .sink {[weak self] _ in
                self?.timerCount += 1
            }
            .store(in: &cancellable)
    }
    
    func setNewName(name: String) {
        self.name = name
    }
}
