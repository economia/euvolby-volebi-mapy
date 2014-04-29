require! "../data/validParties.json"
out = ""
for country, parties of validParties
    out += "#{country}\n"
    for party, perc of parties
        out += "\t#party\t#{perc.substr 1}\n"
console.log out

