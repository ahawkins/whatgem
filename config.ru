# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

run Rack::URLMap.new \
  "/"       => WhatGem::Application,
  "/resque" => Resque::Server.new
