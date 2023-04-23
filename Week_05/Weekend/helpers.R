game_sales <- CodeClanData::game_sales %>% 
  mutate(platform = recode(platform, 
                           "PS" = "PlayStation 1", 
                           "PS2" = "PlayStation 2",
                           "PS3" = "PlayStation 3",
                           "PS4" = "PlayStation 4",
                           "PS5" = "PlayStation 5",
                           "GC" = "GameCube", 
                           "GBA" = "GameBoy Advanced", 
                           "XB" = "XBox", 
                           "X360" = "XBox 360", 
                           "XOne" = "XBox One"))


platforms <- game_sales %>% 
  distinct(platform) %>% 
  arrange(platform) %>% 
  pull


genres <- game_sales %>% 
  distinct(genre) %>% 
  arrange(genre) %>% 
  pull

publishers <- game_sales %>% 
  distinct(publisher) %>% 
  arrange(publisher) %>% 
  pull




nintendo <- c("3DS", "DS", "GameBoy Advanced", "GameCube", "Wii", "WiiU")
sony <- c("PlayStation 1", "PlayStation 2", "PlayStation 3", "PlayStation 4", "PlayStation V", "PSP")
microsoft <- c("XBox", "XBox 360", "XBox One")
other <- as.list("PC")



 

