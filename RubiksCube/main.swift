
import Foundation

print("""
    📍변경할 문자(word)
    📍움직일 정도(moveBy) * -100 이상 100 미만의 정수
    📍방향(direction) * 오른쪽: R / 왼쪽: L
    을 공백 포함하여 차례로 입력해주세요.
    """)

let input = readLine() ?? ""

let word = input.components(separatedBy: " ")[0]
let moveBy = input.components(separatedBy: " ")[1]
let direction = input.components(separatedBy: " ")[2]

print("👉🏻 \(word)가 \(moveBy)만큼 \(direction) 방향으로 움직입니다.")



