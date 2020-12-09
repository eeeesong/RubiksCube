
import Foundation

let model = StepOne()

print("""
    📍변경할 문자(word)
    📍움직일 정도(moveBy) * -100 이상 100 미만의 정수
    📍방향(direction) * 오른쪽: R / 왼쪽: L
    을 공백 포함하여 차례로 입력해주세요.
    """)

let input = readLine() ?? ""

let inputList = model.checkInput(for: input)

guard !inputList.isEmpty else {
    print("값을 모두 입력해주세요")
    exit(0)
}

guard model.checkAction(for: inputList) else {
    print("올바른 값을 입력해주세요")
    exit(1)
}

let word = inputList[0]
let moveBy = inputList[1]
let direction = inputList[2]

let result = model.getResult(word: word, moveBy: Int(moveBy)!, direction: direction)

print("👉🏻 \(word)가 \(moveBy)만큼 \(direction) 방향으로 움직입니다.\n결과: \(result)")



