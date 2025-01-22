//
//  ContentView.swift
//  DMErrorHandlingPodExample
//
//  Created by Nikolay Dementiev on 22.01.2025.
//

import SwiftUI
import DMErrorHandling

//struct ContentView: View {
//    @State private var statusText: String = ""
//    @State private var showedLoading = false
//    
////    private var showedLoading_already: Bool = false
//    
//    var body: some View {
//        ZStack {
//            NavigationView {
//                VStack {
//                    
//                    //loading
//                    makeButton(imageName: "Loading Button",
//                               buttonText: "Show Loading screen") {
//                        
//                        showedLoading = true
//                    }
//                    
//                    //Error
//                    makeButton(imageName: "Error Button",
//                               buttonText: "Show Error screen") {
//                        
//                        showedLoading = true
//                    }
//                    
//                    //Success
//                    makeButton(imageName: "Success Button",
//                               buttonText: "Show Success screen") {
//                        
//                        showedLoading = true
//                    }
//                    Spacer()
//                }
//                .padding()
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .principal) {
//                        HStack {
//                            Image("Various views")
//                                .resizable()
//                                .frame(width: 20, height: 20)
//                            Text("Various screens tester").font(.headline)
//                        }
//                    }
//                }
//            }
//            .safeAreaInset(edge: .bottom) {
//                HStack {
//                    (Text("Current status: ")
//                        .font(.headline) + Text(statusText.isEmpty ? "?" : statusText).font(.body))
//                    .multilineTextAlignment(.center)
//                    .lineLimit(2)
//                }
//            }
//            
//            if showedLoading /*&& !showedLoading_already*/ {
////                showedLoading_already = true
//                LoadableView(type: .constant(.loading)) {
//                    self
//                }
//            }
//            //            LoadableView(type: .loading)
//        }
////        .frame(width: .infinity,
////               height: .infinity)
//        
//        //                SwiftUIViewTEstView()
//    }
//    
//    private func makeButton(imageName: String,
//                            buttonText: String,
//                            action: @escaping @MainActor () -> Void) -> some View {
//        Button (action: action,
//                label: {
//            Image(imageName)
//                .resizable()
//                .frame(width: 20, height: 20)
//                .foregroundStyle(.tint)
//            Text(buttonText)
//                .tint(.black)
//        }
//        )
//        .padding(.init(top: 5,
//                       leading: 0,
//                       bottom: 5,
//                       trailing: 0))
//    }
//}
struct ContentView: View {
    @State private var loadableState: LoadableType = .none

    var body: some View {
        VStack {
            Text("Основний вміст")
            
            Button("Показати завантаження") {
                showLoading()
            }
            
            Button("Симулювати помилку") {
                showFailure()
            }
            
            Button("Симулювати успіх") {
                showSuccess()
            }
            
            Button("Приховати завантаження") {
                hideLoading()
            }
        }
        .loadingOverlay(loadableState: $loadableState)
    }

    private func showLoading() {
        loadableState = .loading
        Task {
            await simulateTask()
        }
    }

    private func showFailure() {
        loadableState = .failure(error: NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Не вдалося завантажити дані."]), onRetry: {
            showLoading()
        })
    }

    private func showSuccess() {
        loadableState = .success("Дані успішно завантажено!")
    }

    private func hideLoading() {
        loadableState = .none
    }

    private func simulateTask() async {
        try? await Task.sleep(for: .seconds(3))
        await MainActor.run {
            showSuccess()
        }
    }
}

#Preview {
    ContentView()
}
