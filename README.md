# RubiksCube
## 2단계

> 📍 기본 구성
>
> 1. main: 입/출력을 제어하고 프로그램을 컨트롤합니다
> 2. stepTwo: StepTwo 구조체는 유저의 입력 내용을 검토하고 결과를 반환하는 메소드로 이루어져 있습니다. 또한, 현재 큐브와 입력 받은 액션의 리스트를 배열로 저장합니다.
> 3. systemMessage: SM 구조체는 모든 출력 문자열을 관리합니다



### 0. 프로그램 시작

프로그램이 실행되면 먼저 `StepTwo`의 인스턴스를 생성하고,<br>
입력 안내 메시지와 큐브의 초기 상태를 출력합니다.

```swift
//✏️main.swift
var model = StepTwo()

print(SM.info)
print(SM.startingCube)

//✏️systemMessage.swift
    static let info = """
    ⚡️R/R': 가장 오른쪽 줄 이동
    ⚡️L/L': 가장 왼쪽 줄 이동
    ⚡️U/U': 가장 윗줄 이동
    ⚡️B/B': 가장 아랫 줄 이동
    ⚡️Q: 프로그램 종료
    """
    
    static let startingCube = """
    \n현재 큐브:
     R R W
     G C W
     G B B
    """
```

<br>

그리고 `main()` 함수를 실행시킵니다.<br>`main()`은 유저의 입력을 받아 체크하고 결과 및 오류를 출력하는 역할을 총괄하며, 재귀적으로 호출되어 여러번 실행됩니다.<br>

이때, 프로그램이 종료되지 않도록 하기 위해 맨 아래에 `RunLoop.main.run()`을 첨부하였습니다.

```swift
//✏️main.swift
main()
.
.
.
RunLoop.main.run()
```

<br>

### 1. 입력 내용 체크

`main()`은 제일 먼저 프롬프트를 출력합니다. 프롬프트와 입력란 사이 줄바꿈을 제거하기 위해 `terminator`를 추가하였습니다<br>

`input`에 입력 내용을 저장하고, `actionCheck`를 통해 입력의 타당성을 평가하도록 하였습니다.

```swift
//✏️main.swift
func main() {
    print(SM.prompt, terminator: "")
    
    let input = readLine() ?? ""
    let checkInput = model.actionCheck(for: input)
    ...

//✏️systemMessage.swift
  static let prompt = "\nCUBE👉🏻"
```

<br>

`actionCheck`은 입력을 점검하고 올바른 입력이라면 액션의 리스트를 구조체 내부의 프로퍼티로 저장, `noError`를 반환하며 그렇지 않을 경우 에러를 반환합니다.

만약 입력이 비었다면 `inputError`를 반환하고 아래의 코드를 실행하지 않도록 하였습니다.

공백이 아니라면 두 단계에 걸쳐 `actionList`를 만들어 내도록 작성했습니다.

```swift
//✏️stepTwo.swift
    mutating func actionCheck(for input: String) -> String {
        
        guard input != "" else { return SM.inputError }
        
        let stringArray = makeStringArray(for: input)
        let filterArray = makeFilteredAction(for: stringArray)
        
        if filterArray == stringArray {
            actionList = filterArray
            return SM.noError
        } else {
            return SM.actionError
        }
    }
```

<br>

먼저, `makeStringArray`를 통해 `input`을 액션 단위로 묶어 배열로 만들었습니다.<br>

