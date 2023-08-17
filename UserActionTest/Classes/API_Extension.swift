//
//  API_Extension.swift
//  FindAnswers
//
//  Created by whqpMac007 on 2022/8/31.
//

import Foundation
import Alamofire


struct SPar:Encodable {
    let url: String
    let strParams: String //参数json字符串
    let apiId: String
}


extension ApiProtocol {
    
    func request<Parameters: Encodable>(parameters: Parameters? = nil,
                                        headers: HTTPHeaders? = nil,
                                        encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default) -> DataRequest {
        var h:HTTPHeaders?
        if headers == nil {
            h = HTTPHeaders()
//            if let token = US.tokenStr {
//                h?.add(name: "CANPOINTTOKEN", value: token)
//            }
            //            if let token = US.tokenStr {
            //                h?.add(name: "Authorization", value: "Bearer \(token)")
            //            }
            
            //            let accessKeyID = "17693d10-f9ad-4edd-86aa-890823c6bb17"
            //            let appKey = "5919ddc842cd4f35249a5edab38c4045"
            //            let timeInter = Int(Date().timeIntervalSince1970)
            //            let accessKeySecret = "7ac95473-b75f-4312-b59e-8c9b1a02a4e5"
            //            let appSecret = "ccf839b44f3dd76212ccfa0e67d1cd93"
            //            let signStr = "\(apiId)" + "\(accessKeyID)" + "\(accessKeySecret)" + "\(appKey)" + "\(appSecret)" + "\(timeInter)"
            //            let signature = signStr.md5
            //
            //            h?.add(name: "apiId", value: apiId)
            //            h?.add(name: "accessKeyID", value: accessKeyID)
            //            h?.add(name: "appKey", value: appKey)
            //            h?.add(name: "timestamp", value: "\(timeInter)")
            //            h?.add(name: "signature", value: signature)
            //            if let ipstr = IpGetter.deviceIp { //传入运营商IP地址
            ////                Optional("100.77.149.228") device
            ////                Optional("192.168.0.105") wifi
            //                h?.add(name: "originIp", value: ipstr)
            //            }
        }else {
            h = headers
        }
        
        
        let interceptor = Interceptor(adapters: [], retriers: [RetryPolicy(retryLimit: 2)], interceptors: [RequestInterceptor()])
        
        switch method {
        case .post:
            
            let request = AF.request(url, method: method, parameters: parameters, encoder: encoder, headers: h,interceptor: interceptor ,requestModifier: {$0.timeoutInterval = TimeInterval(timeoutInterval)}).validate { request, response, data in
                var stateCode = response.statusCode
                if let cdata = data {
                    
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(SimpleModel.self, from: cdata)
                        if let code = model.code , code == 401 {
                            stateCode = code
                        }
                    } catch {
                        print(error)
                    }
                    
//                    if let dic = try? JSONSerialization.jsonObject(with: cdata) {
//                        if let dataDic = dic as? Dictionary<String,Any> {
//                            if let model = SimpleModel.deserialize(from: dataDic) {
//                                if let code = model.code , code == 401 {
//                                    stateCode = code
//                                }
//                            }
//                        }
//                    }
                }
                
#if DEBUG
                print("\(description)\n\(url)\n\(method)\n\(parameters!)\n\(response)\n")
#else
                
#endif
                
                if stateCode != 401 {
                    return .success(())
                } else {
                    return .failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401)))
                }
                
            }
            
            return request
            
        default:
            
            let request = AF.request(url, method: method, parameters: parameters, headers: h,interceptor: interceptor,requestModifier: { $0.timeoutInterval = TimeInterval(timeoutInterval) }).validate { request, response, data in
                var stateCode = response.statusCode
                if let cdata = data {
                    
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(SimpleModel.self, from: cdata)
                        if let code = model.code , code == 401 {
                            stateCode = code
                        }
                    } catch {
                        print(error)
                    }
                    
//                    if let dic = try? JSONSerialization.jsonObject(with: cdata) {
//                        if let dataDic = dic as? Dictionary<String,Any> {
//                            if let model = SimpleModel.deserialize(from: dataDic) {
//                                if let code = model.code , code == 401 {
//                                    stateCode = code
//                                }
//                            }
//                        }
//                    }
                }
                
