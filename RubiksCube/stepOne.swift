
import Foundation

struct StepOne {
    
    func getResult(word: String, moveBy: Int, direction: Character) -> String{

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
