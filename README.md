# identity

macOS command line tool example of using [Collaboration Framework's](https://developer.apple.com/documentation/collaboration) Identity classes using Swift. Inspiration and partial port from Privileges' [MTIdentity class](https://github.com/SAP/macOS-enterprise-privileges/blob/master/source/MTIdentity.m)

```
$ ./identity 
identity: macOS command line utility that checks users group memberships and group guids

         Usage:
         identity <group_name>               Get gid based on group name
         identity <user_name> <gid>          Check (true/false) if user belongs to a group
```

You can test the tool by listing macOS's users and groups using these commands:

`$ dscl . list /users`

`$ dscl . list /groups`

