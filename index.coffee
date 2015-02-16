trip =
  days: 1
  hours: 0
  miles: 100

gas = 2.99
milesPerGallon = 45
bartToAndFromAirport = 36
zipCarMonthly = 6
cityCarShareYearly = 60
cityCarShareMonthly = 20

# comparison is done with prius for all companies
companies =
  'getaround':
    hourly: 8.5
    daily: 68
    perMile: (1 / milesPerGallon) * gas
    extraCost: 0
  'getaroundAirport':
    hourly: 4
    daily: 32
    perMile: (1 / milesPerGallon) * gas
    extraCost: bartToAndFromAirport
  'cityCarShare':
    hourly: 10.25
    daily: 86
    perMile: 0
    extraCost: cityCarShareYearly / 52
    credit: do ->
      if trip.hours > 0
        if (trip.miles / trip.hours) < 5
          return 0.05
      return 0
  'cityCarSharePlus':
    hourly: 7.3
    daily: 60
    perMile: 0.35
    dailyPerMile: 0.1
    extraCost: cityCarShareMonthly / 4
  'zipcar':
    hourly: 12.50
    daily: 99
    perMile: 0
    extraCost: zipCarMonthly / 4
  'enterprise':
    daily: 79.99
    perMile: (1 / milesPerGallon) * gas
    extraCost: 0 # under 25 fee

#  ----------------------

companyRanking = []
for company, rate of companies
  if trip.days > 0
    price = trip.days * rate.daily
    price += if rate.dailyPerMile then (trip.miles * rate.dailyPerMile) else (trip.miles * rate.perMile)
  else
    price = trip.hours * rate.hourly
    price += (trip.miles * rate.perMile)
  price += rate.extraCost
  price -= (rate.credit * price) if rate.credit > 0
  companyRanking.push [company, price] if price

companyRanking = companyRanking.sort (a, b) -> a[1] > b[1]

console.log companyRanking
