import requests
import json

#url = "https://api.github.com/repos/MLH-Fellowship/prep-portfolio-23.APR.PREP.1/stats/contributors"

url = "https://api.github.com/repos/MLH-Fellowship/prep-portfolio-23.APR.PREP.1/pulls"

# https://github.com/MLH-Fellowship/prep-portfolio-23.APR.PREP.1

headers = {
    "Authorization": "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"
}
# note this Personal Access Token was revoked cuz I leaked it like an idiot, generate a new one if you need to run this one again

response = requests.get(url, headers=headers)

if response.status_code == 200:
    data = response.json()
    print(json.dumps(data, indent=4))
else:
    print(f"Failed to retrieve contributors: {response.status_code} {response.reason}")


'''
The "total" field in the JSON response returned by the GitHub API endpoint https://api.github.com/repos/{owner}/{repo}/stats/contributors represents the total number of contributions made by the contributor in the given repository.

The "weeks" field is an array that contains the number of contributions made by the contributor for each week.

The "w" field is an integer representing the week's timestamp, expressed as the number of seconds since the Unix epoch.

The "a" field represents the number of additions made by the contributor in the given week.

The "d" field represents the number of deletions made by the contributor in the given week.

The "c" field represents the number of commits made by the contributor in the given week.
'''