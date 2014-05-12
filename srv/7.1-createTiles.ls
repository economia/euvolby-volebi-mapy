require! {
    child_process.exec
    async
    fs
}
files = fs.readdirSync "#__dirname/../data/tiles"
# files.length = 1
<~ async.eachLimit files, 4, (file, cb) ->
    query = "svg-mapper #__dirname/../data/tiles/#file -c 2 -z 3-7"
    (err, stdout, stderr) <~ exec query
    console.log err, stdout, stderr
    cb!
