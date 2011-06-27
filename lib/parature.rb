require 'httpclient'
require 'nokogiri'

module Parature
  class Parature
    def initialize(base_url, token, account_id, dept_id)
      @base_url = base_url
      @token = token
      @account_id = account_id
      @dept_id = dept_id
      @client = HTTPClient.new
    end

    def get_accounts(options = {})
      request = build_request(:object => 'Account', :params => {:_pageSize_ => 500})
      response = get_request(request)
      data = parse_response(response)

      accounts = data.xpath('//Account')

      num_pages = (data.Entities[:total].to_i / data.Entities['page-size'].to_f).ceil

      if num_pages > 1 then 
        (2..num_pages).each{|page|
          request = build_request(:object => 'Account', :params => {:_startPage_ => page, :_pageSize_ => 500})
          response = get_request(request)
          data = parse_response(response)
          data.xpath('//Account').each{|account|
            accounts << account
          }
        }
      end

      accounts
    end

    def find_account_by_id(id)
      request = build_request(:object => 'Account', :type => 'single', :params => {:id => id})
      response = get_request(request)
      data = parse_response(response)

      account = data.xpath("//Account[@id=#{id}]").first
    end

    def set_related_accounts(parent_account_id, child_account_ids)
      #parent_account_id is the id of the account to add related accounts to
      #child_account_ids is an array of accounts to be added

      #first get the parent account
      account = find_account_by_id(parent_account_id)
      
      #modify account object so that it is ready to send back to the server
      #remove elements that have editable=false
      account.elements.find_all{|node| node[:editable] == "false"}.each{|n| n.remove}

      #prepare Shown_Accounts element.  (if one exists already, get rid of it.)
      begin
        account.Shown_Accounts.remove
      rescue
        #if we couldn't delete it, it probably wasn't there
      end
      
      shown_accounts = Nokogiri::XML::Node.new "Shown_Accounts", account.document
      
      child_account_ids.each{|id|
        a = Nokogiri::XML::Node.new "Account", account.document
        a["id"] = id.to_s
        shown_accounts.add_child(a)
      }

      account.add_child(shown_accounts)
      
      #account is now ready to be sent via put
      save_account(account)
    end

    def get_tickets(options = {})
      request = build_request(:object => 'Ticket', :params => {:_pageSize_ => 500})
      response = get_request(request)
      data = parse_response(response)

      tickets = data.xpath('//Ticket')

      num_pages = (data.Entities[:total].to_i / data.Entities['page-size'].to_f).ceil

      if num_pages > 1 then 
        (2..num_pages).each{|page|
          request = build_request(:object => 'Ticket', :params => {:_startPage_ => page, :_pageSize_ => 500})
          response = get_request(request)
          data = parse_response(response)
          data.xpath('//Ticket').each{|ticket|
            tickets << ticket
          }
        }
      end

      tickets
    end

    def find_ticket_by_id(ticket_id)
      request = build_request(:object => 'Ticket', :type => 'single', :params => {:id => ticket_id})
      response = get_request(request)
      data = parse_response(response)
      ticket = data.xpath("//Ticket[@id=#{ticket_id}]")
    end

    def save_account(account)
      request = build_request(:object => 'Account', :type => 'single', :params => {:id => account[:id]})
      response = put_request(request, account)
    end

    def update_ticket(ticket)

    end

    def build_request(options = {})
      type = options[:type] || nil
      object = options[:object] || 'Ticket'
      params = options[:params] || {}

      request = "#{@base_url}/api/v1/#{@account_id}/#{@dept_id}/#{object}"

      if type =~ /schema/i then
        request += "/schema"
      elsif type =~ /single/i then
        request += "/#{params[:id]}"
      else #all
        request += "/"
      end

      request += "?_token_=#{@token}"
      
      params.each_pair{|key,value|
        value = value.join(',') if value.class == Array
        request += "&#{key}=#{value}"
      }

      request
    end

    def get_request(request)
      resp = @client.get(request)
      resp.body
    end

    def put_request(request, data)
      resp = @client.put(request, data)
      resp.body
    end

    def post_request(request, data)
    end

    def parse_response(response)
      Nokogiri::Slop(response)
    end
  end
end
