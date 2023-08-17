

import Foundation
import Alamofire

typealias successBlock = (Any)->Void
typealias failBlock = (DecodeErr)->Void



/// App的接口
struct API {
    
    static var networkType: NetworkType = .release
    static var Pro = "http://"
    
    ///网页前缀
    static var WebFront: String {
        switch networkType {
        case .release:
            return normalReleaseWebFront
        case .debug:
            return normalDebugWebFront
        }
    }
    
    /// 项目的域名
//    / 39.105.153.115:8080
    static var normalDebugfront = Pro + "123.57.187.93:8080" //测试环境
    static var normalDebugWebFront = Pro + "a.canpoint.com.cn" //测试环境
    static var ocrDebugFront = Pro + "123.57.95.187:8089" //OCR 答题卡识别测试
    
    static var normalReleaseFront = Pro + "canpoint-cloud-api.canpoint.cn" //正式环境
    static var normalReleaseWebFront = Pro + "m.canpoint.cn" //正式环境
    static var ocrReleaseFront = Pro + "ocr-v1.canpoint.cn" //OCR 答题卡识别正式

    
    struct ReFreshToken {
        static let refreshToken =           ApiItem(p: "/auth/ext/user/token/refresh", apiID: "", d: "刷新token")
    }
    
    //MARK: - 登录注册模块
    struct Login {
        static let decodeCard =             ApiItem(p: "/cloudprint/card/student/getDecCode",m: .post, apiID: "", d: "解密二维码内容")
        static let schoolData =             ApiItem(p: "/cloudprint/card/student/schoolInfoByCard",m: .get, apiID: "", d: "通过学习卡查询学校信息")
        static let cardStatus =             ApiItem(p: "/cloudprint/card/student/status",m: .get, apiID: "", d: "学习卡激活状态")
        static let grideList  =             ApiItem(p: "/cloudprint/school/gradeList",m: .get, apiID: "", d: "查询年级列表")
        static let classList  =             ApiItem(p: "/cloudprint/school/classList",m: .get ,apiID: "", d: "班级列表")
        static let userList   =             ApiItem(p: "/cloudprint/school/classStudentList",m: .get, apiID: "", d: "用户列表")
        static let activationCard =         ApiItem(p: "/cloudprint/card/student/activation",m: .post, apiID: "", d: "激活学生卡")
        static let login      =             ApiItem(p: "/cloudprint/student/login",m:.post ,apiID: "", d: "登录")
        static let studyYear  =             ApiItem(p: "/cloudprint/school/schoolYearList", apiID: "", d: "学年列表")
        static let checkDeviceInfo =        ApiItem(p: "/cloudprint/flat/config/check",m: .post, apiID: "", d: "校验code")
        static let getPwd           =       ApiItem(p: "/cloudprint/student/crypto/encrypt",m: .post, apiID: "", d: "明文密码加密")
        static let pwdLogin   =             ApiItem(p: "/auth/ext/login",m: .post, apiID: "", d: "账号密码登录")
        static let schoolDataByUserId  =    ApiItem(p: "/user/v1/ext/user/user-org-list", apiID: "100056", d: "通过用户ID获取学校身份信息")
        static let checkStatusOfAccount  =  ApiItem(p: "/auth/user/password/checkAccount",m: .post, apiID: "", d: "1.忘记密码 检查账户状态")
        static let getCode             =    ApiItem(p: "/auth/user/password/vCode", m: .post, apiID:"" ,d:"2.忘记密码 生成并发送验证码【短信/邮箱】")
        static let checkCode           =    ApiItem(p: "/auth/user/password/vCodeValidate",m: .post,apiID: "", d: "3.忘记密码 校验验证码【短信/邮箱】")
        static let resetPwd            =    ApiItem(p: "/auth/user/password/reset",m: .post,apiID: "", d: "4.忘记密码 重置未登录用户密码")

    }
    
