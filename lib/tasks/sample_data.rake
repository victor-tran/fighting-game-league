namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_games
    make_users
  end
end

def make_games
  Game.create!(name: "Street Fighter IV: Arcade Edition")
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

def make_users
  User.create!(first_name: "Victor",
  						 last_name: "Tran",
  						 alias: "BurlyChalice",
               email: "dfaced@gmail.com",
               password: "foobar",
               password_confirmation: "foobar",
               fight_bucks: "50")
end