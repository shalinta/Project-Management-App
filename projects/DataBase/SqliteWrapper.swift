//
//  SqliteWrapper.swift
//  projects
//
//  Created by chirayu-pt6280 on 22/02/23.
//

import Foundation
import SQLite3


 enum Value {
     
    case double(Double)
     
    case integer(Int64)
     
    case null
     
    case text(String)
}

class Sqlite {
    
//    typealias sqlite_row = Dictionary<String,Value>
    
    
    var connection:OpaquePointer?
    let path:String
    
    init( path: String) {
        self.path = path
    }
    
    
    func closeConnection() {
        sqlite3_close(connection)
    }
    
    func openConnection() {
        
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path)
        
        if  sqlite3_open(fileUrl.path,&connection) == SQLITE_OK {
            print("successfully created dataBase connection to path:\(fileUrl)")
        }
        
        print(#function)
    }
    
    
    func write(query:String,arguments:[Value]) {
        
        var statement:OpaquePointer?
        
        if sqlite3_prepare(connection,query,-1, &statement,nil) == SQLITE_OK {
            
            for (index,argument) in arguments.enumerated() {
                print(index,argument)
                bind(value: argument, to: Int32(index + 1), in: statement)
            }
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("executed query \(query)")
            }
        }
        
        sqlite3_finalize(statement)
    }
    
    
    func read(query:String,arguments:[Value])->Array<Dictionary<String,Any>> {
        
        var statement:OpaquePointer?
        var finalOutput = Array<Dictionary<String,Any>>()
        var rowOutput = Dictionary<String,Any>()
        
        if sqlite3_prepare(connection, query, -1, &statement, nil) == SQLITE_OK {
            
            let columnCount = sqlite3_column_count(statement)
            
            for (index,argument) in arguments.enumerated() {
                bind(value: argument, to: Int32(index + 1), in: statement)
            }
            
            while sqlite3_step(statement) == SQLITE_ROW {
               
                for column in (0..<columnCount) {
                    let name = String(cString: sqlite3_column_name(statement, column))
                    let value =  getValue(for: statement, at: column)
                    rowOutput[name] = value
                }
                
                finalOutput.append(rowOutput)
            }
        }
       
        sqlite3_finalize(statement)
        
        return finalOutput
    }
    
    
//    private func value(for statement: OpaquePointer?, at column: Int32) -> Value? {
//        let type = sqlite3_column_type(statement, column)
//
//        switch type {
//        case SQLITE_FLOAT:
//            return .double(sqlite3_column_double(statement, column))
//        case SQLITE_INTEGER:
//            return .integer(sqlite3_column_int64(statement, column))
//        case SQLITE_NULL:
//            return .null
//        case SQLITE_TEXT:
//            guard let cString = sqlite3_column_text(statement, column) else { return .null }
//            return .text(String(cString: cString))
//        default:
//            return nil
//        }
//    }
    
    
    private func getValue(for statement: OpaquePointer?, at column: Int32) -> Any? {
        let type = sqlite3_column_type(statement, column)
        
        switch type {
        case SQLITE_FLOAT:
            return sqlite3_column_double(statement, column)
        case SQLITE_INTEGER:
            return  Int(sqlite3_column_int64(statement, column))
        case SQLITE_NULL:
            return nil
        case SQLITE_TEXT:
            guard let cString = sqlite3_column_text(statement, column) else { return nil }
            return String(cString: cString)
        default:
            return nil
        }
    }
    
    
    func bind(value: Value, to index: Int32, in statement: OpaquePointer?)  {
        
        let result: Int32
        
        switch value {
        case .double(let double):
            result = sqlite3_bind_double(statement, index, double)
        case .integer(let int):
            result = sqlite3_bind_int64(statement, index, int)
        case .null:
            result = sqlite3_bind_null(statement, index)
        case .text(let text):
            result = sqlite3_bind_text(statement, index,(text as NSString).utf8String, -1, nil)
        }
        
        if SQLITE_OK != result {
            print("cannot bind statement")
        }
    }
    
    
    func execute(query:String) {
        
        var statement:OpaquePointer?
        
        if sqlite3_prepare(connection, query, -1, &statement, nil) == SQLITE_OK {
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("\(query):Executed")
            } else {
                print("unable to execute:\(query)")
            }
        } else {
            print("unable to prepare statement")
        }
        
        sqlite3_finalize(statement)
    }
    
}


//extension Value {
//
//    public var boolValue: Bool? {
//        guard case .integer(let int) = self else {
//            return nil
//            
//        }
//        return int == 0 ? false : true
//    }
//
//
//    public var doubleValue: Double? {
//        guard case .double(let double) = self else {
//            return nil
//
//        }
//        return double
//    }
//
//    public var intValue: Int? {
//        guard case .integer(let int) = self else {
//            return nil
//
//        }
//        return Int(int)
//    }
//
//
//    public var stringValue: String? {
//        guard case .text(let string) = self else {
//            return nil
//
//        }
//        return string
//    }
//
//}