#if DEBUG
                print("\(description)\n\(url)\n\(method)\n\(parameters!)\n\(response)\n")
#else
                
#endif
                
                if stateCode != 401 {
                    return .success(())
                } else {
                    return .failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401)))
                }
                
            }
            
            return request
        }
        
    }
    
    
    //MARK: - 数据上传接口
    func uploadData<T:UploadData>(parameters:[String:Any]?,datas:[T])  -> DataRequest {
        
        var header = HTTPHeaders()
        
//        if let token = US.tokenStr,token.count > 0 {
//            
//            //            header.add(name: "Authorization", value: token)
//            header.add(name: "CANPOINTTOKEN", value: token)
//        }
        
        header.add(name: "Content-type", value: "multipart/form-data")
        
        return AF.upload(multipartFormData: { data in
            //参数
            if let pars = parameters {
                for (keyStr,value) in pars {
                    guard let valData = "\(value)".data(using: .utf8) else { return }
                    data.append(valData, withName: keyStr)
                    //                    hprint(keyStr,value)
                }
            }
            
            for img in datas {
                if img.uploadName.count > 0,img.fileName.count > 0,img.data.count > 0 {
                    data.append(img.data, withName: img.uploadName, fileName: img.fileName, mimeType: img.dataMimeType)
                }
            }
            
        }, to: self.url, method:self.method, headers: header, interceptor: RequestInterceptor(), fileManager: FileManager.default, requestModifier: nil)
    }
    
}


extension ApiItem {
    
    /// 调用网关接口
    /// - Parameters:
    ///   - parameters: 参数
    ///   - headers: 请求头
    ///   - encoder:
    /// - Returns: DataRequest
    
    func gatewayRequest<Parameters: Codable>(parameters: Parameters? = nil,
                                               qItem: ApiItem? = nil,
                                               headers: HTTPHeaders? = nil,
                                               encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default) -> DataRequest? {
        
        var apiItem = API.Home.gateway
        if let aitem = qItem {
            apiItem = aitem
        }
        
        var json = ""
        
        do {
            let encoder = JSONEncoder()
            
            let data = try encoder.encode(parameters)
            json = String(data: data, encoding: .utf8) ?? ""
            
        } catch {
            print("传入参数无法转换为json字符串")
            return nil
        }
        
        let p = SPar(url: path, strParams: json, apiId: apiId)
        
        return apiItem.request(parameters: p, headers: headers, encoder: encoder)
    }
}

public enum LoadType: Equatable {
    case loadBefore
    case loadFinished(LoadFinished)
}

public enum LoadFinished: Equatable {
    case haveData
    case haveNoData
    case loadErr(LoadError)
}

public enum LoadError: Equatable {
    case networkError
    case noInternet
}

protocol LoadTypeProtocol {
    var loadType: LoadType { get set }
//    var loadTypePub:PassthroughSubject<LoadType,Never> { get set }
}


extension API {
    ///取消对应的网络请求
    static func cancelRequest(partOfUrl:String) {
        AF.session.getAllTasks { allTasks in
            
            for task in allTasks {
                guard let url = task.originalRequest?.url?.absoluteString,url.count > 0 else { return  }
                if url.contains(partOfUrl) == true {
                    task.cancel()
                    print("取消","\(url)")
                }
            }
        }
    }
    
    ///取消全被未完成的网络请求
    static func cancelAllRequest() {
        AF.session.getAllTasks { allTasks in
            _ = allTasks.map { $0.cancel() }
        }
    }
}
