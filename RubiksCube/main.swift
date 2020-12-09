
import Foundation

let model = StepOne()

print(SystemMessage.info)

let input = readLine() ?? ""

let inputList = model.checkInput(for: input)

guard !inputList.isEmpty else {
    print(SystemMessage.inputError)
    exit(0)
}

guard model.checkAction(for: inputList) else {
    print(SystemMessage.actionError)
    exit(1)
}

let word = inputList[0]
let moveBy = inputList[1]
let direction = inputList[2]

let result = model.getResult(word: word, moveBy: Int(moveBy)!, direction: direction)

print(SystemMessage.successMessage(word, moveBy, direction, result))



