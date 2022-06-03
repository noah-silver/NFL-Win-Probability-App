install.packages('rsconnect')

rsconnect::setAccountInfo(name='noah-silver',
                          token='0D4D8A41D44A8EABBFBC439936E9C6B9',
                          secret='+u/HoBASy56MkXcM5at5+KwKpSpJOGBP83WgKLIv')



# Deploy
library(rsconnect)
rsconnect::deployApp('C:\Users\nsilver\Desktop\Basic R Resources\Portfolio Development\Football Analysis App')
