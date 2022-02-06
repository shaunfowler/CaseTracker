//
//  ContentView.swift
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

    var lastUpdatedLoadingMessage: String {
        if let lastFetch = viewModel.lastFetch {
            return "Last updated at \(lastFetch.formatted())."
        }
        if viewModel.loading {
            return "Refreshing cases..."
        }
        return ""
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
        await viewModel.fetch(force: true)
        refreshing = false
    }

    func caseList() -> some View {
        ZStack {
            if viewModel.cases.isEmpty {
                Text("No cases have been added.")
                    .padding()
            }
            List {
                Section {
                    Text(lastUpdatedLoadingMessage)
                }
                .listRowBackground(Color.clear)
                .modifier(UpdatedCaptionTextStyle())

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }

                ForEach(viewModel.cases, id: \.id) { caseStatus in
                    CaseRowView(model: caseStatus)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            viewModel.selectedCase = caseStatus
                        }
                        .listRowBackground(Color.clear)
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        viewModel.removeCase(atIndex: index)
                    }
                }
                .opacity(viewModel.loading ? 0.3 : 1.0)
            }
            .background(Color("HomeBackgroundColor"))
            .listStyle(.plain)
        }
        .navigationBarTitle("My Cases")
        .toolbar {
            ToolbarItem {
                addButton()
            }
        }
        .popover(item: $viewModel.selectedCase) { caseStatus in
            DetailsView(text: caseStatus.body, id: caseStatus.id)
        }
        .sheet(isPresented: $viewModel.isAddCaseViewPresented) {
            AddCaseView {
                // Recall latest case from cache!
                await viewModel.fetch(force: false)
            }
        }
        .onChange(of: scenePhase) { phase in
            viewModel.phase = phase
        }
    }

    func addButton() -> some View {
        Button(action: {
            viewModel.isAddCaseViewPresented.toggle()
        }) {
            Text("Add Case")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let viewModel = HomeViewModel(repository: PreviewDataRepository())
    static var previews: some View {
        HomeView(viewModel: viewModel)
            .previewLayout(.sizeThatFits)
            .task {
                await viewModel.fetch()
            }
    }
}

struct UpdatedCaptionTextStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.caption.bold())
            .opacity(0.3)
            .frame(maxWidth: .infinity, alignment: .center)
            .listSectionSeparator(.hidden)
    }
}
