//
//  SettingsView.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-16.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Current Probability Threshold: " + String(format: "%.0f", self.viewModel.probabilityThreshold * 100) + "%")
                    Slider(value: $viewModel.probabilityThreshold, in: 0.1...0.95, step: 0.01, label: { Text("Probability Threshold") }, minimumValueLabel: { Text("10%") }, maximumValueLabel: { Text("95%") })
                } header: {
                    Text("Probability Threshold")
                } footer: {
                    Text("Sets the probability for the ML model to classify a hand gesture. Cookture will only perform the corresponding actions when the probability is above this threshold. Higher threshold will result in a more accurate gesture classification, but may also result in less natural interactions. The minimum threshold is 10%, and the maximum is 95%.")
                }
                
                Section {
                    ForEach(CooktureHandActionClassifierResult.allCases) { result in
                        var value: Int {
                            switch result {
                            case .swipeup:
                                return self.viewModel.swipeUpScore
                            case .swipeDown:
                                return self.viewModel.swipeDownScore
                            case .openFist:
                                return self.viewModel.openFistScore
                            case .closeFist:
                                return self.viewModel.closeFistScore
                            }
                        }
                        
                        Text(result.rawValue + ": " + "\(value)")
                    }
                } header: {
                    Text("Classification History")
                } footer: {
                    Text("These are statistics and history of gesture classifications. They represent how many classifications were made for each class.")
                }
                
                Section {
                    Button("Reset Probability Threshold to Default") { self.viewModel.resetProbabilityThresholdToDefault() }
                    Button("Reset Classification History") { self.viewModel.resetClassificationHistory() }
                } header: {
                    Text("Danger Zone")
                } footer: {
                    Text("Reset Probability to Default: Will reset the probability threshold to its default value of 80%. \nReset Classification History: Will reset all history of gesture classifications.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") { self.viewModel.hideSettingsView() }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ViewModel())
}
