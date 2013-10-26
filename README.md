openfl-native
============
[![Build Status](https://travis-ci.org/openfl/openfl-native.png)](https://travis-ci.org/openfl/openfl-native)


Install
-------

http://www.openfl.org/developer/documentation/get-started


Development Build
-----------------

    git clone https://github.com/openfl/openfl-native
    haxelib dev openfl-native openfl-native

After cloning, "openfl-native/ndll" will be empty. You may copy the "ndll" folder from a haxelib version of openfl-native (which still may be up-to-date) or you may compile them from the source:

    git clone https://github.com/openfl/openfl-native-dev
    haxelib dev openfl-native-dev openfl-native-dev

To rebuild binaries for a platform, use "openfl rebuild", such as:

    openfl rebuild windows
    openfl rebuild windows,blackberry
    openfl rebuild linux -64
    openfl rebuild android -debug

The default "rebuild" will compile all binaries. You can add "-debug" and "-release" and other flags to specify that you only want to rebuild one kind of binary. You can separate multiple build targets using commas.

There is also a "-rebuild" flag you can use with other OpenFL commands, for fast testing:

    openfl test windows -rebuild

To return to release builds:

    haxelib dev openfl-native
