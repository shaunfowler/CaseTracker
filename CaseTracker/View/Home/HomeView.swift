//
//  HomeView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/30/22.
//

import SwiftUI

struct HomeView: View {

    @Environment(\.scenePhase) var scenePhase
    @State var refreshing = false
    @ObservedObject var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View

    var caseList: some View {
        List {
            Section {
                Text(viewModel.lastUpdatedLoadingMessage)
                    .updatedCaptionTextStyle()

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }

                ForEach(viewModel.cases, id: \.id) { caseStatus in
                    NavigationLink(destination: DetailsView(caseStatus: caseStatus) {
                        viewModel.removeCase(receiptNumber: $0)
                    }) {
                        CaseRowView(model: caseStatus)
                    }
                    .caseStatusListItemStyle()
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        InteractionMetric.swipeDeleteCase.send()
                        viewModel.removeCase(atIndex: index)
                    }
                }
                .opacity(viewModel.loading ? 0.3 : 1.0)
            }
        }
        .background(Color.ctBackground)
        .listStyle(.plain)
    }

    var addButton: some View {
        Button(
            action: {
                InteractionMetric.tapAddNavBarButton.send()
                onAddCasePressed()
            },
            label: {
                Label("Add Case", systemImage: "plus")
            })
            .padding([.leading, .top, .bottom], 4)
            .contentShape(Rectangle())
    }

    var addCaseView: some View {
        AddCaseView(viewModel: viewModel.addCaseViewModel)
    }

    var networkAlertView: Alert {
        Alert(title: Text("Cannot Reload Cases"),
              message: Text("A network connection is not available."))
    }

    var body: some View {
        NavigationView {
            ZStack {
                caseList
                if viewModel.isEmptyState {
                    FirstTimeUserView(onAddCase: {
                        InteractionMetric.tapAddFirstTimeButton.send()
                        onAddCasePressed()
                    })
                }
            }
            .toolbar {
                ToolbarItem {
                    if !viewModel.isEmptyState {
                        addButton
                    }
                }
            }
            .navigationBarTitle("My Cases")
        }
        .navigationViewStyle(.stack)
        .onChange(of: scenePhase) { phase in
            viewModel.phase = phase
        }
        .alert(isPresented: $viewModel.isNetworkMessagePresented) {
            networkAlertView
        }
        .sheet(isPresented: $viewModel.isAddCaseViewPresented) {
            addCaseView
        }
        .refreshable {
            InteractionMetric.pullToRefreshCaseList.send()
            await refresh()
        }
        .onAppear {
            InteractionMetric.viewHome.send()
        }
    }

    // MARK: - Functions

    func refresh() async {
        refreshing = true
        await viewModel.refresh()
        refreshing = false
    }

    func onAddCasePressed() {
        viewModel.isAddCaseViewPresented.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {

    static let viewModel = HomeViewModel(repository: PreviewDataRepository())
    static let viewModelEmpty = HomeViewModel(repository: PreviewDataRepository(cases: []))

    static var previews: some View {
        Group {
            HomeView(viewModel: viewModel)
                .task {
                    await viewModel.fetch()
                }

            HomeView(viewModel: viewModelEmpty)
                .task {
                    await viewModel.fetch()
                }
        }
        .preferredColorScheme(.dark)
    }
}
