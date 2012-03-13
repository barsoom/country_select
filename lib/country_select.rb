# CountrySelect
require 'country_select/version'

module ActionView
  module Helpers
    module FormOptionsHelper
      # Return select and option tags for the given object and method, using country_options_for_select to generate the list of option tags.
      def country_select(object, method, priority_countries = nil, options = {}, html_options = {})
        InstanceTag.new(object, method, self, options.delete(:object)).to_country_select_tag(priority_countries, options, html_options)
      end
      # Returns a string of option tags for pretty much any country in the world. Supply a country name as +selected+ to
      # have it marked as the selected option tag. You can also supply an array of countries as +priority_countries+, so
      # that they will be listed above the rest of the (long) list.
      #
      # NOTE: Only the option tags are returned, you have to wrap this call in a regular HTML select tag.
      def country_options_for_select(selected = nil, priority_countries = nil)
        country_options = ""

        if priority_countries
          country_options += options_for_select(priority_countries, selected)
          country_options += "<option value=\"\" disabled=\"disabled\">-------------</option>\n"
          # prevents selected from being included twice in the HTML which causes
          # some browsers to select the second selected option (not priority)
          # which makes it harder to select an alternative priority country
          selected=nil if priority_countries.include?(selected)
        end

        return country_options + options_for_select(COUNTRIES.map { |c| [I18n.t("countries.#{c.to_s}"), c] }, selected)
      end
      # All the countries included in the country_options output.
      COUNTRIES = ['af', 'al', 'dz', 'as', 'vi', 'ad', 'ao', 'ai', 'aq', 'ag', 'ar', 'am', 'aw', 'au', 'az', 'bs', 'bh', 'bd', 'bb', 'be', 'bz', 'bj', 'bm', 'bt', 'bo', 'bq', 'ba', 'bw', 'bv', 'br', 'io', 'vg', 'bn', 'bg', 'bf', 'bi', 'kh', 'ca', 'cf', 'cl', 'cn', 'cx', 'cc', 'co', 'km', 'cg', 'cd', 'ck', 'cr', 'cu', 'cw', 'cy', 'dk', 'dj', 'dm', 'do', 'de', 'ec', 'eg', 'sv', 'gq', 'er', 'ee', 'et', 'fo', 'fk', 'fj', 'ph', 'fi', 'fr', 'gf', 'pf', 'tf', 'ga', 'gm', 'ge', 'gh', 'gi', 'gd', 'gr', 'gl', 'gp', 'gu', 'gt', 'gg', 'gn', 'gw', 'gy', 'ht', 'hm', 'hn', 'hu', 'hk', 'ie', 'is', 'in', 'id', 'iq', 'ir', 'il', 'it', 'ci', 'jm', 'jp', 'ye', 'je', 'jo', 'ky', 'cv', 'cm', 'kz', 'ke', 'kg', 'ki', 'um', 'kw', 'hr', 'la', 'ls', 'lv', 'lb', 'lr', 'ly', 'li', 'lt', 'lu', 'mo', 'mk', 'mg', 'mw', 'mv', 'my', 'ml', 'mt', 'im', 'ma', 'mh', 'mq', 'mr', 'mu', 'yt', 'mx', 'fm', 'md', 'mc', 'mn', 'me', 'ms', 'mz', 'mm', 'na', 'nr', 'nl', 'an', 'np', 'ni', 'nc', 'nz', 'ne', 'ng', 'nu', 'kp', 'mp', 'no', 'nf', 'ug', 'ua', 'uz', 'om', 'tl', 'at', 'pk', 'pw', 'ps', 'pa', 'pg', 'py', 'pe', 'pn', 'pl', 'pt', 'pr', 'qa', 'ro', 'ru', 'rw', 're', 'kn', 'lc', 'vc', 'bl', 'pm', 'sb', 'ws', 'sm', 'st', 'sa', 'sn', 'rs', 'sc', 'sl', 'sg', 'sx', 'sh', 'mf', 'si', 'sk', 'sd', 'so', 'es', 'sj', 'lk', 'sr', 'sz', 'sy', 'tj', 'tw', 'tz', 'th', 'tg', 'tk', 'to', 'tt', 'td', 'cz', 'tn', 'tr', 'tm', 'tc', 'tv', 'uy', 'vu', 'va', 've', 'gb', 'ae', 'us', 'vn', 'wf', 'eh', 'by', 'zm', 'zw', 'za', 'gs', 'kr', 'ss', 'se', 'ch', 'ax'] unless const_defined?("COUNTRIES")
    end

    class InstanceTag
      include ActionView::Helpers::OutputSafetyHelper
      
      def to_country_select_tag(priority_countries, options, html_options)
        html_options = html_options.stringify_keys
        add_default_name_and_id(html_options)
        value = value(object)
        content_tag("select",
          add_options(
            raw(country_options_for_select(value, priority_countries)),
            options, value
          ), html_options
        )
      end
    end

    class FormBuilder
      def country_select(method, priority_countries = nil, options = {}, html_options = {})
        @template.country_select(@object_name, method, priority_countries, options.merge(:object => @object), html_options)
      end
    end
  end
end
