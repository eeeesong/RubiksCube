
import Foundation

let model = StepOne()

print(SM.info)

let input = readLine() ?? ""
let inputList = model.checkInput(for: input)

guard !inputList.isEmpty else {
    print(SM.inputError)
    exit(0)
}

guard model.checkAction(for: inputList) else {
    print(SM.actionError)
    exit(1)
}

let word = inputList[0]
let moveBy = inputList[1]
let direction = inputList[2]

let result = model.getResult(from: word, by: Int(moveBy)!, to: direction)

print(SM.successMessage(word, moveBy, direction, result))



