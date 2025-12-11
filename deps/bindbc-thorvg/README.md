# bindbc-thorvg
This project provides both static and dynamic bindings to [the ThorVG CAPI library](https://www.thorvg.org/). They are `@nogc` and `nothrow` compatible can be compiled for compatibility with `-betterC`.

**Please note** that this repo's setup is essentially the same as that of [bindbc-freetype](https://github.com/BindBC/bindbc-freetype) developed and maintained by Mike Parker. Since the setup and configurations are the same I took the liberty to copy the `bindbc-freetype` README and just changed the names. **Not all functionality has been fully tested that is written in this README!**.

## Usage
By default, `bindbc-thorvg` is configured to compile as a dynamic binding that is not `-betterC` compatible. The dynamic binding has no link-time dependency on the ThorVG library, so the ThorVG shared library must be manually loaded at  run time. When configured as a static binding, there is a link-time dependency on the ThorVG library&mdash;either the static library or the appropriate file for linking with shared libraries on your platform (see below).

When using DUB to manage your project, the static binding can be enabled via a DUB `subConfiguration` statement in your project's package file. `-betterC` compatibility is also enabled via subconfigurations.

To use ThorVG, add `bindbc-thorvg` as a dependency to your project's package config file. For example, the following is configured to compile `bindbc-thorvg` as a dynamic binding that is not `-betterC` compatible:

__dub.json__
```
dependencies {
    "bindbc-thorvg": "~>1.0.0",
}
```

__dub.sdl__
```
dependency "bindbc-thorvg" version="~>1.0.0"
```

### The dynamic binding
The dynamic binding requires no special configuration when using DUB to manage your project. There is no link-time dependency. At  run time, the ThorVG shared library is required to be on the shared library search path of the user's system. On Windows, this is typically handled by distributing the ThorVG DLL with your program. On other systems, it usually means the user must install the ThorVG shared library through a package manager.

To load the shared library, you need to call the `loadThorVG` function. This returns a member of the `TVGSupport` enumeration (see [the README for `bindbc.loader`](https://github.com/BindBC/bindbc-loader/blob/master/README.md) for the error handling API):

* `TVGSupport.noLibrary` indicating that the library failed to load (it couldn't be found)
* `TVGSupport.badLibrary` indicating that one or more symbols in the library failed to load
* a member of `TVGSupport` indicating a version number that matches the version of ThorVG that `bindbc-thorvg` was configured at compile time to load. By default, that is `TVGSupport.tvg07`, but can be configured via a version identifier (see below). This value will match the global manifest constant, `tvgSupport`.

```d
import bindbc.thorvg;

/*
This version attempts to load the ThorVG shared library using well-known variations
of the library name for the host system.
*/
TVGSupport ret = loadThorVG();
if(ret != tvgSupport) {

    // Handle error. For most use cases, its reasonable to use the the error handling API in
    // bindbc-loader to retrieve error messages for logging and then abort. If necessary, it's
    // possible to determine the root cause via the return value:

    if(ret == TVGSupport.noLibrary) {
        // ThorVG shared library failed to load
    }
    else if(TVGSupport.badLibrary) {
        // One or more symbols failed to load. The likely cause is that the
        // shared library is for a lower version than bindbc-thorvg was configured
        // to load
    }
}
/*
This version attempts to load the ThorVG library using a user-supplied file name.
Usually, the name and/or path used will be platform specific, as in this example
which attempts to load `thorvg.dll` from the `libs` subdirectory, relative
to the executable, only on Windows.
*/
// version(Windows) loadThorVG("libs/thorvg.dll")
```
By default, the `bindbc-thorvg` binding is configured to load ThorVG 0.8. This behavior can be overridden via the `-version` compiler switch or the `versions` DUB directive with the desired ThorVG version number. It is recommended that you always select the minimum version you require _and no higher_.

In this example, the ThorVG dynamic binding is compiled to support ThorVG 0.10:

__dub.json__
```
"dependencies": {
    "bindbc-thorvg": "~>1.0.0"
},
"versions": ["TVG_0_10"]
```

__dub.sdl__
```
dependency "bindbc-thorvg" version="~>1.0.0"
versions "TVG_0_10"
```

With this example configuration, `tvgSupport == TVGSupport.v0_9` after a successful load. If ThorVG 0.9 or later is installed on the user's system, `loadThorVG` will return `TVGSupport.v0_9`. If ThorVG 0.8 is installed, `loadThorVG` will return `TVGSupport.badLibrary`. In this scenario, calling `loadedThorVGVersion()` will return a `TVGSupport` member indicating which version of ThorVG, if any, actually loaded. If a lower version was loaded, it's still possible to call functions from that version of ThorVG, but any calls to functions from higher versions will result in a null pointer access. For this reason, it's recommended to always specify your required version of the ThorVG library at compile time and abort when you receive a `TVGSupport.badLibrary` return value from `loadThorVG`.

No matter which version was configured, the successfully loaded version can be obtained via a call to `loadedThorVGVersion`. It returns one of the following:

* `TVGSupport.noLibrary` if `loadThorVG` returned `TVGSupport.noLibrary`
* `TVGSupport.badLibrary` if `loadThorVG` returned `TVGSupport.badLibrary` and no version of ThorVG successfully loaded
* a member of `TVGSupport` indicating the version of ThorVG that successfully loaded. When `loadThorVG` returns `TVGSupport.badLibrary`, this will be a version number lower than that configured at compile time. Otherwise, it will be the same as the manifest constant `tvgSupport`.

The function `isThorVGLoaded` returns `true` if any version of ThorVG was successfully loaded and `false` otherwise.

Following are the supported versions of ThorVG, the corresponding version IDs to pass to the compiler, and the corresponding `TVGSupport` members.

| Library & Version       | Version ID       | `TVGSupport` Member |
|-------------------------|------------------|---------------------|
|ThorVG 0.8.x and earlier | Default          | `TVGSupport.v0_8`   |
|ThorVG 0.9.x             |                  | `TVGSupport.v0_9`   |
|ThorVG 0.10.x            |                  | `TVGSupport.v0_10`  |

## The static binding
The static binding has a link-time dependency on either the shared or the static ThorVG library. On Windows, you can link with the static library or, to use the shared library (`thorvg.dll`), you can link with the import library. On other systems, you can link with either the static library or directly with the shared library. This requires the ThorVG development package be installed on your system at compile time, either by compiling the ThorVG source yourself, downloading the ThorVG precompiled binaries for Windows, or installing via a system package manager. [See the ThorVG releases page](https://github.com/Samsung/thorvg/releases) or the [Github Actions Workflows](https://github.com/Samsung/thorvg/actions) for details.

When linking with the static library, there is no run-time dependency on ThorVG. When linking with the shared library (or the import library on Windows), the run-time dependency is the same as that of the dynamic binding, the difference being that the shared library is no longer loaded manually&mdash;loading is handled automatically by the system when the program is launched.

Enabling the static binding can be done in two ways.

### Via the compiler's `-version` switch or DUB's `versions` directive
Pass the `BindTVG_Static` version to the compiler and link with the appropriate library.

When using the compiler command line or a build system that doesn't support DUB, this is the only choice. The `-version=BindTVG_Static` option should be passed to the compiler when building your program. All of the required C libraries, as well as the `bindbc-thorvg` and `bindbc-loader` static libraries must also be passed to the compiler on the command line or via your build system's configuration.

When using DUB, set the `BindTVG_Static` version via its `versions` directive. For example:

__dub.json__
```
"dependencies": {
    "bindbc-thorvg": "~>1.0.0"
},
"versions": ["BindTVG_Static"],
"libs": ["thorvg"]
```

__dub.sdl__
```
dependency "bindbc-thorvg" version="~>1.0.0"
versions "BindTVG_Static"
libs "thorvg"
```

When using multiple BindBC packages, the `BindBC_Static` version will enable the static binding for all that support it.

### Via DUB subconfigurations
Instead of using DUB's `versions` directive, a `subConfiguration` can be used. To enable the `static` subconfiguration for the `bindbc-thorvg` dependency:

__dub.json__
```
"dependencies": {
    "bindbc-thorvg": "~>1.0.0"
},
"subConfigurations": {
    "bindbc-thorvg": "static"
},
"libs": ["thorvg"]
```

__dub.sdl__
```
dependency "bindbc-thorvg" version="~>1.0.0"
subConfiguration "bindbc-thorvg" "static"
libs "thorvg"
```

This has the benefit that it completely excludes from the build any source modules related to the dynamic binding, i.e., they will never be passed to the compiler.

## `betterC` support

`betterC` support is enabled via the `dynamicBC` and `staticBC` subconfigurations, for dynamic and static bindings respectively. To enable the dynamic binding with `-betterC` support:

__dub.json__
```
"dependencies": {
    "bindbc-thorvg": "~>1.0.0"
},
"subConfigurations": {
    "bindbc-thorvg": "dynamicBC"
},
"libs": ["thorvg"]
```

__dub.sdl__
```
dependency "bindbc-thorvg" version="~>1.0.0"
subConfiguration "bindbc-thorvg" "dynamicBC"
libs "thorvg"
```

When not using DUB to manage your project, first use DUB to compile the BindBC libraries with the `dynamicBC` or `staticBC` configuration, then pass `-betterC` to the compiler when building your project.
