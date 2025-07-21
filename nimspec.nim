import std/strformat

let compile = @[
"""
  - name: compile
    aliases: [c]
    description: compile project with default code generator C
""",
"""
  - name: r
    description: compile to $nimcache/projname, run with `arguments` using backend specified by `--backend` (default c)
""",
"""
  - name: compileToC
    aliases: [cc]
    description: compile project with C code generator
""",
"""
  - name: compileToCpp
    aliases: [cpp]
    description: compile project to C++ code
""",
"""
  - name: compileToOC
    aliases: [objc]
    description: compile project to Objective C code
""",
]
let js = @[
"""
  - name: js
    description: compile project to Javascript
"""
]
let e = @[
"""
  - name: e
    description: run a Nimscript file
"""
]
let doc = @[
"""
  - name: doc
    description: generate the HTML documentation for inputfile
""",
"""
  - name: doc2tex
    description: generate the documentation for inputfile to LaTeX
""",
"""
  - name: jsondoc
    description: extract the documentation to a json file
""",
]
let rst = @[
"""
  - name: rst2html
    description: convert a reStructuredText file to HTML
""",
"""
  - name: rst2tex
    description: convert a reStructuredText file to TeX
""",
]
let bgc = @[
"""
  - name: buildIndex
    description: build an index for the whole documentation
""",
"""
  - name: genDepend
    description: generate a DOT file containing the module dependency graph
""",
"""
  - name: check
    description: checks the project for syntax and semantic
"""
]
let dump = @[
"""
  - name: dump
    description: dump all defined conditionals and search paths
"""
]
type
  Opts = tuple[flags: string, completion: string]

let codeOpts = (flags:
"""
      -f, --forceBuild: force rebuilding of all modules
      --stackTrace=: enable stack tracing (on off)
      --lineTrace=: enable line tracing (on off)
      --threads=: enable support for multi-threading (on off)
      -x, --checks=: enable/disable all runtime checks (on off)
      --objChecks=: enable obj conversion checks (on off)
      --fieldChecks=: enable case variant field checks (on off)
      --rangeChecks=: enable range checks (on off)
      --boundChecks=: enable bound checks (on off)
      --overflowChecks=: enable integer over-/underflow checks (on off)
      -a, --assertions=: enable assertions (on off)
      --floatChecks=: enable floating point (NaN/Inf) checks (on off)
      --nanChecks=: enable NaN checks (on off)
      --infChecks=: enable Inf checks (on off)
      --nilChecks=: enable nil checks (on off)
      --expandArc: show how given proc looks before final backend pass
      --expandMacro: dump every generated AST from given macro
""",
completion: """
        stackTrace: ["on", "off"] 
        lineTrace: ["on", "off"] 
        threads: ["on", "off"] 
        checks: ["on", "off"] 
        objChecks: ["on", "off"] 
        fieldChecks: ["on", "off"] 
        rangeChecks: ["on", "off"] 
        boundChecks: ["on", "off"] 
        overflowChecks: ["on", "off"] 
        assertions: ["on", "off"] 
        floatChecks: ["on", "off"] 
        nanChecks: ["on", "off"] 
        infChecks: ["on", "off"] 
        nilChecks: ["on", "off"]
""")

let runOpts = (flags:
"""
      -r, --run: run the application
""",
completion: "")

