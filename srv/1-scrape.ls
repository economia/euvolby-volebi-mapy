require! {
    request
    async
    fs
}

nations = <[CZ CY CR AT BE BL DK EE FI FR DE GR HU IS IE IT LA LI LT LU MA MT NL PL PT RO SK SI ES UK]>
datasets = []
nations.forEach ->
    datasets.push "#{it}EP2004"
    datasets.push "#{it}EP2009"

async.eachSeries datasets, (dataset, cb) ->
    console.log dataset
    (err, response, body) <~ request.get do
        "http://eed.nsd.uib.no/webview/velocity?stubs=Region&measure=common&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2F#{dataset}_Display_C1&headers=Party&layers=virtual&mode=cube&measuretype=4&v=2&virtualslice=Absolutevalue_value&virtualsubset=Absolutevalue_value"
    <~ fs.writeFile "#__dirname/../data/scrape/#{dataset}.html" body
    console.log "Done"
    cb!
