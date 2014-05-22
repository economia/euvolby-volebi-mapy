tooltip = new Tooltip!
mapContainer = document.createElement \div
ig.containers.base.appendChild mapContainer
map = L.map do
    *   mapContainer
    *   minZoom: 3,
        maxZoom: 7,
        zoom: 4,
        center: [51.5, 9]

currentLayerCode = \winners
currentYear = 2009
layers =
    *   name: "Vítězové voleb"
        code: "winners"
        legendColors: <[#ff7f00 #fdbf6f #a6cee3 #33a02c #1f78b4 #999999 #e31a1c #a65628 #ffff33]>
        legendNames: <[SD EPP EAF G ALDE NI GUE ECR UEN]>
    *   name: "SD &ndash; sociální demokraté, ČSSD"
        code: "sd"
        legendColors: <[#ffffcc #b10026]>
    *   name: "EPP &ndash; lidové strany, KDU-ČSL"
        code: "epp"
        legendColors: <[#ffffe5 #8c2d04]>
    *   name: "EAF &ndash; liberálové, Svobodní"
        code: "eaf"
        legendColors: <[#fff7fb #016450]>
    *   name: "G &ndash; zelení"
        code: "g"
        legendColors: <[#f7fcf5 #005a32]>
    *   name: "ALDE &ndash; liberální demokraté, ANO 2011"
        code: "alde"
        legendColors: <[#f7fbff #084594]>
    *   name: "NI &ndash; mimo frakci"
        code: "ni"
        legendColors: <[#ffffff #252525]>
    *   name: "GUE &ndash; komunisté, KSČM"
        code: "gue"
        legendColors: <[#fff5f0 #99000d]>
    *   name: "ECR &ndash; konzervativci, ODS"
        code: "ecr"
        legendColors: <[#fff7fb #034e7b]>
    *   name: "UEN &ndash; nacionalisté"
        code: "uen"
        legendColors: <[#fcfbfd #4a1486]>
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
map.on \click (evt) ->
    tooltip.hide!
    tooltip.onMouseMove evt.originalEvent

for let year, grid of grids
    grid.on \mouseover ({data}) ->
        return if legendTooltipDisplayed
        drawTooltip data
    grid.on \click ({data}:evt) ->
        drawTooltip data
    grid.on \mouseout ->
        return if legendTooltipDisplayed
        tooltip.hide!

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
        else if \winners isnt currentLayerCode
            text = "<span class='downlight'>#text</span>"
        else
            text
    header = if nuts.length > 2
        "<h2><b>Oblast #{name}</b>, #{ig.utils.abbr[nuts.substr 0 2]}</h2>"
    else
        "<h2><b>#{ig.utils.abbr[nuts.substr 0 2]}</b></h2>"
    tooltip.display "#header" + list.join "<br />"

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
    drawLegend!
legendTooltipDisplayed = no
drawLegend = ->
    $legend.empty!
    $legend.attr \class "legend #currentLayerCode"
    [layer] = layers.filter -> it.code is currentLayerCode
    {legendNames, legendColors} = layer
    if not legendNames
        legendNames = ["Nejmenší podpora" "Největší podpora"]
    for let color, index in legendColors
        name = legendNames[index]
        $d = $ "<div />"
            ..html name
            ..css \background-color color
            ..appendTo $legend
        if currentLayerCode == \winners
            $d.on \mouseover ->
                legendTooltipDisplayed := yes
                tooltip.display layers[index + 1].name
            $d.on \touchstart ->
                legendTooltipDisplayed := yes
                tooltip.display layers[index + 1].name
            $d.on \mouseout ->
                legendTooltipDisplayed := no
                tooltip.hide!

$container = $ ig.containers.base

$legend = $ "<div />"
    ..attr \class \legend
    ..appendTo $container

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
drawLegend!
