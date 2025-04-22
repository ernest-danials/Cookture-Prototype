//
//  CookingView.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-08.
//

import SwiftUI

struct CookingView: View {
    @EnvironmentObject var viewModel: ViewModel
    @StateObject var subViewModel = CookingViewModel()
    
    let recipe: Recipe
    
    @State private var idleTimer: Timer? = nil
    private let idleDelay: TimeInterval = 1.5
    
    @State private var timer: Timer? = nil
    @State private var remainingTime: Int? = nil
    @State private var isTimerRunning: Bool = false
    
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            HStack(alignment: .bottom) {
                if let step = self.recipe.steps.filter({ $0.id == self.subViewModel.currentStepID }).first {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Current Step")
                            .customFont(size: 25, weight: .medium)
                        
                        Text("\(step.order)/\(self.recipe.steps.count)")
                            .foregroundStyle(.white)
                            .customFont(size: 23, weight: .bold, design: .rounded)
                            .contentTransition(.numericText(value: Double(step.order)))
                            .padding(25)
                            .background(Color.accentColor)
                            .clipShape(.circle)
                    }.frame(maxWidth: 110)
                }
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(recipe.steps) { step in
                            VStack {
                                if let imageName = step.imageName {
                                    Image(imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 600)
                                        .cornerRadius(30, corners: .allCorners)
                                        .padding(.top)
                                }
                                
                                Text("\(step.instruction)")
                                    .customFont(size: 30, weight: .bold)
                                    .multilineTextAlignment(.center)
                                    .padding(step.imageName != nil ? [.horizontal, .bottom] : .all)
                                    .padding(.horizontal)
                                    .padding(.top, step.imageName != nil ? 15 : 0)
                            }
                            .containerRelativeFrame(.vertical, count: 1, spacing: 20)
                            .alignView(to: .center)
                            .overlay(alignment: .topLeading) {
                                Text("\(step.order)")
                                    .foregroundStyle(.white)
                                    .customFont(size: 18, weight: .medium, design: .rounded)
                                    .padding()
                                    .background(Color.accentColor)
                                    .clipShape(.circle)
                            }
                            .overlay(alignment: .bottomTrailing) {
                                if let timerDuration = step.timerDuration {
                                    HStack {
                                        Image(systemName: "clock.fill")
                                            .customFont(size: 25, weight: .medium)
                                            .foregroundStyle(Color.accentColor)
                                        
                                        if isTimerRunning, let time = remainingTime {
                                            let minutes = time / 60
                                            let seconds = time % 60
                                            
                                            Text(String(format: "%02d:%02d", minutes, seconds))
                                                .customFont(size: 25, weight: .semibold)
                                                .contentTransition(.numericText(countsDown: true))
                                        } else {
                                            Text("\(timerDuration):00")
                                                .customFont(size: 25, weight: .semibold)
                                        }
                                    }
                                    .padding(20)
                                    .background(Material.ultraThin)
                                    .cornerRadius(20, corners: .allCorners)
                                    .padding(10)
                                    .onTapGesture {
                                        if self.isTimerRunning {
                                            self.stopTimer()
                                        } else {
                                            self.startTimer(from: timerDuration * 60)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Material.ultraThin)
                            .cornerRadius(20, corners: .allCorners)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.7)
                            }
                            .id(step.id)
                        }
                    }.scrollTargetLayout()
                }
                .prioritiseScaleButtonStyle()
                .frame(minWidth: 600)
                .scrollIndicators(.hidden)
                .contentMargins(100, for: .scrollContent)
                .scrollTargetBehavior(.paging)
                .onChange(of: self.subViewModel.currentStepID) { oldValue, newValue in
                    if oldValue != newValue && oldValue != nil {
                        withAnimation(.spring) { proxy.scrollTo(newValue) }
                    }
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 1)
                        .onChanged { _ in cancelIdleTimer() }
                        .onEnded { _ in scheduleIdleScroll(with: proxy) }
                )
                
                controlButton
            }
            .padding(.horizontal)
            .overlay(alignment: .top) {
                if !self.subViewModel.classificationLabel.isEmpty {
                    let probabilityString = String(format: "%.0f", (self.subViewModel.classificationLabelProbabilities[self.subViewModel.classificationLabel] ?? 0) * 100)
                    
                    Text("Detected Hand Gesture: " + self.subViewModel.classificationLabel + ", with probability of " + probabilityString + "%")
                        .customFont(size: 18, weight: .semibold)
                        .contentTransition(.numericText(value: self.subViewModel.classificationLabelProbabilities[self.subViewModel.classificationLabel] ?? 0))
                        .padding()
                        .background(Material.ultraThin)
                        .cornerRadius(15, corners: .allCorners)
                        .padding()
                }
            }
            .onChange(of: self.subViewModel.currentStepID) { _, _ in
                stopTimer()
                self.remainingTime = nil
            }
            .onChange(of: self.subViewModel.classificationLabelProbabilities) { oldValue, newValue in
                if let topResult = CooktureHandActionClassifierResult(rawValue: self.subViewModel.classificationLabel), let oldProbability = oldValue[topResult.rawValue], let newProbability = newValue[topResult.rawValue] {
                    if (topResult == .closeFist || topResult == .openFist) && newProbability > self.viewModel.fistProbabilityThreshold {
                        switch topResult {
                        case .swipeup:
                            print("Failed to parse classification results.")
                        case .swipeDown:
                            print("Failed to parse classification results.")
                        case .openFist:
                            if let step = self.recipe.steps.first(where: { $0.id == self.subViewModel.currentStepID }), let duration = step.timerDuration {
                                self.startTimer(from: duration * 60)
                            }
                            self.viewModel.openFistScore += 1
                        case .closeFist:
                            self.stopTimer()
                            self.viewModel.closeFistScore += 1
                        }
                    } else if (topResult == .swipeup || topResult == .swipeDown) && newProbability > self.viewModel.probabilityThreshold {
                        switch topResult {
                        case .swipeup:
                            self.subViewModel.moveStep(recipe: self.recipe, forward: true)
                            self.viewModel.swipeUpScore += 1
                        case .swipeDown:
                            self.subViewModel.moveStep(recipe: self.recipe, forward: false)
                            self.viewModel.swipeDownScore += 1
                        case .openFist:
                            print("Failed to parse classification results.")
                        case .closeFist:
                            print("Failed to parse classification results.")
                        }
                    }
                    
                    print("Updated CookingView with following classification results: " + topResult.rawValue + " with probability " + String(self.subViewModel.classificationLabelProbabilities[topResult.rawValue] ?? 0))
                } else {
                    print("Failed to parse classification results.")
                }
            }
        }.task {
            self.subViewModel.currentStepID = self.recipe.steps.first?.id
        }
    }
    
    private var controlButton: some View {
        VStack {
            Button {
                self.viewModel.hideCookingView()
            } label: {
                Image(systemName: "xmark")
                    .customFont(size: 27, weight: .bold)
                    .foregroundStyle(Color.accentColor)
                    .padding(20)
                    .background(Material.ultraThin)
                    .clipShape(.circle)
                    .padding(.top)
            }.scaleButtonStyle(scaleAmount: 0.97)
            
            Spacer()
            
            let isFirst = self.recipe.steps.first?.id == self.subViewModel.currentStepID
            let isLast = self.recipe.steps.last?.id == self.subViewModel.currentStepID
            
            Button {
                self.subViewModel.moveStep(recipe: recipe, forward: false)
            } label: {
                Image(systemName: "chevron.up")
                    .customFont(size: 30, weight: .bold)
                    .foregroundStyle(Color.accentColor)
                    .padding(20)
                    .background(Material.ultraThin)
                    .clipShape(.circle)
                    .opacity(isFirst ? 0.6 : 1)
            }
            .scaleButtonStyle(scaleAmount: 0.97)
            .disabled(isFirst)
            
            Button {
                self.subViewModel.moveStep(recipe: recipe, forward: true)
            } label: {
                Image(systemName: "chevron.down")
                    .customFont(size: 30, weight: .bold)
                    .foregroundStyle(Color.accentColor)
                    .padding(20)
                    .background(Material.ultraThin)
                    .clipShape(.circle)
                    .opacity(isLast ? 0.6 : 1)
            }
            .scaleButtonStyle(scaleAmount: 0.97)
            .disabled(isLast)
        }.frame(minWidth: 100, maxWidth: 110)
    }
    
    private func startTimer(from duration: Int) {
        guard !isTimerRunning else { return }
        withAnimation(.spring) {
            self.remainingTime = duration
            self.isTimerRunning = true
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let time = remainingTime, time > 0 {
                withAnimation(.spring) { remainingTime = time - 1 }
            } else {
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        withAnimation(.spring) { isTimerRunning = false }
    }
    
    private func scheduleIdleScroll(with scrollProxy: ScrollViewProxy) {
        cancelIdleTimer()
        
        idleTimer = Timer.scheduledTimer(withTimeInterval: idleDelay, repeats: false) { _ in
            Task { @MainActor in
                withAnimation { scrollProxy.scrollTo(self.subViewModel.currentStepID, anchor: .top) }
            }
        }
    }
    
    private func cancelIdleTimer() {
        idleTimer?.invalidate()
        idleTimer = nil
    }
}

#Preview {
    CookingView(CooktureData.recipeData.first!)
        .environmentObject(ViewModel())
}
