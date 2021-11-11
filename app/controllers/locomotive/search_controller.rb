require 'elasticsearch'

module Locomotive
    class SearchController <  ApplicationController
        attr :site, :locale

        include Locomotive::Concerns::SslController
        include Locomotive::Concerns::RedirectToMainHostController
        include Locomotive::Concerns::AccountController
        include Locomotive::Concerns::ExceptionController
        include Locomotive::Concerns::AuthorizationController
        include Locomotive::Concerns::StoreLocationController
        include Locomotive::Concerns::WithinSiteController

        helper Locomotive::BaseHelper, Locomotive::ErrorsHelper
        helper Locomotive::SitesHelper
        
        respond_to :json

        before_action :load_site, :load_locale

        def search 
            search_string = params[:content]

            elastic_response = client.search index: global_index, body: { query: { match: { content: search_string } } }

            response = elastic_response
            respond_with response
        end

        def client
            client = ::Elasticsearch::Client.new url: elastic_host, log: elastic_log
        end

        def elastic_host
            host = @site.metafields['elastic']['elastic_url']
        end

        def elastic_log
            log = @site.metafields['elastic']['elastic_log']
        end

        private

        def load_site
            @site = current_site
        end

        def load_locale
            # Test, i need the current locale
            @locale = "de"
        end

        def global_index
            name = [base_index_name, self.locale].join('-')
        end

        def object_index(type)
            name = [base_index_name, self.locale, type].join('-')
        end

        def base_index_name
            ['locomotive', Rails.env, self.site.handle].join('-')
        end
    end
end