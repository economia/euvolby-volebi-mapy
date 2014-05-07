require! {
    fs
    async
}
base = "#__dirname/../www/tiles"
dirs = fs.readdirSync base
noJsonDirs = dirs.filter -> \json isnt it.substr 0, 4
noJsonDirs.forEach (dir) ->
    (err, subdirs) <~ fs.readdir "#base/#dir"
    subdirs .= filter -> it.length == 1
    subdirs.forEach (subdir) ->
        (err, subsubdirs) <~ fs.readdir "#base/#dir/#subdir"
        subsubdirs.forEach (subsubdir) ->
            (err, files) <~ fs.readdir "#base/#dir/#subdir/#subsubdir"
            files .= filter -> it[* - 1] == "n"
            files.forEach (file) ->
                fs.unlink "#base/#dir/#subdir/#subsubdir/#file"


