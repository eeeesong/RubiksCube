

struct CubeAction {
    
    
    func startAction(for action: String, cube: [[String]]) -> [[String]] {
        
        if action == "F" {
            return actionF(isReverse: false, cube: cube)
        } else if action == "F\'" {
            return actionF(isReverse: true, cube: cube)
        } else {
            return actionQ(cube: cube)
        }
    }
    
    
    //MARK: - F
    func actionF(isReverse: Bool, cube: [[String]]) -> [[String]] {
        var cube = cube
        let tryCount = isReverse ? 3 : 1
        
        for _ in 1...tryCount {
            let temp = cube[2]
            
            cube[2] = [cube[11][2],cube[7][2],cube[3][2]]
            
            cube[3][2] = cube[15][0]
            cube[7][2] = cube[15][1]
            cube[11][2] = cube[15][2]
            
            cube[15] = [cube[13][0],cube[9][0],cube[5][0]]
            
            cube[5][0] = temp[2]
            cube[9][0] = temp[1]
            cube[13][0] = temp[0]
        }
        return cube
    }

    
    //MARK: - Q
    func actionQ(cube: [[String]]) -> [[String]] {
        return cube
    }
    
    
}
