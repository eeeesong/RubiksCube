
import Foundation

struct StepOne {
    
    func checkInput(for input: String) -> [String] {
        
        guard input != "" else {
            return []
        }
        
        let inputList = input.components(separatedBy: " ")
        
        return inputList.count == 3 ? inputList : []
    }
    
    
    func checkAction(for inputList: [String]) -> Bool {

        let moveBy = inputList[1]
        let direction = inputList[2].uppercased()

        guard let int = Int(moveBy),
              int >= -100, int < 100,
              direction == "R" || direction == "L"
        else {
            return false
        }
    
        return true
    }
    
    
    func getResult(word: String, moveBy: Int, direction: String) -> String {

        let remainder = abs(moveBy) % word.count
        
        if remainder == 0 { return word } //변동 없는 경우 그대로 출력
        
        var characterArray = word.map{ $0 }
        let leftOrRight = direction == "R" ? moveBy : moveBy * -1
        let moveAmount = leftOrRight > 0 ? remainder : word.count - remainder

        var moveCount = 0
        let lastIndex = word.count-1
        
        while moveCount < moveAmount {
            characterArray.insert(characterArray[lastIndex], at: 0)
            characterArray.removeLast()
            moveCount += 1
        }

        let result: String = characterArray.reduce(""){ String($0) + String($1) }
        
        return result
    }
}
