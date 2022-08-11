//
//  ContentView.swift
//  LetsWalk_Exp
//
//  Created by Shak Feizi on 8/11/22.
//

import SwiftUI
import CoreMotion


struct ContentView: View {
    @State private var steps: Int?
    @State private var distance: Double?
    
    private let pedometer: CMPedometer = CMPedometer()
    
    private var isPedameterAvailable: Bool {
        return CMPedometer.isPedometerEventTrackingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable()
    }
    
    var body: some View {
        Text(steps != nil ? "\(steps!)" : "")
        Text(distance != nil ? "\(distance!)" : "")
            .padding()
            .onAppear {
                initializePedometer()
            }
    }
    
    private func initializePedometer() {
        if isPedameterAvailable {
            guard let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return }
            pedometer.queryPedometerData(from: startDate, to: Date()) { data, error in
                guard let data = data, error == nil else { return }
                self.steps = data.numberOfSteps.intValue
                self.distance = data.distance?.doubleValue
                distanceTypeConverter(data: data)
            }
        }
    }
    
    private func distanceTypeConverter(data: CMPedometerData) {
        self.steps = data.numberOfSteps.intValue
        guard let pedometerDistance = data.distance else { return }
        let distanceInMeter = Measurement(value: pedometerDistance.doubleValue, unit: UnitLength.meters)
        self.distance = distanceInMeter.converted(to: .miles).value
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
