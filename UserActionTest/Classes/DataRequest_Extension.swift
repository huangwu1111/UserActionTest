//
//  DataRequest_Extension.swift
//  cloudPrintIphone
//
//  Created by whqpMac007 on 2023/7/11.
//

import Foundation
import Alamofire

extension DataRequest {
    
    
    func responseModel<T: Decodable>(queue: DispatchQueue = .main,success:@escaping (T)->Void,failure:@escaping (DecodeErr)->Void) {
        
        self.responseJSON(queue: queue) { resp in
            switch resp.result {
            case .success(let data):
//                hprint(data)
                
            
                guard let dic = data as? Dictionary<String,Any> else {
                    failure(DecodeErr.clientErr(code: nil, reasion: "返回数据不是字典类型"))
                    return
                }
                
                guard let code = dic["code"] as? Int else {
                    failure(DecodeErr.clientErr(code: nil, reasion: "状态码code解析出错"))
                    return
                }
                
                guard let msg = dic["msg"] as? String else {
                    failure(DecodeErr.clientErr(code: nil, reasion: "msg信息解析出错"))
                    return
                }
                
                if code == 200 {
                    
                    if let tdata = resp.data {
                        let str = String(bytes: tdata, encoding: .utf8)
                        print(str!)
                        
                        do {
                            let model = try JSONDecoder().decode(T.self, from: tdata)
                            success(model)
                        } catch {
                            failure(DecodeErr.clientErr(code: code, reasion: "数据转模型出错"))
                            return
                        }
                        
                        
                    }
                    
                    
                } else {
                    
                    failure(DecodeErr.clientErr(code: code, reasion: msg))
                }
            case .failure(let err):
                let afErr = err as AFError
                switch afErr {
                
                case .requestRetryFailed(let retryError, _):
                    
                    guard let retryErr = retryError as? AFError else {
                        failure(.clientErr(code: -1, reasion: "网络错误，请稍后重试！"))
                        return
                        
                    }
                    
                    switch retryErr {
            
                    case .responseValidationFailed(let reason):
                        switch reason {
                        case .unacceptableStatusCode( let code):
                            failure(DecodeErr.clientErr(code: code, reasion: err.localizedDescription))
                            return
                        default:
                            break
                        }
                    default:
                        break
                    }
                default:
                    break
                
                }
                
                failure(DecodeErr.clientErr(code: err.responseCode, reasion: err.localizedDescription))
                print("请求出错**********",err)
                
            }
        }
    }
    
    //MARK: - 异步函数
    /// 异步解析DataRequest扩展
    /// - Returns: 返回类型
    @available(iOS 13.0.0, *)
    func responseModel<T: Decodable>(queue: DispatchQueue = .main) async throws -> T {
        
        return try await withCheckedThrowingContinuation({ continuation in
            
            responseModel(queue: queue) { (data: T) in
                continuation.resume(returning: data)
            } failure: { error in
                continuation.resume(throwing: error)
            }

        })
    
    }
    
}


final class RequestInterceptor:Alamofire.RequestInterceptor {
    var retryCount:Int = 2
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        completion(.success(urlRequest))
    }
    
//    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        
//        if request.retryCount == retryCount {
//            print("重试次数用完")
//            completion(.doNotRetry)
//            return
//        }
//        
//        let response = request.task?.response as? HTTPURLResponse
//        var code: Int = 0
//        if let cd = response?.statusCode, cd == 401 {
//            code = cd
//        } else if let cd = error.asAFError?.responseCode,cd == 401 {
//            code = cd
//        }
//        
//        if code == 401 {
//            print(response!,"导致刷新token")
//            guard let token = US.tokenStr,token.count > 0 else {
//                return
//            }
//            struct TokenPar: Encodable {
//                let token: String
//            }
//            let p = TokenPar(token: token)
//            //402登录  401刷新token 网关的401不是token失效
//            
//            API.ReFreshToken.refreshToken.request(parameters: p).responseJSON { result in
//                switch result.result {
//                case .success(let data):
//                    guard let dic = data as? Dictionary<String,Any> else { return }
//                    guard let model = SimpleModel.deserialize(from: dic) else { return }
//                    if model.code == 200 { //刷新成功
//                        hprint("刷新成功立即重试************************")
//                        
//                        completion(.retry)
//                    } else if model.code == 405 {//直接退出
//                        hprint("token到期直接退出************************")
//                        completion(.doNotRetryWithError(error))
//
//                        NotificationCenter.default.post(name: NSNotification.Name(kLoginStatus), object: false)
//                        
//                    } else {
//                        print("token刷新失败")
//                        completion(.doNotRetryWithError(error))
//
//                        NotificationCenter.default.post(name: NSNotification.Name(kLoginStatus), object: false)
//                    }
//                    print(model)
//                case .failure(let err):
//                    print(err.localizedDescription)
//                    hprint("token刷新出错直接退出************************")
//                    completion(.doNotRetryWithError(error))
//
//                    NotificationCenter.default.post(name: NSNotification.Name(kLoginStatus), object: false)
//                }
//            }
//
//
//            //可以在这里进行获取token的网络请求
////            completion(.retryWithDelay(1))
//            //token过期不报错直接退出登录
//            //completion(.doNotRetryWithError(error))
//
//        } else {
//            //token 没过期，进行原始请求
//            completion(.doNotRetry)
//        }
//        
//    }
}
