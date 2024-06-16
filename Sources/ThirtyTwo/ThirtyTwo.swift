//  ThirtyTwo.swift. Created by YUH APPS.
//  A Swift port from https://github.com/chrisumbel/thirty-two/blob/master/lib/thirty-two/index.js
    

import Foundation

var charTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
var byteTable = [
    0xff, 0xff, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
    0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e,
    0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16,
    0x17, 0x18, 0x19, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
    0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e,
    0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16,
    0x17, 0x18, 0x19, 0xff, 0xff, 0xff, 0xff, 0xff
]

func quintetCount(_ buff: Data) -> Int {
    let quintets = Int(floor(Double(buff.count / 5)))
    return buff.count % 5 == 0 ? quintets : quintets + 1
}

func thirtyTwoEncode(_ plain: Data) -> Data {
    var i = 0
    var j = 0
    var shiftIndex = 0
    var digit: UInt8 = 0
    var encoded = Data(count: quintetCount(plain) * 8) // NodeJS counterpart: Buffer.alloc(quintetCount(plain) * 8)
    while (i < plain.count) {
        let current = plain[i]
        if (shiftIndex > 3) {
            digit = current & (0xff >> shiftIndex)
            shiftIndex = (shiftIndex + 5) % 8
            digit = (digit << shiftIndex) | ((i + 1 < plain.count) ?
                plain[i + 1] : 0) >> (8 - shiftIndex)
            i += 1
        }
        else {
            digit = (current >> (8 - (shiftIndex + 5))) & 0x1f
            shiftIndex = (shiftIndex + 5) % 8
            if (shiftIndex == 0) {
                i += 1
            }
        }
        let d = charTable.utf16.index(charTable.utf16.startIndex, offsetBy: Int(digit))
        encoded[j] = UInt8(charTable.utf16[d])
        j += 1
    }
    for i in j...encoded.count-1 {
        encoded[i] = 0x3d
    }
    return encoded
}

func thirtyTwoDecode(_ encoded: Data) -> Data? {
    if encoded.count == 0 {
        return nil
    }
    var shiftIndex = 0
    var plainDigit: UInt8 = 0
    var plainChar: UInt8 = 0
    var plainPos = 0
    var decoded = Data(count: Int(ceil(Double(encoded.count * 5 / 8))))
    for i in 0...encoded.count-1 {
        if (encoded[i] == 0x3d) { //'='
            break
        }
        let encodedByte = encoded[i] &- 0x30
        if (encodedByte < byteTable.count) {
            plainDigit = UInt8(byteTable[Int(encodedByte)])
            if (shiftIndex <= 3) {
                shiftIndex = (shiftIndex &+ 5) % 8
                if (shiftIndex == 0) {
                    plainChar |= plainDigit
                    decoded[plainPos] = plainChar
                    plainPos &+= 1
                    plainChar = 0
                } else {
                    plainChar |= 0xff & (plainDigit << (8 &- shiftIndex))
                }
            } else {
                shiftIndex = (shiftIndex &+ 5) % 8
                plainChar |= 0xff & (plainDigit >> shiftIndex)
                decoded[plainPos] = plainChar
                plainPos &+= 1
                plainChar = 0xff & (plainDigit << (8 &- shiftIndex))
            }
        } else {
            return nil // Error('Invalid input - it is not base32 encoded string')
        }
    }
    return decoded.prefix(plainPos)
}
