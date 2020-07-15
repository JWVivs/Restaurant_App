library(devtools)
#install_github("nik01010/dashboardthemes")
library(dashboardthemes)

### creating custom theme object
custom_theme <- shinyDashboardThemeDIY(
  
  ### general
  appFontFamily = "Arial"
  ,appFontColor = "rgb(1,36,74)"
  ,primaryFontColor = "rgb(1,36,74)"
  ,infoFontColor = "rgb(1,36,74)"
  ,successFontColor = "rgb(1,36,74)"
  ,warningFontColor = "rgb(1,36,74)"
  ,dangerFontColor = "rgb(1,36,74)"
  ,bodyBackColor = "rgb(255,255,255)"
  
  ### header
  ,logoBackColor = "rgb(255,255,255)"
  
  ,headerButtonBackColor = "rgb(255,255,255)"
  ,headerButtonIconColor = "rgb(1,36,74)"
  ,headerButtonBackColorHover = "rgb(230,230,230)"
  ,headerButtonIconColorHover = "rgb(1,36,74)"
  
  ,headerBackColor = "rgb(255,255,255)"
  ,headerBoxShadowColor = "#aaaaaa"
  ,headerBoxShadowSize = "0px 0px 0px"
  
  ### sidebar
  ,sidebarBackColor = "rgb(255,255,255)"
  ,sidebarPadding = 0
  
  ,sidebarMenuBackColor = "transparent"
  ,sidebarMenuPadding = 0
  ,sidebarMenuBorderRadius = 0
  
  ,sidebarShadowRadius = "0px 0px 0px"
  ,sidebarShadowColor = "#aaaaaa"
  
  ,sidebarUserTextColor = "rgb(1,36,74)"
  
  ,sidebarSearchBackColor = "rgb(1,36,74)"
  ,sidebarSearchIconColor = "rgb(1,36,74)"
  ,sidebarSearchBorderColor = "rgb(1,36,74)"
  
  ,sidebarTabTextColor = "rgb(1,36,74)"
  ,sidebarTabTextSize = 13
  ,sidebarTabBorderStyle = "none none none none"
  ,sidebarTabBorderColor = "rgb(1,36,74)"
  ,sidebarTabBorderWidth = 1
  
  ,sidebarTabBackColorSelected = "rgb(255,255,255)"
  ,sidebarTabTextColorSelected = "rgb(1,36,74)"
  ,sidebarTabRadiusSelected = "0px 0px 0px 0px"
  
  ,sidebarTabBackColorHover = "rgb(230,230,230)"
  ,sidebarTabTextColorHover = "rgb(1,36,74)"
  ,sidebarTabBorderStyleHover = "none none none none"
  ,sidebarTabBorderColorHover = "rgb(1,36,74)"
  ,sidebarTabBorderWidthHover = 1
  ,sidebarTabRadiusHover = "0px 0px 0px 0px"
  
  ### boxes
  ,boxBackColor = "rgb(1,36,74)"
  ,boxBorderRadius = 5
  ,boxShadowSize = "0px 0px 0px"
  ,boxShadowColor = "rgba(0,0,0,0)"
  ,boxTitleSize = 16
  ,boxDefaultColor = "rgb(255,255,255)"
  ,boxPrimaryColor = "rgb(0,0,0)"
  ,boxInfoColor = "rgb(0,0,0)"
  ,boxSuccessColor = "rgba(0,255,213,1)"
  ,boxWarningColor = "rgb(255,0,0)"
  ,boxDangerColor = "rgb(255,0,0)"
  
  ,tabBoxTabColor = "rgb(0,0,0)"
  ,tabBoxTabTextSize = 14
  ,tabBoxTabTextColor = "rgb(255,0,0)"
  ,tabBoxTabTextColorSelected = "rgb(1,36,74)"
  ,tabBoxBackColor = "rgb(255,0,0)"
  ,tabBoxHighlightColor = "rgb(230,230,230)"
  ,tabBoxBorderRadius = 5
  
  ### inputs
  ,buttonBackColor = "rgb(245,245,245)"
  ,buttonTextColor = "rgb(1,36,74)"
  ,buttonBorderColor = "rgb(200,200,200)"
  ,buttonBorderRadius = 5
  
  ,buttonBackColorHover = "rgb(235,235,235)"
  ,buttonTextColorHover = "rgb(1,36,74)"
  ,buttonBorderColorHover = "rgb(200,200,200)"
  
  ,textboxBackColor = "rgb(255,255,255)"
  ,textboxBorderColor = "rgb(200,200,200)"
  ,textboxBorderRadius = 5
  ,textboxBackColorSelect = "rgb(245,245,245)"
  ,textboxBorderColorSelect = "rgb(200,200,200)"
  
  ### tables
  ,tableBackColor = "rgb(255,255,255)"
  ,tableBorderColor = "rgb(255,255,255)"
  ,tableBorderTopSize = 2
  ,tableBorderRowSize = 5
  
)

#saveRDS(custom_theme, file = "./appCode/custom_theme")
