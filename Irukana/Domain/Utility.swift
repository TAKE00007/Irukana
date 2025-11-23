//
//  Utility.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/23.
//

import CryptoKit
import Foundation

func hashPassword(_ password: String) -> String {
    let data = Data(password.utf8)
    let digest = SHA256.hash(data: data)
    // %x: 1バイトを16進数で表示
    // 02: 2桁になるように0埋め
    // hh: 1バイトとして扱う　→ printf("%x", (int)value)でint(32bit, 64bit)をもらう想定だから1バイトと明示する必要がある
    return digest.map { String(format: "%02hhx", $0) }.joined()
}

