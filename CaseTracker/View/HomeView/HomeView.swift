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

    var body: some View {
        NavigationView {
            caseList()
        }
        .navigationViewStyle(.stack)
        .refreshable {
            await refresh()
        }
    }

    func refresh() async {
        refreshing = true
        await viewModel.refresh()
        refreshing = false
    }

    func caseList() -> some View {
        ZStack {
            List {
                Section {
                    Text(viewModel.lastUpdatedLoadingMessage)
                        .modifier(UpdatedCaptionTextStyle())

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }

                ForEach(viewModel.cases, id: \.id) { caseStatus in
                    NavigationLink(destination: DetailsView(text: caseStatus.body, id: caseStatus.id)) {
                        CaseRowView(model: caseStatus)
                    }
                    .padding(.trailing, 8)
                    .background(Color("CaseRowBackgroundColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding([.top, .bottom], 0)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        viewModel.removeCase(atIndex: index)
                    }
                }
                .opacity(viewModel.loading ? 0.3 : 1.0)

                }
                .listRowBackground(Color.clear)
            }
            .background(Color("HomeBackgroundColor"))
            .listStyle(.plain)

            if viewModel.isEmptyState {
                FirstTimeUserView { viewModel.isAddCaseViewPresented.toggle() }
            }
        }
        .navigationBarTitle("My Cases")
        .toolbar {
            ToolbarItem {
                if !viewModel.isEmptyState {
                    addButton()
                }
            }
        }
        .alert(isPresented: $viewModel.isNetworkMessagePresented) {
            Alert(title: Text("Cannot Reload Cases"),
                  message: Text("A network connection is not available."))
        }
        .sheet(isPresented: $viewModel.isAddCaseViewPresented) {
            AddCaseView(viewModel: viewModel.addCaseViewModel) {
                await viewModel.addCaseComplete()
            }
        }
        .onChange(of: scenePhase) { phase in
            viewModel.phase = phase
        }
    }

    func addButton() -> some View {
        Button(action: { viewModel.isAddCaseViewPresented.toggle() }, label: {
            Text("Add Case")
        })
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
        .previewLayout(.sizeThatFits)
    }
}