모든 문자를 대문자로 변환한 뒤 배열화하고, 리버스 액션(R'  등)이 입력됐을 땐 '을 앞의 문자에 붙였습니다. <br>

이때, ' 기호를 전 인덱스에 `append`한 뒤 해당 기호의 인덱스를 바로 삭제하면 '가 연속으로 입력(R''' 등)됐을 때 *Index out of range* 오류가 발생하기 때문에 우선 "delete"로 대체 뒤, 이후 filter로 걸러내 배열을 완성했습니다.

```swift
//✏️stepTwo.swift
    func makeStringArray(for text: String) -> [String] {
        var stringArray = text.map{ $0.uppercased() }
        
        for (i,v) in stringArray.enumerated() {
            if v == "'" && i > 0 {
                stringArray[i-1].append(v)
                stringArray[i] = "delete"
            } 
        }
        stringArray = stringArray.filter{ $0 != "delete" }
        return stringArray
    }
```

<br>

그리고 위에서 만든 `stringArray`의 요소들이 모두 지정된 액션에 부합하는지 체크하고, 부합하지 않는 요소를 걸러낸 배열을 반환하는 `makeFilteredAction`이 실행되도록 하였습니다.<br>

```swift
//✏️stepTwo.swift
    func makeFilteredAction(for array: [String]) -> [String] {
        var filterArray = [String]()
        let allAction = ["U","R","L","B","Q","U\'","R\'","L\'","B\'"]
        
        filterArray = array.filter {(s: String) -> Bool in
            return allAction.contains(s)
        }
        return filterArray
    }
```

<br>

`actionCheck`으로 돌아가서, 만약 위에서 만든 `stringArray`와 `filterArray`가 일치한다면 유효한 액션만이 입력된 것이므로<br>

`actionList`에 `filterArray`를 대입하고 `noError`를 반환, 같지 않다면 `actionError`를 반환하도록 하였습니다.

```swift
//✏️stepTwo.swift
    mutating func actionCheck(for input: String) -> String {
        
        guard input != "" else { return SM.inputError }
        
        let stringArray = makeStringArray(for: input)
        let filterArray = makeFilteredAction(for: stringArray)
        
        if filterArray == stringArray {
            actionList = filterArray
            return SM.noError
        } else {
            return SM.actionError
        }
    }
```

<br>

다시 `main()`으로 돌아가서, 입력에 문제가 있다면 에러 메시지를 출력하고 다시 `main()`을 실행하여 프롬프트를 띄우도록 했습니다.<br>

에러가 없다면 `actionList`를 상수로 가져오고 큐브를 바꾸는 `changeCube `함수를 실행하게 됩니다.

```swift
//✏️main.swift 
    ...
    guard checkInput == SM.noError else {
        print(checkInput)
        return main()
    }

    let actionList = model.actionList
    changeCube(for: model.startingCube, with: actionList)
}

//✏️systemMessage.swift
    static let inputError = "값을 입력해주세요\n" + info
    static let actionError = "올바른 값을 입력해주세요\n" + info
```

<br>

### 2. 액션 리스트를 실행하여 큐브 변경 

main에서 호출되는 `changeCube` 함수는 크게 두 부분으로 나뉩니다.<br>

> 1️⃣ - 액션 리스트의 액션을 순차적으로 실행하고 화면에 출력
>
> 2️⃣ - 모든 액션 종료 후의 큐브를 저장, main 재호출

이때, Timer를 사용하여 각 실행 간 딜레이를 주어 실행 값이 순차적으로 출력되도록 구현하였습니다.<br>마지막 큐브 출력과 동시에 프롬프트가 재등장하는 것이 자연스러우므로 `totalDelayAmount`는 마지막 액션 결과 출력 시간과 같게 설정하였습니다.

```swift
//✏️main.swift 
func changeCube(for cube: [[String]], with actionList: [String]) {
    var cubeNow = cube
    var delayAmount = 0.0
    let totalDelayAmount = Double(actionList.count-1)
  
    //1️⃣
    for action in actionList {
        Timer.scheduledTimer(withTimeInterval: delayAmount , repeats: false) { (timer) in
            cubeNow = getNewCube(with: action, cube: cubeNow)
        }
        delayAmount += 1
    }
    
    //2️⃣
    Timer.scheduledTimer(withTimeInterval: totalDelayAmount, repeats: false) { (timer) in
        model.startingCube = cubeNow
        main()
    }
}
```

<br>

1️⃣의 `getNewCube`는 종료 액션(Q)을 체크하고, 종료 액션을 받았을 시 `quit`을 출력하고 exit합니다.<br>

종료가 아닐 시 model에서 큐브 액션을 동작시킵니다. 또한, 변경된 큐브를 문자열로 바꿔 화면에 출력시키고 다음 액션에 쓰일 큐브를 반환합니다.

```swift
//✏️main.swift 
func getNewCube(with action: String, cube: [[String]]) -> [[String]] {
    guard action != "Q" else {
        print(SM.quit)
        exit(EXIT_SUCCESS)
    }
    let result = model.startAction(with: action, for: cube)
    let resultToString = model.cubeToString(result)
    print(SM.successMessage(action, resultToString))
    return result
}

//✏️systemMessage.swift
    static let quit = "종료 액션 Q가 입력되었습니다. Bye~🙋"
```

<br>

### 2-1. 큐브 액션 분류

`startAction`은 입력받은 각 액션의 케이스를 분류하고 switch문을 통해 각각 다른 값을 반환할 수 있도록 합니다.<br>정방향과 역방향 구분을 위해 `reverseAction` 목록을 생성하여 `action`이 목록에 속한다면 `isReverse` 값을 true로, 정방향이라면 false로 설정하여 전달하도록 하였습니다.

```swift
//✏️stepTwo.swift
    func startAction(with action: String, for cube: [[String]]) -> [[String]] {
        let reverseAction = ["U\'","R\'","L\'","B\'"]
        let isReverse = reverseAction.contains(action) ? true : false

        switch action {
        case "U","U'":
            return actionU(isReverse, cube)
        case "R","R'":
            return actionR(isReverse, cube)
        case "L","L'":
            return actionL(isReverse, cube)
        case "B","B'":
            return actionB(isReverse, cube)
        default:
            return cube
        }
    }
```

<br>

### 2-2. 큐브 액션
step-2의 평면 cube는 **2차원 배열**로 구성하였습니다.<br>현실 세계의 큐브와 비슷한 형식으로 만들어 코드의 전달력을 높이기 위해 2차원 배열에 저장하는 방식을 택했습니다. <br>초깃값은 `StepTwo` 구조체에 선언되어 있습니다.

```swift
//✏️stepTwo.swift
    var startingCube = [
        ["R", "R", "W"],
        ["G", "C", "W"],
        ["G", "B", "B"]
    ]
```

<br>

대표 케이스인 B와 R을 통해 설명하도록 하겠습니다. (U와 L은 각각 B와 R의 역방향)<br>모든 액션은 역방향을 판단하는 불리언과 현재 큐브를 매개변수로 받습니다.<br>큐브의 한 줄은 3개의 셀로 이루어져 있으므로 정방향으로 움직일 경우 1번, 역방향으로 움직일 경우 3 - 1인 2번을 움직이면 됩니다.<br>

`actionB`는 "가장 아랫줄을 오른쪽으로 한 칸 밀기"이므로, 세번째 줄의 세번째 요소를 맨 앞으로 배치하고 마지막 요소를 삭제하는 것으로 구현하였습니다.

```swift
//✏️stepTwo.swift
    func actionB(_ isReverse: Bool,_ cube: [[String]]) -> [[String]] {
        var cube = cube
        let tryCount = isReverse ? 2 : 1
        for _ in 1...tryCount {
            cube[2].insert(cube[2][2], at: 0)
            cube[2].removeLast()
        }
        return cube
    }
```

<br>

`actionR` "가장 오른쪽 줄을 위로 한 칸 밀기"의 이동은 여러 1차원 배열끼리의 이동이 필요하기 때문에, 각각의 줄에서 요소를 이동시킨 뒤 모든 이동이 끝나면 마지막 요소를 삭제하는 것으로 구현하였습니다.<br>

```swift
//✏️stepTwo.swift    
    func actionR(_ isReverse: Bool,_ cube: [[String]]) -> [[String]] {
        var cube = cube
        let tryCount = isReverse ? 2 : 1
        for _ in 1...tryCount {
            cube[2].insert(cube[0][2], at: 2)
            cube[1].insert(cube[2][3], at: 2)
            cube[0].insert(cube[1][3], at: 2)
            cube[0].removeLast()
            cube[1].removeLast()
            cube[2].removeLast()
        }
        return cube
    }
```

<br>

### 2-3. 큐브 -> 문자열 변환

`cubeToString`은 변환이 끝난 큐브를 출력을 위해 문자열로 변환하는 메소드입니다.<br>각 1차원 배열을 공백을 포함한 문자열로 합친 뒤, 합친 결과를 다시 모두 합쳐 단일 문자열로 반환하도록 구현했습니다.

```swift
//✏️stepTwo.swift     
    func cubeToString(_ cube: [[String]]) -> String {
        
        let firstLine = cube[0].reduce(""){ $0 + " " + $1 }
        let secondLine = cube[1].reduce(""){ $0 + " " + $1 }
        let lastLine = cube[2].reduce(""){ $0 + " " + $1 }
        
        return firstLine + "\n" + secondLine + "\n" + lastLine
    }
```

<br>

### 3. 결과 출력

위의 과정이 끝나면 액션 성공 메시지와 함께 변경된 큐브가 출력됩니다

```swift
//✏️main.swift 
func getNewCube(with action: String, cube: [[String]]) -> [[String]] {
    ...
    let result = model.startAction(with: action, for: cube)
    let resultToString = model.cubeToString(result)
    print(SM.successMessage(action, resultToString))
    return result
}

//✏️systemMessage.swift 
    static func successMessage(_ action: String, _ result: String) -> String {
        return "\n액션 \(action)(을)를 적용한 큐브:\n\(result)"
    }
```

<br>

그리고 모든 액션이 끝나면 2️⃣의 내용이 실행됩니다.<br>2차원 배열 형태의 최종 큐브가 `StepTwo`의 `startingCube`에 저장되어 `main()`재실행 시 시작 큐브가 됩니다.

```swift
//✏️main.swift 
func changeCube(for cube: [[String]], with actionList: [String]) {
    .
  	.
  	.
    //2️⃣
    Timer.scheduledTimer(withTimeInterval: totalDelayAmount, repeats: false) { (timer) in
        model.startingCube = cubeNow
        main()
    }
}
```

