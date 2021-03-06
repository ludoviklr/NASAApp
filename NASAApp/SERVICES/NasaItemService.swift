//
//  NasaItemService.swift
//  NASAApp
//
//  Created by Ludovik on 12/04/2021.
//

import Foundation
import RxSwift

///Class that conforms to the NasaItemServiceProtocol

class NasaItemService: NasaItemServiceProtocol {
    
    /// Fetches the list of NasaItems
    /// argument url is nil if loading the first page
    func fetchNasaItems(NextUrl nextUrl: String?,
                        success: @escaping (_ items: [NasaItem],_ nextUrl: String?) -> (),
                                failure: @escaping (_ error: APiManager.ApiError) -> ()) {
        
        let urlString = nextUrl ?? NasaAppEndpoints.listNasaItemsUrl
        APiManager.performRequest(Url: urlString,
                                  RequestType: .get,
                                  RequestContentType: .json,
                                  RequestBody: nil) {[weak self] (response) in
            guard let `self` = self else {return}
            switch response {
            case .success(let data):
                let result = self.parseData(data)
                success(result.0, result.1)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    ///Fetch Image urls item
    func fetchImageCollection(ForItem item: NasaItem, success: @escaping (_ url: String) -> (), failure: @escaping (_ error: APiManager.ApiError) -> ()){
        
        guard let url = item.imageCollectionUrl else {
            failure(APiManager.ApiError.init(message: ApiErrorType.malformedUrl.localizedMessage, type: ApiErrorType.malformedUrl))
            return
        }
        
        APiManager.performRequest(Url: url,
                                  RequestType: .get,
                                  RequestContentType: .json,
                                  RequestBody: nil) {[weak self] (response) in
            guard let `self` = self else {return}
            
            print(response)
            
            switch response {
            case .success(let data):
                if let url = self.parseImageCollection(data) {
                    success(url)
                }else {
                    failure(APiManager.ApiError.init(message: ApiErrorType.unknownError.localizedMessage, type: ApiErrorType.unknownError))
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    
    
    
}