    //MARK: - 首页
    struct Home {
        static let homeData =               ApiItem(p: "/cloudprint/student/index", apiID: "", d: "首页数据")
        static let studyLevel =             ApiItem(p: "/cloudprint/student/period/info",m:.get, apiID: "", d: "学生-年级所属学段")
        static let gateway =                ApiItem(p: "/cloudprint/gateway/api/invoke",m:.get, apiID: "", d: "调用网关的通用接口")
        static let associatedSubjects =     ApiItem(p: "/cloudprint/student/subject/list",m:.get, apiID: "", d: "学生-班级所属学段关联图书学科列表")
        static let bookList =               ApiItem(p: "/cloudprint/student/book/listClassBooks",m:.get, apiID: "", d: "图书列表")
        static let allWrongSubjects =       ApiItem(p: "/cloudprint/student/book/questionTree",m: .get, apiID: "", d: "错题")
        static let addIntoList =            ApiItem(p: "/cloudprint/student/error/question/insert",m: .post, apiID: "", d: "加入错题本")
        static let addIntoWrongList =       ApiItem(p: "/cloudprint/student/error/question/basket/insert",m: .post, apiID: "", d: "加入错题打印篮")
        static let deleteFromWrongList =    ApiItem(p: "/cloudprint/student/error/question/basket/remove",m: .post, apiID: "", d: "移除错题打印篮")
        static let waitPrintNum =           ApiItem(p: "/cloudprint/student/error/question/basket/count",m: .get, apiID: "", d: "错题篮数量")
        static let cleanPrintBasket =       ApiItem(p: "/cloudprint/student/error/question/basket/clear",m: .post, apiID: "", d: "清空打印篮")
        static let setLatestPrint =         ApiItem(p: "/cloudprint/student/chapter/replaceLastChapter",m: .post, apiID: "", d: "设置最后一次访问章节")
        static let latestPrint =            ApiItem(p: "/cloudprint/student/chapter/getLastChapterCode",m: .get, apiID: "", d: "获取最后一次访问章节")
        static let loginOut =               ApiItem(p: "/cloudprint/student/logout", m: .post, apiID: "", d: "退出登录")
        static let appVersion =             ApiItem(p: "/cloudprint/appVersion/getVersion", apiID: "", d: "获取app最新版本")
        static let checkAnswerCard =        ApiItem(fType: .ocr,p: "/image_detect",m: .post,apiID: "",timeoutInterval: 30,d: "服务器端检测图片是否可用--也是上传答题卡")
        static let scanAnswerCard =         ApiItem(fType: .ocr,p: "/image_scanv2", apiID: "",timeoutInterval: 30, d: "识别答题卡")
        static let printType =              ApiItem(p: "/cloudprint/student/print/getPrintType", apiID: "", d: "学生-是否允许打印")

    }
    