let cond = """["release", "danger", "mingw", "androidNDK", "useNimRtl", "useMalloc", "noSignalHandler", "ssl", "debug", "leanCompiler", "gcDestructors"]"""
let sharedOpts = (flags:
"""
      -d, --define=: define a conditional symbol
      -u, --undef=: undefine a conditional symbol
      -p, --path=: add path to search paths
      --verbosity=: set verbosity level (default 1)
      --hints=: print compilation hints? (or `list`)
""",
completion: fmt"""
        define: {cond}
        undef: {cond}
""" & """
        path: ["$files"]
        verbosity: ["$carapace.number.Range({start: 0, end: 3})"]
        hints: ["on", "off", "list"]
""")
let nativeOpts = (flags:
"""
      --opt=: optimization mode (none speed size)
      --debugger=: native[use native debugger (gdb)]
      --app=: generate this type of app (lib=dynamic) (console gui lib staticlib)
      --cpu=: target architecture (alpha amd64 arm arm64 avr e2k esp hppa i386 ia64 js loongarch64 m68k mips mipsel mips64 mips64el msp430 nimvm powerpc powerpc64 powerpc64el riscv32 riscv64 sparc sparc64 vm wasm32)
      --gc=: memory management algorithm to use (default refc) (refc arc orc markAndSweep boehm go regions none)
      --os=: operating system to compile for (AIX Amiga Android Any Atari DOS DragonFly FreeBSD FreeRTOS Genode Haiku iOS Irix JS Linux MacOS MacOSX MorphOS NetBSD Netware NimVM NintendoSwitch OS2 OpenBSD PalmOS Standalone QNX SkyOS Solaris VxWorks Windows)
      --panics=: turn panics into process termination (default off) (off on)
""",
completion: """
        opt: ["none", "speed", "size"]
        debugger: ["native"]
        app: ["console", "gui", "lib", "staticlib"]
        cpu: ["alpha", "amd64", "arm", "arm64", "avr", "e2k", "esp", "hppa", "i386", "ia64", "js", "loongarch64", "m68k", "mips", "mipsel", "mips64", "mips64el", "msp430", "nimvm", "powerpc", "powerpc64", "powerpc64el", "riscv32", "riscv64", "sparc", "sparc64", "vm", "wasm32"]
        gc: ["refc", "arc", "orc", "markAndSweep", "boehm", "go", "regions", "none"]
        os: ["AIX", "Amiga", "Android", "Any", "Atari", "DOS", "DragonFly", "FreeBSD", "FreeRTOS", "Genode", "Haiku", "iOS", "Irix", "JS", "Linux", "MacOS", "MacOSX", "MorphOS", "NetBSD", "Netware", "NimVM", "NintendoSwitch", "OS2", "OpenBSD", "PalmOS", "Standalone", "QNX", "SkyOS", "Solaris", "VxWorks", "Windows"]
        panics: ["off", "on"]
""")
let docOpts = (flags:
"""
      --index=: enable index .idx files
      --project=: output any dependency for doc
      --docInternal=: generate module-private documentation
""",
completion: """
        index: ["off", "on"]
        project: ["off", "on"]
        docInternal: ["off", "on"]
""")

let flagsV = """
    flags:
"""
let completionV = """
    completion:
      flag:
"""
proc positional(fileExt: string): string =
  var g = ""
  if fileExt != "":
    g = fmt"([{fileExt}])"
  result = fmt"""
      positional:
        - ["$files{g}"]
"""
proc buildOpts(comands: seq[string], opts: seq[Opts], positionalType: string): string =
  for comand in comands:
    result.add(comand)
    result.add(flagsV)
    for opt in opts:
      result.add(opt.flags)
    result.add(completionV)
    for opt in opts:
      result.add(opt.completion)
    result.add(positionalType)
  result
  
let spec: string = """
name: nim
description: nim-lang compilator
flags:
  -h, --help: show this help
  -v, --version: show detailed version information
  --fullhelp: show all command line switches
completion:
  flag:
    opt: ["none", "speed", "size"]
commands:
""" & buildOpts(
    compile,
    @[codeOpts, runOpts, sharedOpts, nativeOpts],
    positional(".nim")
  ) & buildOpts(
    js,
    @[codeOpts, runOpts, sharedOpts],
    positional(".nim")
  ) & buildOpts(
    e,
    @[codeOpts, runOpts, sharedOpts],
    positional(".nims")
  ) & buildOpts(
    doc,
    @[runOpts, sharedOpts],
    positional(".nim")
  ) & buildOpts(
    rst,
    @[runOpts, sharedOpts, docOpts],
    positional(".rst")
  ) & buildOpts(
    bgc,
    @[sharedOpts],
    positional(".nim")
  ) & buildOpts(
    dump,
    @[sharedOpts],
    positional("")
  )

let file = "./specs/nim.yaml"
writeFile(file, spec)
