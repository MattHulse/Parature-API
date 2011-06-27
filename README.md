# Parature-API #
This was a simple gem I wrote to facilitate interaction with the Parature API.

## Installation ##
Clone the repo and then run the following commands:
    bundle install  # install dependencies
    rake install    # build and install the gem

## Getting Started ##
You will need your Parature URL, Dev Token, AccountID, and DeptID

    require 'parature'

    BASEURL = "https://sn.parature.com"
    TOKEN = "abcdefg1234567890hijklmnopqrstuvwxyz0987654321"
    ACCOUNTID = 11223
    DEPTID = 33221

    p = Parature::Parature.new(BASEURL, TOKEN, ACCOUNTID, DEPTID)

    accounts = p.get_accounts

    puts accounts.length
    puts accounts.first.Account_Name.text
    puts accounts.last.Account_Name.text

    my_company = accounts.find {|node| node.Account_Name.text =~ /^My Company Name$/ and node['service-desk-uri'] }
    puts my_company
    id = my_company[:id]

    id = 1
    account = p.find_account_by_id(id)
    puts account

    p.set_related_accounts(1, %w(2 3 4 5 11243) )

## What's Next ##
This gem as it is meets my needs for interacting with Parature.  
I am releasing in the hopes that someone else may find it useful.
Use at your own risk.

