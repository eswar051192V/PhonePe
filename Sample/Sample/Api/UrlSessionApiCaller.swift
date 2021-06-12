//
//  UrlSessionApiCaller.swift
//  Sample
//
//  Created by Sindhu Priya on 12/06/21.
//

import Foundation

public class UrlSessionApiCaller: ApiCaller {
    
    public var inProgress: Bool = false
    
    public var id: String = UUID().uuidString.lowercased()
    
    private let queue = DispatchQueue(label: "Q.\(UUID().uuidString.lowercased())")
    
    public func makeTheCall<Request, Response>(_ reqeust: Request, completion: @escaping (Response) -> Void) throws where Request : ApiReqeust, Response : ApiResponse {
        self.inProgress = true
        guard let request = reqeust as? UrlSessionApiRequest else {
            self.inProgress = false
            throw DefaultError.Empty(message: "Request is not in expected format")
        }
        
        
        guard let urlRequest = try request.urlRequest() else {
            var response = UrlSessionApiResponse(request: request, data: nil, error: nil)
            response.error = DefaultError.Empty(message: "Improper URL \(request.urlString)")
            self.inProgress = false
            completion(response as! Response)
            return
        }
        self.queue.async {
            let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self] (data, httpResponse, error) in
                var response = UrlSessionApiResponse(request: request, data: nil, error: nil)
                if let error = error {
                    response.error = DefaultError.Empty(message: "Error while making api call \(request.urlString): \(error.localizedDescription)")
                    self?.inProgress = false
                    completion(response as! Response)
                    return
                }
                
                guard let httpResponse = httpResponse as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    response.error = DefaultError.Empty(message: "Error with fetching Api Call (\(request.urlString)): \(String(describing: response))")
                    self?.inProgress = false
                    completion(response as! Response)
                    return
                }
                
                if let data = data {
                    response.data = data
                    self?.inProgress = false
                    completion(response as! Response)
                    
                    return
                } else {
                    response.error = DefaultError.Empty(message: "Error with fetching Api Call (\(request.urlString)): Unkown error")
                    self?.inProgress = false
                    completion(response as! Response)
                }
            })

            task.resume()
        }
        
    }
}
