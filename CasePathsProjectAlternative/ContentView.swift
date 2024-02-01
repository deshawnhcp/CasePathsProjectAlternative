//
//  ContentView.swift
//  CasePathsProjectAlternative
//
//  Created by deshawn.jackson on 1/31/24.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = ViewModel()

//  init(state: ViewModel.State = .initial) {
//    self.viewModel = viewModel
//  }

  var body: some View {
    VStack {
      switch viewModel.state {
      case .initial:
        InitialView()
      case let .error(error):
        ErrorView(error: error)
      case .loading:
        LoadingView()
      case let .loaded(result):
        LoadedView(result: result)
      }
    }
    .padding()
  }
}

extension ContentView {
  class ViewModel: ObservableObject {
    enum State {
      case initial
      case error(Error)
      case loading
      case loaded(result: LoadedResult)
    }

    @Published var state: State = .loaded(result: .init(accounts: [], selectedAccount: "Selected"))
  }
}

struct InitialView: View {
  var body: some View {
    Text("Initial")
  }
}

struct ErrorView: View {
  let error: Error

  var body: some View {
    Text("Error \(error.localizedDescription)")
  }
}

struct LoadingView: View {
  var body: some View {
    ProgressView()
  }
}

struct LoadedView: View {
  @ObservedObject var viewModel: ViewModel

  init(result: LoadedResult) {
    self._viewModel = .init(wrappedValue: .init(result: result))
  }

  var body: some View {
    VStack {
      Text("Selected account: " + (viewModel.selectedAccount ?? "none selected"))
      TextField("", text: $viewModel.text)
        .border(.black)
    }
    .onChange(of: viewModel.text) { oldValue, newValue in
      viewModel.selectedAccount = newValue
    }
  }
}

extension LoadedView {
  class ViewModel: ObservableObject {

    var accounts: [String] = []
    @Published var selectedAccount: String?

    @Published var text = ""

    init(result: LoadedResult) {
      accounts = result.accounts
      selectedAccount = result.selectedAccount
    }
  }
}

struct LoadedResult {
  let accounts: [String]
  let selectedAccount: String?
}

#Preview {
  ContentView()
}
