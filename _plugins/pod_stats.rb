# frozen_string_literal: true

##
# Fetches Github stats data for each fellow and injects it into the
# stats template
module PodStats
  require 'net/http'
  require 'json'
  class StatsGenerator < Jekyll::Generator
    safe true

    def generate(site)
      # list of MLH repos the pod is working on
      repos = [{ 'name' => 'prep-portfolio-23.APR.PREP.1',
                 'owner' => 'MLH-Fellowship'}]
      fellows = site.data['fellows']

      contributors = [] # array of merged pull requests
      repos.each do |repo|
        # TODO: get other stats
        # TODO: proper error handling in API call and parsing?
        #uri = URI("https://api.github.com/repos/#{repo['owner']}/#{repo['name']}/pulls")
        uri = URI("https://api.github.com/repos/#{repo['owner']}/#{repo['name']}/stats/contributors")
        resp = Net::HTTP.get(uri)
        pulls = JSON.load(resp)
        pulls.each do |pull|
          # the "total" field in the JSON object should return the total contributions of the author for that week
          # note: this is only a list of dictionaries for the github username and contributions of the one repository we are working on, if there eventually has multiple repositories, then we may want a nested array instead. There might be a better data structure. 

          github_username = pull["author"]["login"]
          each_contribution = pull["total"]
          contributor = {"github_username": github_username, "contributions": each_contribution}
          contributors.push(contributor)

        end
        # the way of seeing if a pull request was merged is by checking
        # whether merged_at is nil
        # merged.concat(pulls.filter { |p| !p['merged_at'].nil? })
      end

      # array of merged pulls authors
      # authors = merged.map { |m| m['user']['login'] }

      fellows.each do |fellow|
        # TODO: update fellow['name'] with the actual key (e.g. fellow['github']) |||||||||||---> AGREED!
        # as soon as issue 13 gets solved
        # The fellow 'name' is not their username, but the usernames |||||||||||||||---> Assuming by this you mean not the github username correct?
        # haven't been yet added to _data/fellows.yml

        # select from the list of dictionaries where the contributor's name is 
        fellow_contributions = contributors.select { |c| c['github_username'] == fellow['name'] }.map { |c| c['contributions'] }
        #  access the first element (there should only be one blc github usernames are unique)
        fellow['merged_pulls'] = fellow_contributions[0]

        # fellow['merged_pulls'] = merged.count(fellow['name'])
      end

      # get leaderboard template and add fellows data
      # TODO: the stats template
      stats_page = site.pages.find { |page| page.name == 'stats.html' }
      stats_page.data['fellows'] = fellows
    end
  end
end

'''
JSON OBJECT returned by test.py script for /stats/contributions endpoint
[
    {
        "total": 1,
        "weeks": [
            {
                "w": 1679788800,
                "a": 701,
                "d": 0,
                "c": 1
            },
            {
                "w": 1680393600,
                "a": 0,
                "d": 0,
                "c": 0
            }
        ],
        "author": {
            "login": "sumana2001",
            "id": 63084088,
            "node_id": "MDQ6VXNlcjYzMDg0MDg4",
            "avatar_url": "https://avatars.githubusercontent.com/u/63084088?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/sumana2001",
            "html_url": "https://github.com/sumana2001",
            "followers_url": "https://api.github.com/users/sumana2001/followers",
            "following_url": "https://api.github.com/users/sumana2001/following{/other_user}",
            "gists_url": "https://api.github.com/users/sumana2001/gists{/gist_id}",
            "starred_url": "https://api.github.com/users/sumana2001/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/sumana2001/subscriptions",
            "organizations_url": "https://api.github.com/users/sumana2001/orgs",
            "repos_url": "https://api.github.com/users/sumana2001/repos",
            "events_url": "https://api.github.com/users/sumana2001/events{/privacy}",
            "received_events_url": "https://api.github.com/users/sumana2001/received_events",
            "type": "User",
            "site_admin": false
        }
    }
]
'''
