import Cocoa
import Foundation

var pwDict = [String: String]()

mainMenu()


func mainMenu(){
    print("Main Menu")
    print("[1] View All")
    print("[2] View Single")
    print("[3] Delete Single")
    print("[4] Add Single")
}

func addSingle(){
    print("Please enter the passphrase")
    let passphrase = readLine()
    
    print("Please enter the pasword")
    let password = readLine()
    
    pwDict[passphrase!] = password
}

func deleteSingle(){
    print("Please enter the passphrase")
    let passphrase = readLine()
    
    pwDict.removeValue(forKey: passphrase!)
    
}

func viewSingle(){
    print("Please enter the passphrase")
    let passphrase = readLine()
    
    print("Please enter your pasword")
    let password = readLine()
    
    print("PW: \(pwDict[passphrase!])")
    
}

func viewAll(){
    for (pp,pw) in pwDict {
        print(pw)
    }
}

//Hello

//default case when input is not valid
//print(passwords[""], deafult: "Password not found.")

