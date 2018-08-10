//
//  main.swift
//  identity
//
//  Created by Antti Tulisalo on 10/08/2018.
//  Copyright © 2018 Antti Tulisalo. All rights reserved.
//

import Foundation

let args = CommandLine.arguments
let argCount = CommandLine.arguments.count
var errorFlag = true

// Check if there is incompatible number of arguments
if(argCount == 2 || argCount == 3) {
    errorFlag = false
}

if(errorFlag) {
    print("identity: macOS command line utility that checks users group memberships and group guids\n");
    print("         Usage:");
    print("         identity <group_name>               Get gid based on group name");
    print("         identity <user_name> <gid>          Check (true/false) if user belongs to a group");
    exit(EXIT_FAILURE)
}

let identity = Identity()

if(argCount==2) {
    
    guard let gid = identity.getGroupID(groupName: args[1]) else {
        print("No such group")
        exit(1)
    }
    print(gid)
}

if(argCount==3) {

    guard let gid = Int(args[2]) else {
        print("Wrong input parameter type")
        exit(1)
    }
        print(identity.checkMembership(user: args[1], gid: gid))
}

exit(0)
