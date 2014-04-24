require! {
    fs
    $: "node-jquery"
    async
}

(err, data) <~ fs.readdir "#__dirname/../data/scrape"
# data.length = 5
(err, tables) <~ async.map data, (filename, cb) ->
    (err, file) <~ fs.readFile "#__dirname/../data/scrape/#filename"
    $file = $ file.toString!
    $table = $file.find "table.matrix"
        ..find "ul" .remove!
    tc = $table.html!
    out = "<h2>#filename</h2><table>#tc</table>"
    cb null out
fs.writeFile "#__dirname/../data/tables.html", "<meta charset='utf-8'>" + tables.join ""
