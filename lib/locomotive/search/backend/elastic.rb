require 'elasticsearch'

module Locomotive
  module Search
    module Backend
        class Elastic
            attr :site, :locale, :client

            def initialize(site, locale)
                @site, @locale = site, locale

                if site.metafields['elastic']
                    url = site.metafields['elastic']['elastic_url']
                    elastic_log = site.metafields['elastic']['elastic_log']
                    @client      = ::Elasticsearch::Client.new url: url, log: elastic_log
                end
            end

            def save_object(type: nil, object_id: nil, title: nil, content: nil, visible: true, data: {})
                base_object = { objectID: object_id, visible: visible, type: type }
                object      = { title: title, content: content, data: data }.merge(base_object)
      
                client.index index: object_index(type), type: type, body: object
                client.index index: global_index, type: type, body: object
            end
    
            def delete_object(type, object_id)
                client.delete index: object_index(type), type: type, id: object_id
                client.delete index: global_index, type: type, id: object_id
            end

            def clear_all_indices
                indices_json = client.cat.indices format: 'json'
                indices_json.each do |index_object|
                    name = index_object['index']

                    next unless name =~ /^#{self.base_index_name}-/
                    
                    client.indices.delete index: name
                end
            end

            def valid?
                @client.present?
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

            def self.enabled_for?(site)
                site.metafields.present? &&
                site.metafields['elastic'].present? &&
                site.metafields['elastic']['elastic_url'].present? &&
                site.metafields['elastic']['elastic_log'].present?
            end

            def self.reset_for?(site)
                enabled_for?(site) &&
                [1, '1', true].include?(site.metafields['elastic']['reset'])
            end

            def self.reset_done!(site)
                site.metafields['elastic']['reset'] = false
            end
        end
    end
  end
end
