//
//  LoadViewModel.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 11/08/2023.
//  based on https://medium.com/whatnot-engineering/the-next-page-8950875d927a
//

import Foundation

struct PageModel: Identifiable, Hashable {
    var id: String = UUID().uuidString
}

struct LoadViewSource: Pageable {
    typealias Value = PageModel

    func loadPage(after currentPage: PageInfo, size: Int) async throws -> (items: [Value], info: PageInfo) {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let items = [PageModel(), PageModel()]
        let info = PageInfo.default
        return (items: items, info: info)
    }
}

public struct PageInfo: Equatable, Codable {
    public let hasNextPage: Bool
    public let endCursor: String?
    public static let `default`: PageInfo = PageInfo(hasNextPage: true, endCursor: nil)
}

public protocol Pageable {
    associatedtype Value: Identifiable & Hashable
    func loadPage(after currentPage: PageInfo, size: Int) async throws -> (items: [Value], info: PageInfo)
}

public enum PagingState: Equatable {
    case loadingFirstPage
    case loaded
    case loadingNextPage
    case error
}

public final class LoadViewModel<T: Pageable>: ObservableObject {

    @Published var state: PagingState = .loadingFirstPage
    @Published private(set) var items = [T.Value]()
    let source: T
    let pageSize: Int
    let threshold: Int
    private(set) var pageInfo: PageInfo

    init(source: T, pageInfo: PageInfo = .default, threshold: Int, pageSize: Int) {
        self.source = source
        self.pageInfo = pageInfo
        self.threshold = threshold
        self.pageSize = pageSize

    }

    private var canLoadMorePages: Bool { pageInfo.hasNextPage }

    private var currentTask: Task<Void, Never>? {
        willSet {
            if let task = currentTask {
                if task.isCancelled { return }
                task.cancel()
                // Setting a new task cancelling the current task
            }
        }
    }

    func fetchAll() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.items = [items.first!]
            self.state = .loaded
        }
    }

    public func onItemAppear(_ model: T.Value) {
        // (1) appeared: No more pages
        if !canLoadMorePages {
            return
        }

        // (2) appeared: Already loading
        if state == .loadingNextPage || state == .loadingFirstPage {
            return
        }

        // (3) No index
        guard let index = items.firstIndex(where: { $0.id == model.id }) else {
            return
        }

        // (4) appeared: Threshold not reached
        let thresholdIndex = items.index(items.endIndex, offsetBy: -threshold)
        if index != thresholdIndex {
            return
        }

        // (5) appeared: Load next page
        state = .loadingNextPage
        currentTask = Task {
            await loadMoreItems()
        }
    }

    func loadMoreItems() async {
        do {
            // (1) Ask the source for a page
            let rsp = try await source.loadPage(after: pageInfo, size: pageSize)

            // (2) Task has been cancelled
            if Task.isCancelled { return }

            // (3) Set the items as the initial set if we are loading the first page else append to the existing set of items
            let models = rsp.items
            let allItems = state == .loadingFirstPage ? models : items + models

            pageInfo = rsp.info

            // (4) Publish our changes to SwiftUI by setting our items and state
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.items = allItems
                self.state = .loaded
            }
        } catch {

            // (5) Publish our error to SwiftUI
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .error
            }
        }
    }

}
