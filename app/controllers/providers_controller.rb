class ProvidersController < ApplicationController
  autocomplete :provider, :search_name, full: true, limit: 15
end
