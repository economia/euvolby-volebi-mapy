require! {
    fs
    async
}
columns = fs.readFileSync "#__dirname/../data/columns.json" |> JSON.parse
columns_manual = fs.readFileSync "#__dirname/../data/columns_manual.json" |> JSON.parse
parties_fractions = {}
fs.readFileSync "#__dirname/../data/party_fractions.txt" .toString!
    .split "\n"
    .forEach (line) ->
        line .= replace /\r/g ''
        [nation, party, fraction] = line.split "\t"
        return unless nation
        parties_fractions["#{nation}-#{party}"] = fraction

for col, data of columns_manual
    columns[col] = data
(err, files) <~ fs.readdir "#__dirname/../data/download"
countryParties = {}
output = {}
<~ async.each files, (file, cb) ->
    (err, fileData) <~ fs.readFile "#__dirname/../data/download/#file"
    fileData .= toString!
    country = file.substr 0 2
    countryYear = file.substr 0, 8
    cols = columns[countryYear]
    if not cols
        console.log "NOCOL"
        cb!
        return
    cols .= map (name) ->
        name .= replace /\n/g ''
        {name, sum: 0}
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
    cols .= filter -> not it.name.match /\bvotes\b/i
    cols .= filter -> not it.name.match /\Valid\b/i
    cols .= filter -> not it.name.match /\Votes\b/i
    cols .= filter -> not it.name.match /\Voters\b/i
    cols .= filter -> not it.name.match /\Abstentions\b/i
    cols .= filter -> not it.name.match /\Electorate\b/
    validParties = cols.filter -> it.percent > 0.05
    countryParties[country] ?= {}
    validParties.forEach -> countryParties[country][it.name] = "#{Math.round it.percent * 100} -- #{it.sum}"
    output[country] = {total, cols}
    cb!

for nation, parties of countryParties
    for party of parties
        id = "#nation-#party"
        if not parties_fractions[id]
            console.log "#nation\t#party\t"
# console.log countryParties
fs.writeFile "#__dirname/../data/parties.json" JSON.stringify output, yes, 2
fs.writeFile "#__dirname/../data/validParties.json" JSON.stringify countryParties, yes, 2

