//
//  Identity.swift
//  identity
//
//  Created by Antti Tulisalo on 10/08/2018.
//  Copyright © 2018 Antti Tulisalo. All rights reserved.
//

import Foundation
import Collaboration

struct Identity {

    /// Check if user belongs to a group
    ///
    /// - parameters:
    ///     - String: User name
    ///     - Int: Group gid
    /// - returns:
    ///     - Bool: User either does or does not belong to a gid
    func checkMembership(user: String, gid: Int) -> Bool {
        
        var isMemberOfGroup = false
        
        // 1. Get user identity
        guard let userIdentity = CBIdentity(name: user, authority: CBIdentityAuthority.default()) else {
                NSLog("com.github.suolapeikko.identity: User identity not found")
                return false
        }
        
        // 2. Get group identity
        guard let groupIdentity = CBGroupIdentity(posixGID: gid_t(gid), authority: CBIdentityAuthority.local()) else {
            NSLog("com.github.suolapeikko.identity: User identity not found")
            return false
        }
        
        if(userIdentity.isMember(ofGroup: groupIdentity)) {
            isMemberOfGroup = true
        }
        
        return isMemberOfGroup
    }
    
    /// Get group gid based on group name
    ///
    /// - parameters:
    ///     - String: Group name (eg. admin)
    /// - returns:
    ///     - Int?: optional group id
    func getGroupID(groupName: String) -> Int? {
        
        var gid: Int?
        var error: Unmanaged<CFError>?
        
        // 1. Create a query
        guard let groupQuery = CSIdentityQueryCreateForName(kCFAllocatorDefault, groupName as CFString, kCSIdentityQueryStringEquals, kCSIdentityClassGroup, CSGetLocalIdentityAuthority().takeUnretainedValue()) else {
            
            NSLog("com.github.suolapeikko.identity: Query creation failed")
            return gid
        }
        
        // 2. Execute query and manage possible errors
        let status = CSIdentityQueryExecute(groupQuery.takeUnretainedValue(), UInt(kCSIdentityQueryIncludeHiddenIdentities), &error)
        
        if(!status) {
            let errorDict = CFErrorCopyUserInfo(error?.takeRetainedValue()) as Dictionary
            let errorMessage = errorDict.values.first as! String
            NSLog("com.github.suolapeikko.identity: Query execution failed with: \(errorMessage)")
            
            return gid
        }
        
        // 3. Manage query results
        guard let groupQueryResults = CSIdentityQueryCopyResults(groupQuery.takeRetainedValue()) else {
            
            NSLog("com.github.suolapeikko.identity: Query result copy failed")
            
            return gid
        }
        
        if (CFArrayGetCount(groupQueryResults.takeUnretainedValue() as CFArray) == 1) {
            let groupIdentity = CFArrayGetValueAtIndex(groupQueryResults.takeUnretainedValue(), 0)
            let ref = unsafeBitCast(groupIdentity, to: CSIdentity.self)
            gid = Int(CSIdentityGetPosixID(ref))
        }
        
        return gid
    }
}
