
struct StepThree {
    
    let cubeSolved = [
                                ["B", "B", "B"],
                                ["B", "B", "B"],
                                ["B", "B", "B"],
        
        ["W", "W", "W"], ["O", "O", "O"], ["G", "G", "G"], ["Y", "Y", "Y"],
        ["W", "W", "W"], ["O", "O", "O"], ["G", "G", "G"], ["Y", "Y", "Y"],
        ["W", "W", "W"], ["O", "O", "O"], ["G", "G", "G"], ["Y", "Y", "Y"],
        
                                ["R", "R", "R"],
                                ["R", "R", "R"],
                                ["R", "R", "R"]
    ]
    
    var startingCube = [[String]]()
    var actionList = [String]()
    
    
    //MARK: - 입력 액션 점검
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
    
    
    func makeStringArray(for text: String) -> [String] {
        var stringArray = text.map{ String($0) }
        
        for (i,v) in stringArray.enumerated() {
            if v == "'" || v == "2", i > 0 {
                stringArray[i-1].append(v)
                stringArray[i] = "delete"
            }
        }
        stringArray = stringArray.filter{ $0 != "delete" }
        return stringArray
    }
    
    
    func makeFilteredAction(for array: [String]) -> [String] {
        var filterArray = [String]()
        let allAction = ["F","F\'","F2",
                         "R","R\'","R2",
                         "U","U\'","U2",
                         "B","B\'","B2",
                         "L","L\'","L2",
                         "D","D\'","D2",
                         "Q"]
        
        filterArray = array.filter {(s: String) -> Bool in
            return allAction.contains(s)
        }
        return filterArray
    }

    
    //MARK: - 큐브 -> 문자열 변경
    func cubeToString(_ cube: [[String]]) -> String {

        let firstLineA = cube[0].reduce(""){ $0 + " " + $1 }
        let firstLineB = cube[1].reduce(""){ $0 + " " + $1 }
        let firstLineC = cube[2].reduce(""){ $0 + " " + $1 }
        let secondLineA = flatMultiLine(cube, startFrom: 3).reduce(""){ $0 + " " + $1 }
        let secondLineB = flatMultiLine(cube, startFrom: 7).reduce(""){ $0 + " " + $1 }
        let secondLineC = flatMultiLine(cube, startFrom: 11).reduce(""){ $0 + " " + $1 }
        let lastLineA = cube[15].reduce(""){ $0 + " " + $1 }
        let lastLineB = cube[16].reduce(""){ $0 + " " + $1 }
        let lastLineC = cube[17].reduce(""){ $0 + " " + $1 }
        
        let space = "\t\t\t\t"
        
        return """
            \(space)\(firstLineA)\n\(space)\(firstLineB)\n\(space)\(firstLineC)\n
            \(secondLineA)\n\(secondLineB)\n\(secondLineC)\n
            \(space)\(lastLineA)\n\(space)\(lastLineB)\n\(space)\(lastLineC)
            """
    }
    
    func flatMultiLine(_ cube: [[String]], startFrom arrayNum: Int) -> [String] {
    
        var cubeToChange = cube
        var result = [String]()
        let space = "\t  "
        
        for a in arrayNum...arrayNum+3 {
            cubeToChange[a].append(space)
            result.append(contentsOf: cubeToChange[a])
        }
        return result
    }
}
