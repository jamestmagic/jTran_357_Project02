import Foundation

var pwDict = [String: String]() //dictionary of passphrases and passwords

//Read the JSON file and serialize it to the dictionary
do{
    let fileURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("mypasswords.json")

    let data = try Data(contentsOf: fileURL)
    pwDict = try JSONSerialization.jsonObject(with: data) as! [String : String]
} catch {
    //if the file does not exist, create the file
    do{
        let fileURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("mypasswords.json")

        try JSONSerialization.data(withJSONObject: pwDict).write(to: fileURL)
    } catch {
            print(error)
        }
    }

//Main Program
class Program{
    init(){
        var reply = ""
        var keepRunning = true
        let question = ("Please input the number that corresponds with your chosen action\n[1] View All Password Names\n[2] View Single Password\n[3] Delete Single Password\n[4] Add Single Password\n[5] Quit")
        
        while keepRunning{ //keeps running until user inputs 5 for Quit
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

class Ask{ //Recursive function to constantly check for acceptable responses
    static func AskQuestion(questionText output: String, acceptableReplies inputArr: [String], caseSensitive: Bool = false) -> String{
        print(output)
        
        guard let response = readLine() else{
            print("Invalid Input. Try Again.\n")
            return AskQuestion(questionText: output, acceptableReplies: inputArr)
        }
        
        if(inputArr.contains(response) || inputArr.isEmpty){
            return response
        }else{
            print("Invalid Input. Try Again.\n")
            return AskQuestion(questionText: output, acceptableReplies: inputArr)
        }
        
        
    }
}

//Create Instance and Run Program
let p = Program()

//Adds a passphrase and password to the dictionary
func addSingle(){
    print("Please enter the key name for the password")
    let key = readLine() //reads user input for passphrase
    
    print("Please enter the pasword")
    let password = readLine() //reads user input for password
    
    //Encrypt the password and assign the key to the new encrypted password
    pwDict[key!] = encrypt(passphrase: key!, password: password!)
    print("")
    updateFile() //updates the JSON file to reflect new password
}

//Deletes a passphrase and password pair
func deleteSingle(){
    print("Please enter the key to the password")
    let key = readLine() //reads user input for passphrase
    let keyIsValid = (pwDict[key!] != nil) //Boolean: the key exists in the dictionary
    if keyIsValid{ //if key is valid, set it to nil and update the file
        pwDict[key!] = nil
        updateFile()
    }else{ //if key is invalid, print error
        print("Invalid Key")
    }
    print("")
}

//Prints Single Chosen Password
func viewSingle(){
    print("Please enter the key name for the password")
    let key = readLine() //reads user input for passphrase
    let keyIsValid = (pwDict[key!] != nil) //Boolean: the key exists in the dictionary
    if keyIsValid{ //if key is valid, print the passphrase and decrypted password
        print("Passphrase: " + key!)
        print("Password: " + decrypt(encryptedPassword: pwDict[key!]!, passphrase: key!))
    }else{ //if key is invalid, print error
        print("Invalid Key")
    }
    print("")
    
}

//Prints All Passphrases and Passwords in dictionary
func viewAll(){
    for (kn,_) in pwDict { //iterate through dictionary
        print(kn)
    }
    print("")
}

//Serialize the Dictionary and Write to mypasswords.json in ApplicationsSupport Directory
func updateFile(){
    do{
        let fileURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("mypasswords.json")

        try JSONSerialization.data(withJSONObject: pwDict).write(to: fileURL)
    } catch {
            print(error)
        }
}

//Translates the ASCII values for alpha characters to an encrypted state
func translate(l: Character, trans: Int) -> Character{
    if let ascii = l.asciiValue{
        var outputInt = ascii
        if ascii >= 97 && ascii <= 122{
            outputInt = UInt8((Int(ascii-97)+trans)%26)+97
        }
        else if (ascii >= 65 && ascii <= 98){
            outputInt = UInt8((Int(ascii-65)+trans)%26)+65
        }
        // 65 -> 65 the Character value -> "A"
        return Character(UnicodeScalar(outputInt))
    }
    return Character("")
}

//Encrypts a password
func encrypt(passphrase: String, password: String) -> String{
    let input = (password + passphrase).reversed() //append the passphrase to the password and reverse the full string
    var strShift = ""
    let shift = input.count

    for letter in input{ //translate each letter according to the shift value
        strShift += String(translate(l: letter, trans: shift))
    }
    return strShift
}

//Decrypts a password; takes encrypted password and given passphrase as parameters
func decrypt(encryptedPassword: String, passphrase: String) -> String{
    var strShift = ""
    let passphraseCount: Int = passphrase.count
    var shift: Int
    //if statement finds the absolute difference of the encryptedPassword count and 26 to reverse the encryption
    if encryptedPassword.count > 26{ //checks if the size of the full string is larger than 26; this avoids dealing with negative numbers
        shift = encryptedPassword.count - 26
    }else{
        shift = 26 - encryptedPassword.count
    }
    
    for letter in encryptedPassword{//translates each letter according to the shift value
        strShift += String(translate(l: letter, trans: shift))
    }
    //Passphrase checking
    var passphraseCheck = "" //potential passphrase
    var strCount = 1
    for index in strShift{ //iterates through the full decrypted string to separate the passphrase from the password
        if strCount == passphraseCount+1{ //goes until we reach the passphrase count + 1; string is still reversed so the passphrase is before the password in the full string
            break
        }
        strCount+=1
        passphraseCheck += String(index)
    }
    //Checks if the reversed passphrase matches the key its assigned to
    if String(passphraseCheck.reversed()) == passphrase{ //if they match, then return the password
        strCount = 0
        var password = ""
        for index in strShift.reversed(){ //iterate through unreversed string to separate password
            if strCount == (strShift.count-passphrase.count){
                break
            }
            strCount+=1
            password += String(index)
        }
        return password
    }else{//if they do not match, return error
        print("Passphrase does not match key")
        return "Invalid Key"
    }
}
