


### TAINT as soon as INTERSKIPLIST is updated, this will become a one-liner:

```
module.exports = ( require 'interskiplist' ).new.from_intervals require '../data/unicode-9.0.0-intervals.json'
```

###

ISL             = require 'interskiplist'
u               = ISL.new()
ISL.add u, interval for interval in require '../data/unicode-9.0.0-intervals.json'
module.exports  = u

