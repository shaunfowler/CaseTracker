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
        // Always show loading if request is pending.
        if viewModel.loading {
            return "Refreshing cases..."
        }

        // Loaded date only if there are cases.
        if let lastFetch = viewModel.lastFetch, !viewModel.cases.isEmpty {
            return "Last updated at \(lastFetch.formatted())."
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
                    // TODO: Programatic instead to get rid of ">"
                    NavigationLink(destination: DetailsView(text: caseStatus.body, id: caseStatus.id)) {
                        CaseRowView(model: caseStatus)
                    }
                    .padding(.trailing, 8)
                    .background(Color("CaseRowBackgroundColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
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
            .background(Color("HomeBackgroundColor"))
            .listStyle(.plain)

            if !viewModel.loading && viewModel.cases.isEmpty {
                Text("No cases have been added.")
                    .padding()
            }
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

struct UpdatedCaptionTextStyle: ViewModifier {

    func body(content: Content) -> some View {
        content
            .font(.caption.bold())
            .opacity(0.3)
            .frame(maxWidth: .infinity, alignment: .center)
            .listSectionSeparator(.hidden)
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
