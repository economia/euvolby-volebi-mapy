require! {
    request
    async
    fs
}

datasets = [ \BEEP2009 ]

async.eachSeries datasets, (dataset, cb) ->
    console.log dataset
    (err, response, body) <~ request.get do
        "http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FBEEP2009_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FBEEP2009_Display"
    <~ fs.writeFile "#__dirname/../data/scrape/#{dataset}.html" body
    console.log "Done"
    cb!
