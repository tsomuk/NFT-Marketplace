import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias NftOrderCompletion = (Result<Order, Error>) -> Void
typealias CurrencyListCompletion = (Result<[Currency], Error>) -> Void
typealias PaymentCompletion = (Result<PaymentConfirmation, Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func loadOrder(completion: @escaping NftOrderCompletion)
    func loadCurrencyList(completion: @escaping CurrencyListCompletion)
    func updateOrder(nftsIds: [String], isPaymentDone: Bool, completion: @escaping NftOrderCompletion)
    func paymentConfirmationRequest(currencyId: String, completion: @escaping PaymentCompletion)
}

final class NftServiceImpl: NftService {
    
    private let networkClient: NetworkClient
    private let storage: NftStorage
    
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }
        
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadOrder(completion: @escaping NftOrderCompletion) {
        networkClient.send(request: NFTOrderRequest(), type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCurrencyList(completion: @escaping CurrencyListCompletion) {
        networkClient.send(request: CurrencyListRequest(), type: [Currency].self) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateOrder(nftsIds: [String], isPaymentDone: Bool, completion: @escaping NftOrderCompletion) {
        let newOrderModel = NewOrderModel(nfts: nftsIds)
        let request = isPaymentDone ? OrderUpdateRequest(newOrder: nil) : OrderUpdateRequest(newOrder: newOrderModel)
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func paymentConfirmationRequest(currencyId: String, completion: @escaping PaymentCompletion) {
        
        let request = PaymentConfirmationRequest(currencyId: currencyId)
        networkClient.send(request: request, type: PaymentConfirmation.self) { result in
            switch result {
            case .success(let paymentConfirmation):
                completion(.success(paymentConfirmation))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
