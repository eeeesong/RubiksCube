# RubiksCube

## 1단계

> 📍 기본 구성
>
> 1. main: 입/출력을 제어하고 프로그램을 컨트롤합니다
> 2. stepOne: StepOne 구조체는 유저의 입력 내용을 검토하고 결과를 반환하는 메소드로 이루어져 있습니다
> 3. systemMessage: SM 구조체는 모든 출력 문자열을 관리합니다

<br>

### 0. 안내 메시지 출력

프로그램이 실행되면 먼저 `StepOne`의 인스턴스를 생성합니다. <br>그리고 입력 안내 메시지를 출력합니다.

```swift
//✏️main.swift
let model = StepOne()

print(SM.info)

//✏️systemMessage.swift
    static let info = """
    1️⃣ 변경할 문자(word)
    2️⃣ 움직일 정도(moveBy) * -100 이상 100 미만의 정수
    3️⃣ 방향(direction) * 오른쪽: R / 왼쪽: L

    1️⃣,2️⃣,3️⃣을 공백 포함하여 차례로 입력해주세요.

    """
```

<br>

### 1. 입력 개수 점검

유저가 입력을 실행하면 먼저 `readLine()`을 통해 읽은 내용을 `input`에 저장합니다.<br>
그리고 `stepOne` 구조체의 `checkInput` 메소드를 통해 `input`의 개수를 체크합니다. 

```swift
//✏️main.swift
let input = readLine() ?? ""
let inputList = model.checkInput(for: input)
```

<br>

이때 입력 내용이 없는 경우 바로 빈 배열을 리턴하고,<br>
요소가 3개 미만인 경우에도 빈 배열을 리턴하도록 하여 값이 덜 입력된 경우를 전부 잡아낼 수 있도록 했습니다. 

```swift
//✏️stepOne.swift
    func checkInput(for input: String) -> [String] {
        
        guard input != "" else {
            return []
        }
        
        let inputList = input.components(separatedBy: " ")
        
        return inputList.count == 3 ? inputList : []
    }
```
<br>


`inputList`가 빈 배열이라면 프로그램은 `inputError` 메시지를 출력하고 프로그램을 종료합니다.

```swift
//✏️main.swift
guard !inputList.isEmpty else {
    print(SM.inputError)
    exit(0)
}

//✏️systemMessage.swift
  static let inputError = "값을 모두 입력해주세요"
```

<br>

### 2. 액션 내용 검토

`inputList`가 빈 배열이 아니라면 `checkAction`을 통해 입력 내용을 검토합니다.<br>
만약 `checkAction`이 false를 리턴하였다면 `actionError` 메시지를 출력하고 종료합니다.

```swift
//✏️main.swift
guard model.checkAction(for: inputList) else {
    print(SM.actionError)
    exit(1)
}

//✏️systemMessage.swift
  static let actionError = "올바른 값을 입력해주세요"
```
<br>


`checkAction`은 `inputList`의 2,3번째 요소에 대한 점검을 진행합니다.<br>`
direction` 값은 소/대문자가 같은 입력으로 인식되어도 무방하기 때문에 `uppercased()`를 적용하였습니다.<br>
2번째 요소가 Int 값이 아니거나 범위 바깥인 경우, 3번째 요소가 R이나 L 외의 문자라면 false를 리턴하고 <br>
모든 조건에 문제가 없을 경우 true를 리턴하여 프로그램이 이어질 수 있도록 했습니다.

```swift
//✏️stepOne.swift
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
```

<br>

### 3. 입력 내용을 통해 결과 추출하기

일련의 과정을 통해 `inputList`의 값 점검이 끝나면 각각 다른 상수에 배당하고<br>배당한 값을 `getResult`의 전달인자로 전달하여 메소드를 실행합니다.

```swift
//✏️main.swift
let word = inputList[0]
let moveBy = inputList[1]
let direction = inputList[2]

let result = model.getResult(from: word, by: Int(moveBy)!, to: direction)
```
<br>


`remainder` 상수에 `moveBy`의 절댓값을 `word`의 글자수로 나눈 **나머지**를 지정하였습니다.<br>만약 움직이려는 값이 글자수와 같거나 글자수의 배수라면 (나머지가 0)<br>어느 방향으로 움직이든 원래의 글자와 같은 값이 되기 때문에 원래의 `word`를 그대로 리턴하도록 하였습니다.

```swift
//✏️stepOne.swift
    func getResult(from word: String, by moveBy: Int, to direction: String) -> String {

        let remainder = abs(moveBy) % word.count
        if remainder == 0 { return word } //변동 없는 경우 그대로 출력
        
        ...
```

<br>

그 외의 경우는 word의 각 문자를 담은 배열을 조작하는 방식으로 구현하였습니다.<br>

움직이는 방향은 `direction`이 R(정방향)일 땐 `moveBy`의 부호를 변경하지 않고, L(역방향)일 경우 `moveBy`에 -1을 곱해 부호를 전환하여 leftOrRight에 지정하였습니다.<br>만약 `leftOrRight`이 정방향(양수)인 경우 위에서 구한 `remainder`만큼 움직이고, 역방향(음수)인 경우 `word`의 글자수에서 `remainder`를 뺀 만큼 움직이는 것으로 하여 `moveAmount`에 지정하였습니다.<br>

> APPLE을 1만큼 움직이는 경우와 -4만큼 움직이는 경우가 같기 때문에(EAPPL) 위의 방식으로 계산하였습니다.

<br>

0에서 시작한 `moveCount`가 `moveAmount`와 같아질 때까지 `word`의 각 문자로 이루어진 배열을 조작하도록 하였습니다.<br>`word`의 마지막 문자가 `word`의 맨 앞으로 끼워 넣어지고, 마지막 요소를 삭제하는 방식으로 밀어내기를 구현하였습니다.<br>조작이 끝나면 각 문자를 `reduce`를 통해 하나의 문자열로 합친 `result`를 반환하도록 하였습니다.

```swift
        ...
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
        let result = characterArray.reduce(""){ String($0) + String($1) }
        return result
    }
```

<br>

그리고 반환된 `result`가 다른 설정 값들과 함께 성공 메시지로 출력된 후 프로그램이 종료됩니다.

```swift
//✏️main.swift
print(SM.successMessage(word, moveBy, direction, result))

//✏️systemMessage.swift
    static func successMessage(_ word: String, _ moveBy: String, _ direction: String,
                               _ result: String) -> String {
        return """

            👉🏻 \(word)가 \(moveBy)만큼 \(direction) 방향으로 움직입니다.
            결과: \(result)

            """
    }
```

