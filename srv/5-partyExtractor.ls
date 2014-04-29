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
    country = file.substr 0 2
    countryYear = file.substr 0, 8
    if countryYear != "BEEP2009"
        cb!
        return
    cols = columns[countryYear]
    if not cols
        console.log "NOCOL"
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
            col.sum += votes
            continue if col.name.match /Electorate/
            continue if col.name.match /\bVotes\b/i
            continue if col.name.match /\bVoters\b/i
            continue if col.name.match /\bValid\b/i
            continue if col.name.match /\Abstentions\b/i
            total += votes
    cols.forEach (col) -> col.percent = col.sum / total
    validParties = cols.filter -> it.percent > 0.05
    countryParties[countryYear] ?= {}
    validParties.forEach -> countryParties[countryYear][it.name] = "?#{Math.round it.percent * 100}"
    output[countryYear] = {total, cols}
    cb!
console.log countryParties
fs.writeFile "#__dirname/../data/parties.json" JSON.stringify output, yes, 2
fs.writeFile "#__dirname/../data/validParties.json" JSON.stringify countryParties, yes, 2

