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
    
    @State private var currentStepID: UUID? = nil
    
    @State private var idleTimer: Timer? = nil
    private let idleDelay: TimeInterval = 1.5
    
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                HStack(alignment: .bottom) {
                    if let step = self.recipe.steps.filter({ $0.id == currentStepID }).first {
                        VStack(alignment: .leading, spacing: 15) {
                            Text(self.subViewModel.classificationLabel)
                            
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
                                            .frame(width: min(geo.size.width - 400, 600))
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
                                            
                                            Text("\(timerDuration)")
                                                .customFont(size: 22, weight: .medium)
                                        }
                                        .padding(20)
                                        .background(Material.ultraThin)
                                        .cornerRadius(20, corners: .allCorners)
                                        .padding(10)
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
                    .frame(minWidth: min(geo.size.width - 200, 600))
                    .scrollIndicators(.hidden)
                    .contentMargins(100, for: .scrollContent)
                    .scrollTargetBehavior(.paging)
                    .onChange(of: self.currentStepID) { oldValue, newValue in
                        if oldValue != newValue && oldValue != nil {
                            withAnimation(.spring) { proxy.scrollTo(newValue) }
                        }
                    }
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 1)
                            .onChanged { _ in cancelIdleTimer() }
                            .onEnded { _ in scheduleIdleScroll(with: proxy) }
                    )
                    
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
                        
                        let isFirst = self.recipe.steps.first?.id == currentStepID
                        let isLast = self.recipe.steps.last?.id == currentStepID
                        
                        Button {
                            moveStep(forward: false)
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
                            moveStep(forward: true)
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
                .padding(.horizontal)
            }.task {
                self.currentStepID = self.recipe.steps.first?.id
            }
        }
    }
    
    private func moveStep(forward: Bool) {
        let currentIndex = self.recipe.steps.firstIndex(where: { $0.id == self.currentStepID })
        
        let destinationIndex = forward ? (currentIndex ?? 0) + 1 : (currentIndex ?? 0) - 1
        
        guard (0 ..< self.recipe.steps.count).contains(destinationIndex) else { return }
        
        withAnimation { self.currentStepID = self.recipe.steps[destinationIndex].id }
    }
    
    private func scheduleIdleScroll(with scrollProxy: ScrollViewProxy) {
        cancelIdleTimer()
        
        idleTimer = Timer.scheduledTimer(withTimeInterval: idleDelay, repeats: false) { _ in
            Task { @MainActor in
                withAnimation { scrollProxy.scrollTo(self.currentStepID, anchor: .top) }
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
