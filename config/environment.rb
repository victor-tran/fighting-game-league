# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
FightingGameLeague::Application.initialize!

# Challonge API credentials.
Challonge::API.username = 'BurlyChalice'
Challonge::API.key = 'sPLwY60ECoATVsjaVY4cZNQKVlOD7y67pGSVdUzH'
