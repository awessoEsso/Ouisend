//
//  Soundex.swift
//  YukaTest
// Original code is from: https://github.com/cliffordh/Soundex
//  Created by Esso Awesso on 12/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation

open class Soundex {
    
    private static let en_mapping_string = Array("01230120022455012623010202")
    private static let en_alphabet =       Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private let mapping: [Character:Character] = Soundex.buildMapping(en_alphabet,alphabet:en_mapping_string)
    
    private static func buildMapping(_ codes: Array<Character>, alphabet: Array<Character>) -> [Character:Character] {
        var retval: [Character:Character] = [:]
        for (index,code) in codes.enumerated() {
            retval[code] = alphabet[index]
        }
        return retval
    }
    
    private var soundexMapping: Array<Character> = Array(repeating: " ", count: 4)
    
    private func getMappingCode(_ s: String, index:Int) -> Character {
        
        let char = s[s.index(s.startIndex, offsetBy: index)]
        let mappedChar = mapChar(char)
        guard mappedChar != "0" else { return mappedChar }
        
        if (index>0)
        {
            let prevChar = s[s.index(s.startIndex, offsetBy: index-1)]
            if mapChar(prevChar) == mappedChar {
                return "0"
            }
            
            if (index>1) {
                let preprevChar = s[s.index(s.startIndex, offsetBy: index-2)]
                if (mappedChar == mapChar(preprevChar)) && (prevChar=="H" || prevChar=="W") {
                    return "0"
                }
            }
        }
        
        return mappedChar
    }
    
    private func mapChar(_ c: Character) -> Character {
        if let val = mapping[c] {
            return val
        }
        return "0" // not specified in original Soundex specification, if character is not found, code is 0
    }
    
    open func soundex(_ of: String) -> String {
        
        guard (of.count>0) else {
            return ""
        }
        
        let str=of.uppercased()
        
        var out: Array<Character> = Array("0000")
        var mapped: Character = "0"
        var incount=1
        var count = 1
        
        out[0]=str[str.startIndex]
        while (incount < str.count && count < out.count) {
            mapped = getMappingCode(str, index: incount)
            incount += 1
            if (mapped != "0") {
                out[count]=mapped
                count += 1
            }
        }
        return String(out)
    }
}
