t = require "./../../lib/twitter"

# - ' ! * ( ) < >

filter = 'football ,quote ", pound £,dollar $, percent %, caret ^,ampersand &,underscore _,plus +,equals =, bracket {, bracket }, bracket [, bracket ], colon :, semicolon ;, at @, tilde ~, hash #, . full stop, / backslash, ? question mark, \ forward slash, | pipe'


t.track filter, (tweet) -> console.log tweet.text
