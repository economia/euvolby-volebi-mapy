require! {
    fs
    async
}
columns = fs.readFileSync "#__dirname/../data/columns.json" |> JSON.parse
(err, files) <~ fs.readdir "#__dirname/../data/download"
countryParties = {}
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
    cols.forEach (col) -> col.percent = col.sum / total
    validParties = cols.filter -> it.percent > 0.05
    countryParties[file.substr 0, 2] ?= {}
    validParties.forEach -> countryParties[file.substr 0, 2][it.name] = "?"
    output[file.substr 0, 8] = {total, cols}
    cb!
fs.writeFile "#__dirname/../data/parties.json" JSON.stringify output, yes, 2
fs.writeFile "#__dirname/../data/validParties.json" JSON.stringify countryParties, yes, 2

