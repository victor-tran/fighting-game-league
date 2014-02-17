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

  # Super Street Fighter IV: Arcade Edition
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

  # UMvC3
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
end

def make_users
  User.create!(first_name: "Victor",
  						 last_name: "Tran",
  						 alias: "BurlyChalice",
               email: "dfaced@gmail.com",
               password: "foobar",
               password_confirmation: "foobar",
               fight_bucks: "50")
end