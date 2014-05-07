tooltip = new Tooltip!
map = L.map do
    *   ig.containers.base
    *   minZoom: 3,
        maxZoom: 7,
        zoom: 4,
        center: [51.5, 9]

currentLayerCode = \winners
currentYear = 2009
layers =
    *   name: "Vítězové voleb"
        code: "winners"
    *   name: "EPP - lidové strany, KDU-ČSL"
        code: "epp"
    *   name: "GUE - komunisté, KSČM"
        code: "gue"
    *   name: "ALDE - liberální demokraté, TOP09"
        code: "alde"
    *   name: "NI - mimo frakci"
        code: "ni"
    *   name: "EAF - liberálové"
        code: "eaf"
    *   name: "ECR - konzervativci, ODS"
        code: "ecr"
    *   name: "G - zelení"
        code: "g"
    *   name: "SD - sociální demokraté"
        code: "sd"
    *   name: "UEN - nacionalisté"
        code: "uen"
baseLayer = new L.TileLayer do
    *   "http://staticmaps.ihned.cz/tiles-world-osm//{z}/{x}/{y}.png"
    *   zIndex: 1
        attribution: 'mapová data &copy; přispěvatelé <a href="http://openstreetmap.org" target="_blank">OpenStreetMap</a>'

getLayer = (code, year) ->
    new L.TileLayer do
        *   "./tiles/#code-#year/{z}/{x}/{y}.png"
        *   zIndex: 2

grids =
    \2004 : new L.UtfGrid "./tiles/json-all-2004/{z}/{x}/{y}.json", useJsonP: no
    \2009 : new L.UtfGrid "./tiles/json-all-2009/{z}/{x}/{y}.json", useJsonP: no

for let year, grid of grids
    grid.on \mouseover ({data}) -> drawTooltip data
    grid.on \mouseout -> tooltip.hide!

drawTooltip = (data) ->
    [parties, sum, nuts, name] = data
    if not sum or nuts == "LU000"
        sum = 0
        for party, index in <[SD EPP EAF G ALDE NI GUE ECR UEN]>
            sum += parties[index]
    mostVotes = null
    if currentLayerCode == "winners"
        mostVotes = Math.max ...parties

    list = for party, index in <[SD EPP EAF G ALDE NI GUE ECR UEN]>
        text = "#{party}: #{ig.utils.formatPrice parties[index]} (#{(parties[index] / sum * 100).toFixed 2}%)"
        if party.toLowerCase! is currentLayerCode or mostVotes == parties[index]
            text = "<b>#text</b>"
        text
    header = if nuts.length > 2
        "<b>Oblast #{name}</b>, #{ig.utils.abbr[nuts.substr 0 2]}"
    else
        "<b>#{ig.utils.abbr[nuts.substr 0 2]}</b>"
    tooltip.display "#header<br />" + list.join "<br />"

currentLayer = getLayer currentLayerCode, currentYear
currentGrid = grids[currentYear]

setLayer = (code) ->
    currentLayerCode := code
    setDisplay currentLayerCode, currentYear

setYear = (year) ->
    currentYear := year
    setDisplay currentLayerCode, currentYear

setDisplay = (layerCode, year) ->
    map.removeLayer currentGrid
    oldLayer = currentLayer
    currentLayer := getLayer layerCode, year
    currentGrid := grids[year]
    map.addLayer currentLayer
    map.addLayer currentGrid
    map.removeLayer oldLayer

$container = ig.containers.base

$select = $ "<select />"
    ..appendTo $container
    ..on \change ->
        setLayer $select.val!
    ..on \mouseover -> tooltip.hide!

$yearSelector = $ "<div />"
    ..attr \class \yearSelector
    ..append "<input type='radio' name='year' value='2004' id='select-year-2004' />"
    ..append "<label for='select-year-2004'>2004</label>"
    ..append "<input type='radio' name='year' value='2009' id='select-year-2009' checked='checked' />"
    ..append "<label for='select-year-2009'>2009</label>"
    ..appendTo $container
    ..on \change (evt) -> setYear evt.target.value
    ..on \mouseover -> tooltip.hide!

for {name, code} in layers
    $element = $ "<option>"
        ..html name
        ..val code
        ..appendTo $select

map
    ..addLayer baseLayer
    ..addLayer currentLayer
    ..addLayer currentGrid
