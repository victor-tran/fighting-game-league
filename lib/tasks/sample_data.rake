namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_games
    make_users
    make_characters
  end
end

def make_games
  Game.create!(name: "Super Street Fighter IV: Arcade Edition")
  Game.create!(name: "Ultimate Marvel vs. Capcom 3") 
  Game.create!(name: "Injustice: Gods Among Us")
  Game.create!(name: "Super Smash Bros. Melee")
  Game.create!(name: "Killer Instinct")
  Game.create!(name: "King of Fighters XIII")
  Game.create!(name: "Street Fighter x Tekken")
  Game.create!(name: "Persona 4 Arena")
  Game.create!(name: "Tekken Tag Tournament 2")
  Game.create!(name: "Mortal Kombat 9")
end

def make_characters

  ###########################################
  # Super Street Fighter IV: Arcade Edition #
  ###########################################
  game = Game.find_by_name("Super Street Fighter IV: Arcade Edition")
  game.characters.create!(name: "Ryu")
  game.characters.create!(name: "Ken")
  game.characters.create!(name: "E. Honda")
  game.characters.create!(name: "Ibuki")
  game.characters.create!(name: "Makoto")
  game.characters.create!(name: "Dudley")
  game.characters.create!(name: "Seth")
  game.characters.create!(name: "Gouken")
  game.characters.create!(name: "Akuma")
  game.characters.create!(name: "Gen")
  game.characters.create!(name: "Dan")
  game.characters.create!(name: "Sakura")
  game.characters.create!(name: "Oni")
  game.characters.create!(name: "Yun")
  game.characters.create!(name: "Juri")
  game.characters.create!(name: "Chun Li")
  game.characters.create!(name: "Dhalsim")
  game.characters.create!(name: "Abel")
  game.characters.create!(name: "C. Viper")
  game.characters.create!(name: "Dictator")
  game.characters.create!(name: "Sagat")
  game.characters.create!(name: "Cammy")
  game.characters.create!(name: "Deejay")
  game.characters.create!(name: "Cody")
  game.characters.create!(name: "Guy")
  game.characters.create!(name: "Hakan")
  game.characters.create!(name: "Yang")
  game.characters.create!(name: "Evil Ryu")
  game.characters.create!(name: "Guile")
  game.characters.create!(name: "Blanka")
  game.characters.create!(name: "Zangief")
  game.characters.create!(name: "Rufus")
  game.characters.create!(name: "El Fuerte")
  game.characters.create!(name: "Claw")
  game.characters.create!(name: "Boxer")
  game.characters.create!(name: "Fei Long")
  game.characters.create!(name: "T. Hawk")
  game.characters.create!(name: "Adon")
  game.characters.create!(name: "Rose")

  ###############################
  # Ulimate Marvel vs. Capcom 3 #
  ###############################
  game = Game.find_by_name("Ultimate Marvel vs. Capcom 3")

  # Marvel Characters
  game.characters.create!(name: "Nova")
  game.characters.create!(name: "Rocket Raccoon")
  game.characters.create!(name: "Iron Fist")
  game.characters.create!(name: "Doctor Strange")
  game.characters.create!(name: "Ghost Rider")
  game.characters.create!(name: "Hawkeye")
  game.characters.create!(name: "Spider-Man")
  game.characters.create!(name: "Captain America")
  game.characters.create!(name: "Wolverine")
  game.characters.create!(name: "Magneto")
  game.characters.create!(name: "Hulk")
  game.characters.create!(name: "She-Hulk")
  game.characters.create!(name: "Taskmaster")
  game.characters.create!(name: "Iron Man")
  game.characters.create!(name: "Thor")
  game.characters.create!(name: "Doctor Doom")
  game.characters.create!(name: "Phoenix")
  game.characters.create!(name: "M.O.D.O.K")
  game.characters.create!(name: "Dormammu")
  game.characters.create!(name: "Deadpool")
  game.characters.create!(name: "Storm")
  game.characters.create!(name: "Super Skrull")
  game.characters.create!(name: "Sentinel")
  game.characters.create!(name: "X-23")
  game.characters.create!(name: "Shuma-Gorath") # DLC Char

  # Capcom Characters
  game.characters.create!(name: "Frank West")
  game.characters.create!(name: "Vergil")
  game.characters.create!(name: "Phoenix Wright")
  game.characters.create!(name: "Nemesis")
  game.characters.create!(name: "Firebrand")
  game.characters.create!(name: "Strider")
  game.characters.create!(name: "Ryu")
  game.characters.create!(name: "Chun Li")
  game.characters.create!(name: "Akuma")
  game.characters.create!(name: "Chris Redfield")
  game.characters.create!(name: "Wesker")
  game.characters.create!(name: "Viewtiful Joe")
  game.characters.create!(name: "Dante")
  game.characters.create!(name: "Trish")
  game.characters.create!(name: "Spencer")
  game.characters.create!(name: "Arthur")
  game.characters.create!(name: "Amaterasu")
  game.characters.create!(name: "Zero")
  game.characters.create!(name: "Tron Bonne")
  game.characters.create!(name: "Morrigan")
  game.characters.create!(name: "Hsien-Ko")
  game.characters.create!(name: "Felicia")
  game.characters.create!(name: "C. Viper")
  game.characters.create!(name: "Mike Haggar")
  game.characters.create!(name: "Jill Valentine") # DLC Char

  ############################
  # Injustice: Gods Among Us #
  ############################
  game = Game.find_by_name("Injustice: Gods Among Us")
  game.characters.create!(name: "Batman")
  game.characters.create!(name: "Superman")
  game.characters.create!(name: "Scorpion") # DLC Char
  game.characters.create!(name: "Deathstroke")
  game.characters.create!(name: "Nightwing")
  game.characters.create!(name: "Zatanna") # DLC Char
  game.characters.create!(name: "Harley Quinn")
  game.characters.create!(name: "Batgirl") # DLC Char
  game.characters.create!(name: "Raven")
  game.characters.create!(name: "Green Lantern")
  game.characters.create!(name: "Zod") # DLC Char
  game.characters.create!(name: "Flash")
  game.characters.create!(name: "Martian Manhunter") # DLC Char
  game.characters.create!(name: "Green Arrow")
  game.characters.create!(name: "Wonder Woman")
  game.characters.create!(name: "Ares")
  game.characters.create!(name: "Joker")
  game.characters.create!(name: "Aquaman")
  game.characters.create!(name: "Shazam")
  game.characters.create!(name: "Doomsday")
  game.characters.create!(name: "Solomon Grundy")
  game.characters.create!(name: "Black Adam")
  game.characters.create!(name: "Catwoman")
  game.characters.create!(name: "Killer Frost")
  game.characters.create!(name: "Bane")
  game.characters.create!(name: "Lex Luthor")
  game.characters.create!(name: "Cyborg")
  game.characters.create!(name: "Hawkgirl")
  game.characters.create!(name: "Sinestro")
  game.characters.create!(name: "Lobo") #DLC Char

  ###########################
  # Super Smash Bros. Melee #
  ###########################
  game = Game.find_by_name("Super Smash Bros. Melee")
  game.characters.create!(name: "Dr. Mario")
  game.characters.create!(name: "Mario")
  game.characters.create!(name: "Luigi")
  game.characters.create!(name: "Bowser")
  game.characters.create!(name: "Peach")
  game.characters.create!(name: "Yoshi")
  game.characters.create!(name: "DK")
  game.characters.create!(name: "Captain Falcon")
  game.characters.create!(name: "Ganondorf")
  game.characters.create!(name: "Falco")
  game.characters.create!(name: "Fox")
  game.characters.create!(name: "Ness")
  game.characters.create!(name: "Ice Climbers")
  game.characters.create!(name: "Kirby")
  game.characters.create!(name: "Samus")
  game.characters.create!(name: "Zelda/Sheik")
  game.characters.create!(name: "Link")
  game.characters.create!(name: "Young Link")
  game.characters.create!(name: "Pichu")
  game.characters.create!(name: "Pikachu")
  game.characters.create!(name: "Jigglypuff")
  game.characters.create!(name: "Mewtwo")
  game.characters.create!(name: "Mr. Game & Watch")
  game.characters.create!(name: "Marth")
  game.characters.create!(name: "Roy")

  ###################
  # Killer Instinct #
  ###################
  game = Game.find_by_name("Killer Instinct")
  game.characters.create!(name: "Orchid")
  game.characters.create!(name: "Fulgore")
  game.characters.create!(name: "Glacius")
  game.characters.create!(name: "Jago")
  game.characters.create!(name: "Sabrewulf")
  game.characters.create!(name: "Spinal")
  game.characters.create!(name: "Thunder")
  game.characters.create!(name: "Sadira")
  game.characters.create!(name: "Shadow Jago")

  #########################
  # King of Fighters XIII #
  #########################
  game = Game.find_by_name("King of Fighters XIII")
  
  # Elisabeth Team
  game.characters.create!(name: "Elisabeth Blanctorche")
  game.characters.create!(name: "Shen Woo")
  game.characters.create!(name: "Duo Lon")

  # Psycho Soldier Team
  game.characters.create!(name: "Athena Asamiya")
  game.characters.create!(name: "Sie Kensou")
  game.characters.create!(name: "Chin Gentsai")

  # Japan Team
  game.characters.create!(name: "Kyo Kusanagi")
  game.characters.create!(name: "Benimaru Nikaido")
  game.characters.create!(name: "Goro Daimon")

  # Art of Fighting Team
  game.characters.create!(name: "Ryo Sakazaki")
  game.characters.create!(name: "Robert Garcia")
  game.characters.create!(name: "Takuma Sakazaki")

  # Yagami Team
  game.characters.create!(name: "Iori Yagami")
  game.characters.create!(name: "Mature")
  game.characters.create!(name: "Vice")

  # Ikari Warriors Team
  game.characters.create!(name: "Ralf Jones")
  game.characters.create!(name: "Clark Still")
  game.characters.create!(name: "Leona Heidern")

  # Fatal Fury Team
  game.characters.create!(name: "Terry Bogard")
  game.characters.create!(name: "Andy Bogard")
  game.characters.create!(name: "Joe Higashi")

  # Women Fighters Team
  game.characters.create!(name: "Mai Shiranui")
  game.characters.create!(name: "Yuri Sakazaki")
  game.characters.create!(name: "King")

  # Kim Team
  game.characters.create!(name: "Kim Kaphwan")
  game.characters.create!(name: "Hwa Jai")
  game.characters.create!(name: "Raiden")

  # K' Team
  game.characters.create!(name: "K'")
  game.characters.create!(name: "Kula Diamond")
  game.characters.create!(name: "Maxima")

  # DLC Characters

  ###########################
  # Street Fighter x Tekken #
  ###########################
  game = Game.find_by_name("Street Fighter x Tekken")
  
  # Street Fighter
  game.characters.create!(name: "Abel")
  game.characters.create!(name: "Akuma")
  game.characters.create!(name: "Boxer")
  game.characters.create!(name: "Cammy")
  game.characters.create!(name: "Chun-Li")
  game.characters.create!(name: "Claw")
  game.characters.create!(name: "Dhalsim")
  game.characters.create!(name: "Dictator")
  game.characters.create!(name: "Guile")
  game.characters.create!(name: "Hugo")
  game.characters.create!(name: "Ibuki")
  game.characters.create!(name: "Juri")
  game.characters.create!(name: "Ken")
  game.characters.create!(name: "Poison")
  game.characters.create!(name: "Rolento")
  game.characters.create!(name: "Rufus")
  game.characters.create!(name: "Ryu")
  game.characters.create!(name: "Sagat")
  game.characters.create!(name: "Zangief")

  # Tekken
  game.characters.create!(name: "Asuka")
  game.characters.create!(name: "Bob")
  game.characters.create!(name: "Heihachi")
  game.characters.create!(name: "Hwoarang")
  game.characters.create!(name: "Jin")
  game.characters.create!(name: "Julia")
  game.characters.create!(name: "Kazuya")
  game.characters.create!(name: "King")
  game.characters.create!(name: "Kuma")
  game.characters.create!(name: "Law")
  game.characters.create!(name: "Lili")
  game.characters.create!(name: "Marduk")
  game.characters.create!(name: "Nina")
  game.characters.create!(name: "Ogre")
  game.characters.create!(name: "Paul")
  game.characters.create!(name: "Raven")
  game.characters.create!(name: "Steve")
  game.characters.create!(name: "Xiaoyu")
  game.characters.create!(name: "Yoshimitsu")

  # Street Fighter DLC
  game.characters.create!(name: "Blanka")
  game.characters.create!(name: "Cody")
  game.characters.create!(name: "Dudley")
  game.characters.create!(name: "Elena")
  game.characters.create!(name: "Guy")
  game.characters.create!(name: "Sakura")

  # Tekken DLC
  game.characters.create!(name: "Alisa")
  game.characters.create!(name: "Bryan")
  game.characters.create!(name: "Christie")
  game.characters.create!(name: "JACK-X")
  game.characters.create!(name: "Lars")
  game.characters.create!(name: "Lei")

  ###################
  # Persona 4 Arena #
  ###################
  game = Game.find_by_name("Persona 4 Arena")
  game.characters.create!(name: "Aigis")
  game.characters.create!(name: "Akihiko Sanada")
  game.characters.create!(name: "Chie Satonaka")
  game.characters.create!(name: "Elizabeth")
  game.characters.create!(name: "Kanji Tatsumi")
  game.characters.create!(name: "Labrys")
  game.characters.create!(name: "Mitsuru Kirijo")
  game.characters.create!(name: "Naoto Shirogane")
  game.characters.create!(name: "Shadow Labrys")
  game.characters.create!(name: "Teddie")
  game.characters.create!(name: "Yosuke Hanamura")
  game.characters.create!(name: "Yu Narukami")
  game.characters.create!(name: "Yukiki Amagi")

  ###########################
  # Tekken Tag Tournament 2 #
  ###########################
  game = Game.find_by_name("Tekken Tag Tournament 2")
  game.characters.create!(name: "Alex")
  game.characters.create!(name: "Alisa")
  game.characters.create!(name: "Ancient Ogre")
  game.characters.create!(name: "Angel")
  game.characters.create!(name: "Anna")
  game.characters.create!(name: "Armor King")
  game.characters.create!(name: "Asuka")
  game.characters.create!(name: "Baek")
  game.characters.create!(name: "Bob")
  game.characters.create!(name: "Bruce")
  game.characters.create!(name: "Bryan")
  game.characters.create!(name: "Christie")
  game.characters.create!(name: "Devil Jin")
  game.characters.create!(name: "Dragunov")
  game.characters.create!(name: "Eddy")
  game.characters.create!(name: "Feng")
  game.characters.create!(name: "Forest Law")
  game.characters.create!(name: "Ganryu")
  game.characters.create!(name: "Heihachi")
  game.characters.create!(name: "Hwoarang")
  game.characters.create!(name: "JACK-6")
  game.characters.create!(name: "Jaycee")
  game.characters.create!(name: "Jin")
  game.characters.create!(name: "Jinpachi")
  game.characters.create!(name: "Jun")
  game.characters.create!(name: "Kazuya")
  game.characters.create!(name: "King")
  game.characters.create!(name: "Kuma")
  game.characters.create!(name: "Kunimitsu")
  game.characters.create!(name: "Lars")
  game.characters.create!(name: "Lee")
  game.characters.create!(name: "Lei")
  game.characters.create!(name: "Leo")
  game.characters.create!(name: "Lili")
  game.characters.create!(name: "Marduk")
  game.characters.create!(name: "Marshall Law")
  game.characters.create!(name: "Michelle")
  game.characters.create!(name: "Miguel")
  game.characters.create!(name: "Miharu")
  game.characters.create!(name: "Nina")
  game.characters.create!(name: "Panda")
  game.characters.create!(name: "Paul")
  game.characters.create!(name: "Prototype JACK")
  game.characters.create!(name: "Raven")
  game.characters.create!(name: "Roger Jr.")
  game.characters.create!(name: "Sebastian")
  game.characters.create!(name: "Slim Bob")
  game.characters.create!(name: "Steve")
  game.characters.create!(name: "Tiger Jackson")
  game.characters.create!(name: "True Ogre")
  game.characters.create!(name: "Wang")
  game.characters.create!(name: "Xiaoyu")
  game.characters.create!(name: "Yoshimitsu")
  game.characters.create!(name: "Zafina")

  ###################
  # Mortal Kombat 9 #
  ###################
  game = Game.find_by_name("Mortal Kombat 9")
  game.characters.create!(name: "Baraka")
  game.characters.create!(name: "Cyber Sub-Zero")
  game.characters.create!(name: "Cyrax")
  game.characters.create!(name: "Ermac")
  game.characters.create!(name: "Freddy Kreuger")
  game.characters.create!(name: "Jade")
  game.characters.create!(name: "Jax")
  game.characters.create!(name: "Johnny Cage")
  game.characters.create!(name: "Kabal")
  game.characters.create!(name: "Kano")
  game.characters.create!(name: "Kenshi")
  game.characters.create!(name: "Kitana")
  game.characters.create!(name: "Kratos")
  game.characters.create!(name: "Kung Lao")
  game.characters.create!(name: "Liu Kang")
  game.characters.create!(name: "Mileena")
  game.characters.create!(name: "Nightwolf")
  game.characters.create!(name: "Noob Saibot")
  game.characters.create!(name: "Quan Chi")
  game.characters.create!(name: "Raiden")
  game.characters.create!(name: "Rain")
  game.characters.create!(name: "Reptile")
  game.characters.create!(name: "Scorpion")
  game.characters.create!(name: "Sektor")
  game.characters.create!(name: "Shang Tsung")
  game.characters.create!(name: "Sheeva")
  game.characters.create!(name: "Sindel")
  game.characters.create!(name: "Skarlet")
  game.characters.create!(name: "Smoke")
  game.characters.create!(name: "Sonya")
  game.characters.create!(name: "Stryker")
  game.characters.create!(name: "Sub-Zero")
end

def make_users
  User.create!(first_name: "Victor",
  						 last_name: "Tran",
  						 alias: "BurlyChalice",
               email: "dfaced@gmail.com",
               password: "foobar",
               password_confirmation: "foobar",
               fight_bucks: "50")

  User.create!(first_name: "Foo",
               last_name: "Bar",
               alias: "blat",
               email: "foo@bar.com",
               password: "foobar",
               password_confirmation: "foobar",
               fight_bucks: "50")
end