    struct ReCharge {
        static let decryptionChargeCard =   ApiItem(p: "/cloudprint/student/rechargeCard/decCardNum", apiID: "", d: "充值卡-卡号解密")
        static let chargePaperNumber =      ApiItem(p: "/cloudprint/student/rechargeCard/cardPageCount", apiID: "", d: "充值卡-张数")
        static let chargeAct =              ApiItem(p: "/cloudprint/student/rechargeCard/activate",m: .post, apiID: "", d: "充值卡-激活")
    }
    //MARK: - 类题
    struct ConcentrationSubject {
        static let insertIntoBasket =       ApiItem(p: "/cloudprint/student/variableQuestion/basket/replace",m: .post, apiID: "", d: "加入类题篮")
        static let basketCount =            ApiItem(p: "/cloudprint/student/variableQuestion/basket/count",m: .post, apiID: "", d: "类题篮题目数量")
        static let cleanUpBasket =          ApiItem(p: "/cloudprint/student/variableQuestion/basket/clear",m: .post, apiID: "", d: "清空类题篮")
        static let printHistory =           ApiItem(p: "/cloudprint/student/variableRecord/list",m: .get, apiID: "", d: "类题打印记录列表")
        static let printConSubject =        ApiItem(p: "/cloudprint/print/variableQuestionPrint",m: .post, apiID: "", d: "打印类题篮")
        static let printConWrongSubject =   ApiItem(p: "/cloudprint/print/variableErrorQuestionPrint",m: .post, apiID: "", d: "打印类题错题")
        static let printConList =           ApiItem(p: "/cloudprint/print/variableQuestionBook",m: .post ,apiID: "", d: "打印类题本类题")
        static let insertToConList =        ApiItem(p: "/cloudprint/student/variableQuestion/insert",m: .post, apiID: "", d: "学生-我的类题-加入类题本")
        static let conChangeToMaster    =   ApiItem(p: "/cloudprint/student/variableQuestion/remove",m: .post, apiID: "", d: "类题-设置为已掌握")
    }
    //MARK: - 错题本
    struct WrongSubjectBook {
        static let changeToMaster             =  ApiItem(p: "/cloudprint/student/error/question/remove",m: .post, apiID: "", d: "错题设置为已掌握")
        static let printAllWrongSubjectsBook  =  ApiItem(p: "/cloudprint/print/errorQuestionBook",m: .post, apiID: "", d: "打印错题本错题")
        static let printWrongSubjectBasket    =  ApiItem(p: "/cloudprint/print/errorQuestionBasket",m: .post, apiID: "", d: "打印错题篮错题")
        static let allWrongSubjects =            ApiItem(p: "/cloudprint/student/book/questionTree",m: .get, apiID: "", d: "错题")
        static let addIntoWrongList =            ApiItem(p: "/cloudprint/student/error/question/basket/insert",m: .post, apiID: "", d: "加入错题打印篮")
        static let deleteFromWrongList =         ApiItem(p: "/cloudprint/student/error/question/basket/remove",m: .post, apiID: "", d: "移除错题打印篮")
        static let waitPrintNum =                ApiItem(p: "/cloudprint/student/error/question/basket/count",m: .get, apiID: "", d: "错题篮数量")
        static let conWaitPrintNum =             ApiItem(p: "/cloudprint/student/variableQuestion/basket/count",m: .post, apiID: "", d: "类题篮数量")
        static let addIntoList =                 ApiItem(p: "/cloudprint/student/error/question/insert",m: .post, apiID: "", d: "加入错题本")

    }
    //MARK: - 我的任务
    struct MyTask {
        static let myTask =                 ApiItem(p: "/cloudprint/student/task/index",m:.get, apiID: "", d: "我的任务列表")
        static let collect =                ApiItem(p: "/cloudprint/student/collect/insert",m: .post, apiID: "", d: "收藏")
        static let cancelCollect =          ApiItem(p: "/cloudprint/student/collect/cancel",m: .post, apiID: "", d: "取消收藏")
        static let textPrint =              ApiItem(p: "/cloudprint/print/getFileHttpPath", apiID: "", d: "纯文本打印，获取打印链接接口")
    }
    //MARK: - 我的收藏
    struct MyCollection {
        static let myCollection =           ApiItem(p: "/cloudprint/student/collect/list", apiID: "", d: "我的收藏")
    }
    //MARK: - 老师推荐
    struct TeacherRecommendation {
        static let recommendationList =     ApiItem(p: "/cloudprint/student/receive/recommend/list",m: .get, apiID: "", d: "教师推荐列表")
        static let altMsg =                 ApiItem(p: "/cloudprint/student/receive/recommend/isShowStatus", apiID: "", d: "查询new标识显示状态")
        static let hidAltMsg =              ApiItem(p: "/cloudprint/student/receive/recommend/closeShowStatus", apiID: "", d: "查询new标识显示状态")
    }
    //MARK: - 名师优选
    struct TeacherChoice {
        static let choiceList =             ApiItem(p: "/cloudprint/student/task/platformIndex",m: .get, apiID: "", d: "名师优选列表")
        static let teacherChoiceAltMsg =    ApiItem(p: "/cloudprint/student/task/getIsShow", apiID: "", d: "提示状态信息")
        static let teacherHidChoiceAltMsg = ApiItem(p: "/cloudprint/student/task/updateIsShow",m: .post, apiID: "", d: "隐藏提示状态信息")
    }
    //MARK: - 个人中心
    struct User {
        
        static let userMsg =                ApiItem(p: "/cloudprint/student/studentInfo", m: .get, apiID: "", d: "获取用户信息")
        static let changeCode =             ApiItem(p: "/cloudprint/student/updateCode", m: .post, apiID: "", d: "修改安全码")
        static let destroyAccount =         ApiItem(p: "/auth/ext/v1/user/cancelaccount/apply",m: .post, apiID: "101509", d: "申请注销账户")
        static let chargeHistory =          ApiItem(p: "/cloudprint/card/manage/rechargeOrder", apiID: "", d: "学习卡充值订单")
        static let homeworkHistory =        ApiItem(p: "/cloudprint/student/answercard/workRecordList", apiID: "", d: "答题卡作业记录")
        static let bookList =               ApiItem(p: "/cloudprint/student/answercard/subjectBookList", apiID: "", d: "答题卡图书列表")
        static let bookData =               ApiItem(p: "/cloudprint/student/answercard/chapterList", apiID: "", d: "答题卡图书章节列表")
        static let homeworkHistoryDetail =  ApiItem(p: "/cloudprint/student/answercard/answerCardDetail", apiID: "", d: "答题卡作业记录详情")
        static let homeworkSubjectList =    ApiItem(p: "/cloudprint/student/answercard/subjectList", apiID: "", d: "答题卡学科列表")
        static let homeworkFiltration =     ApiItem(p: "/cloudprint/student/answercard/chapterRecordList", apiID: "", d: "章节下作业记录-筛选作业记录")
        static let homeworkDetailInChapter = ApiItem(p: "/cloudprint/student/answercard/chapterDetail", apiID: "", d: "章节作业记录详情")
        static let answercardDetail =       ApiItem(p: "/cloudprint/student/answercard/answerCardChapterRecord", apiID: "", d: "以答题卡为单位的记录")
        static let waitToDownloadList =     ApiItem(p: "/cloudprint/student/download/waitDownloadList", apiID: "", d: "文件待下载列表")
        static let changePrintStatus =      ApiItem(p: "/cloudprint/student/download/updatePrintStatus",m: .post, apiID: "", d: "更新打印状态")
        static let deleteDocumentTask =     ApiItem(p: "/cloudprint/student/download/delRecord",m: .post, apiID: "", d: "删除生成的文件记录")
        static let recreatePDF =            ApiItem(p: "/cloudprint/print/republishTask",m:.post, apiID: "", d: "错题小任务重新发布")
    }
    
