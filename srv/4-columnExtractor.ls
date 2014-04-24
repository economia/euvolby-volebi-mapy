require! {
    fs
    xml: xml2js
    async
}
(err, files) <~ fs.readdir "#__dirname/../data/variables/"
# files.length = 1
files .= sort (a, b) ->
    | -1 !== a.indexOf "-" => 1
    | -1 !== b.indexOf "-" => -1
    | a > b => 1
    | a < b => -1
    | _     => 0

parties = {}
<~ async.eachSeries files, (file, cb) ->
    nation = file.substr 0 8
    parties[nation] ?= []
    (err, xmlData) <~ fs.readFile "#__dirname/../data/variables/#file"
    (err, data) <~ xml.parseString xmlData
    console.log file
    labels = data["r:RDF"]["p4:Variable3"].map ->
        it['s:label'].0
    parties[nation] ++= labels
    # labels .= filter -> it isnt "Year" and -1 == it.indexOf \NUTS
    # labels.forEach -> parties[nation][it] = "?"
    cb!

fs.writeFile "#__dirname/../data/columns.json" JSON.stringify parties, yes, 2
