import Foundation
import Combine

public final actor Camera {
    
    deinit {
        Swift.print("camera gone")
    }
    
    private var publishers = [String : Pub]()
    private let strategy: Strategy
    
    public init(strategy: Strategy) {
        self.strategy = strategy
    }
    
    public func publisher(for url: URL, size: Picture.Size) -> Pub? {
        if publishers[url.absoluteString] == nil {
            publishers[url.absoluteString] = .init()
        }
        
        let publisher = publishers[url.absoluteString]!
        let size = strategy.size(for: size)
        
        Task
            .detached(priority: .utility) {
                if await publisher.output == nil {
                    guard let output = CGImage.render(url: url, size: size) else { return }
                    await publisher.received(output: output)
                }
            }
        
        return publisher
    }
}

extension Camera {
    public final actor Pub: Publisher {
        
        deinit {
            Swift.print("publisher gone")
        }
        
        public typealias Output = CGImage
        public typealias Failure = Never
        fileprivate private(set) var output: Output?
        private var contracts = [Contract]()
        
        fileprivate func received(output: Output) async {
            self.output = output
            await clean()
            await send(contracts: contracts, output: output)
        }
        
        public nonisolated func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let sub = Sub(subscriber: .init(subscriber))
            subscriber.receive(subscription: sub)
            
            let contract = Contract(sub: sub)
            
            Task {
                await store(contract: contract)
                
                if let output = await output {
                    await sub.send(output: output)
                }
            }
        }
        
        private func store(contract: Contract) async {
            contracts.append(contract)
            await clean()
        }
        
        private func send(contracts: [Contract], output: Output) async {
            for contract in contracts {
                await contract.sub?.send(output: output)
            }
        }
        
        private func clean() async {
            let all = contracts
            var active = [Contract]()
            for contract in all {
                if await contract.sub?.subscriber != nil {
                    active.append(contract)
                }
            }
            contracts = active
        }
    }
}
    
private extension Camera.Pub {
    final actor Sub: Subscription {
        private(set) var subscriber: AnySubscriber<Output, Failure>?
        
        init(subscriber: AnySubscriber<Output, Failure>) {
            self.subscriber = subscriber
        }
        
        func send(output: Output) async {
            if let subscriber = subscriber {
                await send(subscriber: subscriber, output: output)
            }
        }
        
        nonisolated func cancel() {
            Task {
                await clear()
            }
        }
        
        nonisolated func request(_: Subscribers.Demand) {

        }
        
        private func clear() {
            subscriber = nil
        }
        
        @MainActor private func send(subscriber: AnySubscriber<Output, Failure>, output: Output) {
            _ = subscriber.receive(output)
        }
    }
    
    struct Contract {
        private(set) weak var sub: Sub?
        
        init(sub: Sub) {
            self.sub = sub
        }
    }
}
