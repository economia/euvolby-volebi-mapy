require! {
    fs
    async
}
fraction_positions =
    SD: 1
    EPP: 2
    EAF: 3 # freedom + democracy
    EFD: 3 # freedom + democracy
    ID: 3 # idependence + democracy
    G: 4
    ALDE: 5 # liberal democrats
    NI: 6
    NONE: 6
    GUE: 7 # rudy
    ECR: 8 # conservatives & reformists
    UEN: 9 # union for Europe of the Nations
    electorate: 10
    voters: 11

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
better_nuts_existing = {}
(err, files) <~ fs.readdir "#__dirname/../data/download"
countryParties = {}
# output = {}
outputLines = [<[nuts SD EPP EAF G ALDE NI GUE ECR UEN electorate voters]>]
tgtYear = 2004
<~ async.each files, (file, cb) ->
    (err, fileData) <~ fs.readFile "#__dirname/../data/download/#file"
    fileData .= toString!
    country = file.substr 0 2
    countryYear = file.substr 0, 8
    year = parseInt file.substr 4
    if year != tgtYear
        cb!
        return
    cols = columns[countryYear]
    votes_column = null
    cols .= map (name) ->
        name .= replace /\n/g ''
        fraction = parties_fractions["#country-#name"]
        if name.match /\bvalid\b/i
            votes_column := name
        if votes_column == null and (name.match /\bvotes\b/i or name.match /\bvoters\b/i)
            votes_column := name
        {name, fraction, sum: 0}

    lines = fileData.split "\n"
    total = 0
    parties = []
    for line in lines
        fields = line.split "\t"
        output = [0 to 11].map -> 0
        nuts = fields[0].replace /[ ]+/gi ''
        better_nuts_existing[nuts.substr 0, nuts.length - 1] = 1
        if better_nuts_existing[nuts]
            continue
        if country != nuts.substr 0, 2
            continue
        output[0] = nuts
        continue unless nuts
        outputLines.push output
        for col, index in cols
            continue if col.name.match /year/i
            continue if col.name.match /nuts /i
            votes = parseInt fields[index], 10
            continue if not votes
            if fraction_positions[col.fraction]
                output[fraction_positions[col.fraction]] += votes
            else
                if col.name.match /Electorate/i
                    output[fraction_positions['electorate']] = votes
                if col.name == votes_column
                    output[fraction_positions['voters']] = votes



            col.sum += votes
            continue if col.name.match /Electorate/
            continue if col.name.match /\bVotes\b/i
            continue if col.name.match /\bVoters\b/i
            continue if col.name.match /\bValid\b/i
            continue if col.name.match /\Abstentions\b/i
            total += votes
    cols.forEach (col) -> col.percent = col.sum / total
    cols .= filter -> not it.name.match /\Valid\b/i
    cols .= filter -> not it.name.match /\Votes\b/i
    cols .= filter -> not it.name.match /\Voters\b/i
    cols .= filter -> not it.name.match /\Abstentions\b/i
    cols .= filter -> not it.name.match /\Electorate\b/
    validParties = cols.filter -> it.percent > 0.05
    countryParties[country] ?= {}
    validParties.forEach -> countryParties[country][it.name] = "#{Math.round it.percent * 100} -- #{it.sum}"
    # output[country] = {total, cols}
    cb!
csv = outputLines
    .map (line) -> line.join ","
    .join "\n"
fs.writeFile "#__dirname/../data/aggregated-#tgtYear.csv" csv