    struct Web {
        static let choiceSubject =          ApiItem(p: "/cloudprint/student/select-question", apiID: "", d: "选择试题")
        static let conWeb =                 ApiItem(p: "/cloudprint/student/select-variable", apiID: "", d: "类题")
        static let myWrongSubjectList =     ApiItem(p: "/cloudprint/student/myquestion", apiID: "", d: "我的错题")
        static let choiceConSubject =       ApiItem(p: "/cloudprint/select-list", apiID: "", d: "选择类题")
    }
    
}



struct SimpleModel:Codable {
    var code:Int?
    var msg:String = ""
    var data:String?
}

enum DecodeErr: Error {
    case clientErr(code: Int?,reasion: String)
    case serviceErr(reasion: String)
}


extension DecodeErr {
     func show(){
        var str = ""
        switch self {
        case .clientErr( let code, let reasion):
            if code != 401 , !reasion.contains("cancelled") { //取消请求不提示
                print(reasion)
                str = reasion
            } else {
//                ProgressHUD.dismiss()
                return
            }
            
        case .serviceErr(let reasion):
            str = reasion
        }
//        ProgressHUD.showError(str)
    }
    
    var reasion: String {
        switch self {
        case .clientErr( _ , let reasion):
            return reasion
        case .serviceErr(let reasion):
            return reasion
        }
    }
}

enum MediaType {
    case image(type: ImageUploadType)
    case audio(type: AudioUploadType)
}

enum ImageUploadType: String {
    case png = "image/png"
    case jpeg = "image/jpeg"
}
enum AudioUploadType: String {
case AMR = "audio/AMR"
}
//正式服/测试服
enum NetworkType {
case debug,release
}
//普通/ocr
enum FrontType {
case normal,ocr
}

protocol UploadData {
//    associatedtype type
    //音频 "audio/AMR"
    //图片 "image/png"
    var dataMimeType:String { get set }
    var data:Data { get set }
    var uploadName:String { get set }
    var fileName:String { get set }
}

//MARK: - ApiProtocol
protocol ApiProtocol {
    var url:String { get }
    var method:HTTPMethod { get }
    var description: String { get }
    var apiId: String { get }
    var timeoutInterval: Int { get }
}

final class SJSONParameterEncoder:JSONParameterEncoder {
    
}

final class SURLEncodedFormParameterEncoder:URLEncodedFormParameterEncoder {
    
}

//MARK: - ApiItem

struct ApiItem:ApiProtocol {
    var apiId: String
    
    var url: String  {
        switch networkType {
        case .debug:
            switch fType {
            case .normal:
                return API.normalDebugfront + path
            case .ocr:
                return API.ocrDebugFront + path
            }
            
        case .release:
            switch fType {
            case .normal:
                return API.normalReleaseFront + path
            case .ocr:
                return API.ocrReleaseFront + path
            }
        }
        
    }
    
    var method: HTTPMethod = .get
    
    var description: String
    
    var timeoutInterval: Int
    
    private(set) var path:String
    
    var networkType: NetworkType { API.networkType }
    var fType:FrontType
    
    init(fType:FrontType = .normal,p:String,m:HTTPMethod = .get,apiID:String,timeoutInterval:Int = 15,d:String) {
        self.fType = fType
        path = p
        method = m
        description = d
        apiId = apiID
        self.timeoutInterval = timeoutInterval
    }
}
