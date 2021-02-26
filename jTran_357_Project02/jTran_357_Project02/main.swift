//
//  main.swift
//  jTran_Project02
//
//  Created by cpsc on 2/15/21.
//

import Foundation

var pwDict = [String: String]()
/*
do{
    let fileURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("mypasswords.json")

    try JSONSerialization.data(withJSONObject: pwDict).write(to: fileURL)
} catch {
        print(error)
    }*/

do{
    let fileURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("mypasswords.json")

    let data = try Data(contentsOf: fileURL)
    pwDict = try JSONSerialization.jsonObject(with: data) as! [String : String]
} catch {
        print(error)
    }

//mainMenu()

//var nameRev = name.reversed()
class Program{
    init(){
        var reply = ""
        var keepRunning = true
        var question = ("Please input the number that corresponds with your chosen action\n[1] View All\n[2] View Single\n[3] Delete Single\n[4] Add Single\n[5] Quit")
        
        while keepRunning{
            reply = Ask.AskQuestion(questionText: question, acceptableReplies: ["1", "2", "3", "4", "5"])
            if reply == "1"{
                viewAll()
            } else if reply == "2"{
                viewSingle()
            }else if reply == "3"{
                deleteSingle()
            }else if reply == "4"{
                addSingle()
            }else if reply == "5"{
                keepRunning = false
            }
        }
    }
}

class Ask{
    static func AskQuestion(questionText output: String, acceptableReplies inputArr: [String], caseSensitive: Bool = false) -> String{
        print(output)
        
        guard let response = readLine() else{
            print("Invalid Input\n")
            return AskQuestion(questionText: output, acceptableReplies: inputArr)
        }
        
        if(inputArr.contains(response) || inputArr.isEmpty){
            return response
        }else{
            print("Invalid Input\n")
            return AskQuestion(questionText: output, acceptableReplies: inputArr)
        }
        
        
    }
}
/*
func mainMenu(){
    while quit == false{
        
        let answer = readLine()
        
        if answer == "1"{
            viewAll()
        } else if answer == "2"{
            viewSingle()
        }else if answer == "3"{
            deleteSingle()
        }else if answer == "4"{
            addSingle()
        }else if answer == "5"{
            quit = true
        }
        
    }
}*/
let p = Program()

func addSingle(){
    print("Please enter the key name for the password")
    let key = readLine()
    
    print("Please enter the pasword")
    let password = readLine()
    
    pwDict[key!] = password
    updateFile()
}

func deleteSingle(){
    print("Please enter the key to the password")
    let key = readLine()
    
    pwDict[key!] = nil
    updateFile()
}

func viewSingle(){
    print("Please enter the key name for the password")
    let key = readLine()
    
    print("PW: \(key)")
    print("PW: \(pwDict[key!])")
    
}

func viewAll(){
    for (kn,pw) in pwDict {
        print(pw)
    }
}


func updateFile(){
    do{
        let fileURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("mypasswords.json")

        try JSONSerialization.data(withJSONObject: pwDict).write(to: fileURL)
    } catch {
            print(error)
        }
}
//Hello

//default case when input is not valid
//print(passwords[""], deafult: "Password not found.")

