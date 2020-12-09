
import Foundation

struct StepTwo {
    
    var actionList = [String]()
    
    //MARK: - input의 유효성 체크, 액션 리스트 만들기
    mutating func actionCheck(for input: String) -> String {
        
        guard input != "" else { return SystemMessage.inputError }
        
        let stringArray = makeStringArray(for: input)
        let filterArray = makeFilteredAction(for: stringArray)
        
        if filterArray == stringArray {
            actionList = filterArray
            return SystemMessage.noError
        } else {
            return SystemMessage.actionError
        }
    }
    
    
    func makeStringArray(for text: String) -> [String] {
        var stringArray = text.map{ $0.uppercased() }
        
        for (i,v) in stringArray.enumerated() {
            if v == "'" && i > 0 {
                stringArray[i-1].append(v)
                stringArray[i] = "delete"
            } //리버스 입력을 받은 경우 '를 앞의 문자에 붙이고 "delete" 삽입. 그냥 삭제할 경우 index 오류 발생 
        }
        stringArray = stringArray.filter{ $0 != "delete" }
        return stringArray
    }
    
    
    func makeFilteredAction(for array: [String]) -> [String] {
        var filterArray = [String]()
        let allAction = ["U","R","L","B","Q","U\'","R\'","L\'","B\'"]
        
        filterArray = array.filter {(s: String) -> Bool in
            return allAction.contains(s)
        }
        return filterArray
    }
    
    
    //MARK: - 큐브 액션
}
