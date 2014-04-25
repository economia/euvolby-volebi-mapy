require! "../data/validParties.json"
out = ""
for country, parties of validParties
    out += "#{country}\n"
    for party of parties
        out += "\t#party\n"
console.log out

