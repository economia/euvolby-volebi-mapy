require! {
    fs
    request
    async
    zlib
}
(err, files) <~ fs.readdir "#__dirname/../data/download/"
async.eachSeries files, (file, cb) ->
    [dataset] = file.split "_"
    (err, response, body) <~ request.get do
        uri: "http://129.177.90.166/obj/fSection/#{dataset}_Download_VG1@variables"
        encoding: null
    (err, body) <~ zlib.gunzip body
    <~ fs.writeFile "#__dirname/../data/variables/#dataset.xml.gz" body
    cb!
