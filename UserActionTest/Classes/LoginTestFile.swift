//
//  LoginTestFile.swift
//  UserAction
//
//  Created by whqpMac007 on 2023/8/15.
//

import Foundation

struct Par:Encodable {
    let cardNum: String
    let securityCode: String
    let code: String
    let type: String //0-pad 1-phone
}

struct LoginResult: Decodable {
    var msg: String = ""
    var code: Int = 0
    var data: LoginToken = .init()
}

struct LoginToken: Decodable {
    var token: String = ""
}

public class LoginTestFile {
    
    public init() {
        
    }
    
    public func loginTest() {
        struct getPwdPar: Encodable {
            var securityCode: String = ""
        }
        //    1000000705  123456
        let p = getPwdPar(securityCode: "123456")
        API.Login.getPwd.request(parameters: p).responseModel { (m: SimpleModel) in
            guard let pwd = m.data else { return }
            let card = Par(cardNum: "1000000705", securityCode: pwd, code: "0", type: "1")
            API.Login.login.request(parameters: card).responseModel { (lm: LoginResult) in
                if lm.code == 200 {
                    print("登录成功")
                } else {
                    print("登录失败")
                }
            } failure: { er in
                er.show()
            }

        } failure: { err in
            err.show()
        }

    }
}
