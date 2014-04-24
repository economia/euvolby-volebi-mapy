require! {
    fs
    async
}
columns = fs.readFileSync "#__dirname/../data/columns.json" |> JSON.parse
(err, files) <~ fs.readdir "#__dirname/../data/download"
# files.length = 1
output = {}
<~ async.each files, (file, cb) ->
    (err, fileData) <~ fs.readFile "#__dirname/../data/download/#file"
    fileData .= toString!
    cols = columns[file.substr 0, 8]
    if not cols
        cb!
        return
    cols .= map (name) -> {name, sum: 0}
    lines = fileData.split "\n"
    total = 0
    parties = []
    for line in lines
        fields = line.split "\t"
        for col, index in cols
            continue if col.name.match /year/i
            continue if col.name.match /nuts /i
            votes = parseInt fields[index], 10
            continue if not votes
            total += votes
            col.sum += votes
    output[file.substr 0, 8] = {total, cols}
    cb!
fs.writeFile "#__dirname/../data/parties.json" JSON.stringify output, yes, 2

