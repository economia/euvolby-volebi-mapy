require! {
    request
    async
    fs
}

links =
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FFREP2009_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FFREP2009_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FDKEP2004_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FDKEP2004_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FDKEP2009_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FDKEP2009_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FDEEP2009_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FDEEP2009_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FDEEP2004_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FDEEP2004_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FEEEP2004_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FEEEP2004_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FFIEP2004_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FFIEP2004_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FFIEP2009_SUM_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FFIEP2009_SUM_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FHUEP2004_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FHUEP2004_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FIEEP2004_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FIEEP2004_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FITEP2009_SUM_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FITEP2009_SUM_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FITEP2004_SUM_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FITEP2004_SUM
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FLAEP2004_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FLAEP2004_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FLVEP2009_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FLVEP2009_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FLTEP2004_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FLTEP2004_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FLUEP2009_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FLUEP2009_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FLUEP2004_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FLUEP2004_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FMTEP2004_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FMTEP2004_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FNLEP2009_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FNLEP2009_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FPLEP2004_SUM_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FPLEP2004_SUM_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FPLEP2009_SUM_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FPLEP2009_SUM_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FPTEP2004_SUM_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FPTEP2004_SUM_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FPTEP2009_SUM_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FPTEP2009_SUM_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FROEP2007_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FROEP2007_Display
    \http://eed.nsd.uib.no/webview/velocity?v=2&mode=cube&cube=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfCube%2FUKEP2009_SUM_Display_C1&study=http%3A%2F%2F129.177.90.166%3A80%2Fobj%2FfStudy%2FUKEP2009_SUM_Display

async.eachSeries links, (link, cb) ->
    [_, name] = link.match "Cube%2F([A-Z]{2}EP200[0-9])_"
    console.log name
    (err, response, body) <~ request.get do
        link
    <~ fs.writeFile "#__dirname/../data/scrape/#{name}.html" body
    console.log "Done"
    cb!
