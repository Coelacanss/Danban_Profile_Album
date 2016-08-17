# This program is to grab photos from Douban website

library(XML)
library(rvest)

linkToPage = c()
count = 0

for (i in seq(from = 0, to = 90, by = 18)) {
      
      fileUrl <- paste("http://www.douban.com/photos/album/148810298/?start=", i, sep = "")
      try(web <- read_html(fileUrl), silent = T)
      linkNew <- html_nodes(web, ".photo_wrap a") %>% html_attr('href')
      linkToPage = c(linkToPage, linkNew)
      
}

linkToPage = linkToPage[grepl('.*\\d\\/$', linkToPage)]
id = seq(1:length(linkToPage))
linkData = data.frame(ID = id,
                      LinkToPage = linkToPage)
View(linkData)

setwd("~/Desktop/April")
ptm = proc.time()
for (i in 1:nrow(linkData)){
      fileUrl = paste(linkData[i,2], 'large', sep = '')
      web = try(read_html(fileUrl), silent = T)
      imageLink = html_nodes(web, '#pic-viewer img') %>% html_attr('src')
      imageName = paste(i, ".jpg", sep = "")
      try(download.file(imageLink, destfile = imageName), silent = TRUE)
}
proc.time() - ptm

