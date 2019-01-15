# encoding: UTF-8

require 'addressable/uri'
require 'time'

# Implementation of tag URI's.
# @see http://tools.ietf.org/html/rfc4151
module TagURI

  class Error < StandardError; end
  class ArgumentError < Error; end


  # From the RFC @see https://tools.ietf.org/html/rfc4151#section-2.1
  # The general syntax of a tag URI, in ABNF [2], is:
  #
  #   tagURI = "tag:" taggingEntity ":" specific [ "#" fragment ]
  #
  # Where:
  #
  #   taggingEntity = authorityName "," date
  #   authorityName = DNSname / emailAddress
  #   date = year ["-" month ["-" day]]
  #   year = 4DIGIT
  #   month = 2DIGIT
  #   day = 2DIGIT
  #   DNSname = DNScomp *( "."  DNScomp ) ; see RFC 1035 [3]
  #   DNScomp = alphaNum [*(alphaNum /"-") alphaNum]
  #   emailAddress = 1*(alphaNum /"-"/"."/"_") "@" DNSname
  #   alphaNum = DIGIT / ALPHA
  #   specific = *( pchar / "/" / "?" ) ; pchar from RFC 3986 [1]
  #   fragment = *( pchar / "/" / "?" ) ; same as RFC 3986 [1]
  #   pchar         = unreserved / pct-encoded / sub-delims / ":" / "@"
  #   unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
  #   pct-encoded   = "%" HEXDIG HEXDIG
  #   sub-delims    = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
  class URI
    # To match the terminology of the RFC I've put straightforward regex into
    # constants.

    # No underscores, only alphanums.
    ALPHANUM    = /[0-9a-zA-Z]/
    # No percent encoding here for hexnums.
    HEXDIG      = /[0-9a-fA-F]/
    # This is where the percent encodings are checked, e.g. %20.
    PCT_ENCODED = /% #{HEXDIG} #{HEXDIG}/x
    # Magic markers here.
    SUB_DELIMS  = /[\!\$\&'\(\)\*\+,\;\=]/x
    # The uncarved block.
    UNRESERVED  = /[\w\-\.\~]/
    # (Possibly percent-encoded) characters
    PCHAR       = /#{UNRESERVED} | #{PCT_ENCODED} | #{SUB_DELIMS} | \: | @/x
    # The thing really being tagged.
    SPECIFIC    = %r< (?: #{PCHAR} | / | \? )+ >x
    #   fragment = *( pchar / "/" / "?" ) ; same as RFC 3986 [1]
    # Even more specific.
    FRAGMENT    = /(?<=\#)#{SPECIFIC}/x
    #   DNScomp = alphaNum [*(alphaNum /"-") alphaNum]

    # Don't get too hung up on validating it's a domain name,
    # just do enough.
    DNSNAME = /
      \b
      (?:
        (?=[a-z0-9-]{1,63}\.)
        (?: xn--)?
        [a-z0-9]+
        (?: -[a-z0-9]+)*
      \.)+
      [a-z]{2,63}
      \b
    /x

    # It's not worth validating the email address beyond this either.
    EMAIL = /(?<email_id>[^,]+)@(?<email_domain>[^,@]+)/ # yes, anything goes

    # ISO8601 date
    YYYY_MM_DD = /\d{4}-\d\d-\d\d/
    OTHER_DATES = %r<\d{4}(?<separator>[\-\_/])\d\d[\-\_/]\d\d>

    # One scheme to rule them all, at least in this module.
    TAG_SCHEME = /(?<scheme>tag)\:/

    # Be tolerant
    ANY_SCHEME = /(?<scheme>#{ALPHANUM}+)\:/

    # I have the authoritay!
    AUTHORITY_NAME = /(?<authority_name>
      (?: #{DNSNAME} )
       |
      (?: #{EMAIL} )
    )/x

    # The whole pattern to capture a tag uri.
    TAG = /\A
      #{ANY_SCHEME}
      #{AUTHORITY_NAME}
      ,
      (?<date>#{YYYY_MM_DD})
      \:
      (?<specific> #{SPECIFIC} )
      (?<fragment> #{FRAGMENT} )?
    \z/x


    # Should be slightly faster than the other version.
    VALIDATE_TAG = /\A
      #{TAG_SCHEME}
      #{AUTHORITY_NAME}
      ,
      #{YYYY_MM_DD}
      \:
      #{SPECIFIC}
      (?: #{FRAGMENT} )?
    \z/x

    TIME_FORMAT="%Y-%m-%d"


    # @param uri [#to_s]
    # @param authority_name [String]
    # @param date  [String,Time,#to_time]
    # @param specific [String]
    # @param fragment [String]
    # @param email [String]
    # @param domain [String]
    def initialize( uri:            nil,
                    authority_name: nil,
                    date:           nil,
                    specific:       nil,
                    fragment:       nil,
                    email:          nil,
                    domain:         nil
                  )
      @scheme = "tag"
      if uri
        # handle TagURI::URI object
        if (uri.respond_to? :authority_name and
             uri.respond_to? :date and
             uri.respond_to? :specific)
            @authority_name = uri.authority_name
            @date = uri.date
            @specific = uri.specific
            return
        else
          uri = uri.to_s
          # handle something that looks very like a TagURI::URI object
          if ::URI.regexp.match uri and
            (md = TAG.match uri) and
            md[:scheme] == "tag"
              @authority_name = md[:authority_name]
              @date           = Time.strptime md[:date], TIME_FORMAT
              @specific       = md[:specific]
              self.fragment   = md[:fragment]
              return
          else # see what we can salvage from the uri
            extra_uri = Addressable::URI.parse uri
          end
        end
      end

      @date =
        if date
          if date.respond_to? :to_time
            date
          elsif date.to_s =~ /\A#{YYYY_MM_DD}$/
            Time.strptime date.to_s, TIME_FORMAT
          else
            fail ArgumentError, "Date should be a valid time/date/string that conforms to YYYY-MM-DD"
          end
        elsif uri and (md = /\A[^,]+,(?<date>#{YYYY_MM_DD})/.match uri )
          Time.strptime md[:date], TIME_FORMAT
        elsif extra_uri and (md = OTHER_DATES.match extra_uri.path)
          Time.strptime md[0], "%Y#{md[:separator]}%m#{md[:separator]}%d"
        else
          Time.now
        end

      @authority_name =
        if authority_name
          if (md = AUTHORITY_NAME.match authority_name)
            md[0]
          else
            fail ArgumentError, "Authority name must be a domain name or email address"
          end
        elsif email
          if (md = EMAIL.match email)
            md[0]
          else
            fail ArgumentError, "email given was invalid"
          end
        elsif domain
          if (md = DNSNAME.match domain)
            md[0]
          else
            fail ArgumentError, "domain given was invalid"
          end
        elsif extra_uri and extra_uri.normalized_authority
          extra_uri.normalized_authority
        elsif extra_uri and extra_uri.normalized_path and (md = AUTHORITY_NAME.match(extra_uri.normalized_path))
          md[:authority_name]
        elsif uri and (md = AUTHORITY_NAME.match uri)
          md[0]
        # else what?
        end


      @specific =
        if specific
          specific
        elsif extra_uri and (md = /,[\d\-]+\:(?<specific>#{SPECIFIC})/.match extra_uri.normalized_path )
          md[:specific]
        elsif uri and (md = /,[\d\-]+\:(?<specific>#{SPECIFIC})/.match uri )
          md[:specific]
        elsif extra_uri
          extra_uri.normalized_path
        end

      self.fragment =
        if fragment
          fragment
        elsif extra_uri and (md = /,[\d\-]+\:[^\#]+#(?<fragment>#{FRAGMENT})/.match extra_uri.normalized_path)
          md[:fragment]
        elsif uri and (md = /,[\d\-]+\:[^\#]+#(?<fragment>#{FRAGMENT})/.match uri )
          md[:fragment]
        elsif extra_uri
          extra_uri.normalized_fragment
        end

    end


    # @!attribute [r] scheme
    #   @return [String] Have a guess what it will be… (`"tag"`;)
    attr_reader :scheme

    # @!attribute [r] authority_name
    #   @return [String]
    # @!attribute [r] date
    #   @return [String]
    # @!attribute [r] specific
    #   @return [String]
    attr_accessor :authority_name, :date, :specific


    def fragment
      @fragment || ""
    end


    def fragment=( frag )
      @fragment = if frag
        frag.start_with?("#") ?
          frag.sub(/#/, "") :
          frag
      else
        ""
      end
      @fragment
    end


    def tagging_entity
      %Q!#{@authority_name},#{@date.strftime "%F"}!
    end


    def to_s
      s = %Q!#{self.scheme}:#{self.tagging_entity}:#{self.specific.gsub(/\s/, "%20")}!
      unless @fragment.nil? or @fragment.empty?
        s << "##{self.fragment}"
      end
      s
    end


    def valid?
      !!(VALIDATE_TAG =~ self.to_s)
    end

  end
end
