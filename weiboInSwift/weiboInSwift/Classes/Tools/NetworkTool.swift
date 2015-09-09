//
//  NetworkTool.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/7.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit
import AFNetworking

private let DSErrorDomainName = "com.itheima.error.network"

class NetworkTool: AFHTTPSessionManager {
    
    
    // MARK: /**************************** 属性 ****************************/
    // 授权
    private let client_id = "470245058"
    private let client_secret = "ec982ae6c58a7925d235cc97eccdd708"
    let redirect_uri = "http://www.baidu.com"
    
    // MARK: /**************************** 初始化函数 ****************************/
    // 单例
    static let sharedNetworkTool: NetworkTool = {
    
        let baseURL: NSURL = NSURL(string: "https://api.weibo.com/")!
        let net = NetworkTool(baseURL: baseURL)
        
        // 添加数据解析类型
        net.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as Set<NSObject>
        
        return net
    }()
    
    
    // MARK: /**************************** 加载用户信息 ****************************/
    func loadUserInfo(finished: DSNetFinishedCallBack) {
        
        // 判断access_token是否存在
        let token = UserAccount.loadUserAccount()?.access_token
        let uid = UserAccount.loadUserAccount()?.uid
        
        if token == nil {
            
            // TODO: 错误处理
            return
        }
        
        let URLString = "2/users/show.json"
        let param: [String : AnyObject] = ["access_token": token!, "uid": uid!]
        
        requestGET(URLString, parameters: param, finished: finished)
    }
    
    
    // MARK: /**************************** 授权函数 ****************************/
    // 授权地址
    func oauthURL() -> NSURL {
    
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        
        print("授权地址->\(urlString)")
        
        return NSURL(string: urlString)!
    }
    // 加载token
    func loadToken(code: String, finished: (result: [String: AnyObject]?, error: NSError?) -> ()) {
    
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = [  "client_id":        client_id,
                        "client_secret":    client_secret,
                        "grant_type":       "authorization_code",
                        "code":             code,
                        "redirect_uri":     redirect_uri]
        
        POST(urlString, parameters: params, success: { (_, json) -> Void in
            
            finished(result: json as? [String : AnyObject], error: nil)
            }) { (_, error) -> Void in
                
                print("失败了->\(error)")
                
                finished(result: nil, error: error)
        }
    }
    
    
    // MARK: /**************************** 对AFN网络请求的封装 ****************************/
    typealias DSNetFinishedCallBack = (result: [String : AnyObject]?, error: NSError?) -> ()
    
    private func requestGET(URLString: String, parameters: [String: AnyObject], finished: DSNetFinishedCallBack) {
    
        GET(URLString, parameters: parameters, success: { (_, JSON) -> Void in
            
            if let json = JSON as? [String : AnyObject] {
            
                // 完成回调
                finished(result: json, error: nil)
            } else {
                
                print("没有错误, 也没有结果 GETRquest \(URLString)")
                
                let error = NSError(domain: DSErrorDomainName, code: -1, userInfo: ["errorMessage": "空数据"])
                
                // 没有错误, 同时也没有结果
                finished(result: nil, error: error)
            }
            }) { (_, error) -> Void in
                
                // 跟踪错误
                finished(result: nil, error: error)
        }
    }
    
}
