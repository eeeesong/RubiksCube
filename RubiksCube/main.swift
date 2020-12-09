
import Foundation

let model = StepTwo()

print(SystemMessage.info)
print(SystemMessage.startingCube)
let input = readLine() ?? ""

//입력이 액션에 합치되는지 점검
//잘못된 입력일 경우 프로그램 종료
//올바른 입력일 경우 차례로 액션 실행
