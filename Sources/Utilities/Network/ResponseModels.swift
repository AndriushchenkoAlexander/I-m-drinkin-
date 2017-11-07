

import Foundation
import ObjectMapper

typealias ResponseData = [String: AnyObject]

class BaseResponse: Mappable {
    var success     : Bool?
    var description : String?
    var data        : ResponseData?
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        success     <-  map["success"]
        description <-  map["description"]
        data        <-  map["data"]
    }
}
