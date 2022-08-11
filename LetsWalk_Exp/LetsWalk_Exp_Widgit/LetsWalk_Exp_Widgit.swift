//
//  LetsWalk_Exp_Widgit.swift
//  LetsWalk_Exp_Widgit
//
//  Created by Shak Feizi on 8/11/22.
//

import WidgetKit
import SwiftUI
import Intents


struct StepEntry: TimelineEntry {
    var date: Date = Date()
    var steps: Int
}

struct Provider: TimelineProvider {
    typealias Entry = StepEntry
    
    @AppStorage("stepCount", store: UserDefaults(suiteName: "group.com.ShakFeizi.LetsWalk_Exp")) var stepCount: Int = 0
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = StepEntry(steps: stepCount)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = StepEntry(steps: stepCount)
        completion(Timeline(entries: [entry], policy: .atEnd))
    }
    
    func placeholder(in context: Context) -> StepEntry {
        return StepEntry(steps: stepCount)
    }
}

struct StepView: View {
    let entry: Provider.Entry
    
    var body: some View {
        Text("\(entry.steps)")
    }
}

@main
struct StepWidget: Widget {
    private let kind = "StepWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StepView(entry: entry)
        }
    }
}
