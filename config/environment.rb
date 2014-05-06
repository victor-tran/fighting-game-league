# Load the Rails application.
require File.expand_path('../application', __FILE__)
require 'pusher'

# Initialize the Rails application.
FightingGameLeague::Application.initialize!

# Challonge API credentials.
Challonge::API.username = 'BurlyChalice'
Challonge::API.key = 'sPLwY60ECoATVsjaVY4cZNQKVlOD7y67pGSVdUzH'

Pusher.app_id = '73728'
Pusher.key = '4f019a37610d0978c340'
Pusher.secret = 'b11b79d75e6ae7501d5a'
