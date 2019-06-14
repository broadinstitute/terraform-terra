require "json"
require "open3"
require "base64"
require "fileutils"

# curl --header "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/secret/dsp/github/dsdejenkins2/githubtoken

$git_repo = ENV.fetch("GIT_REPO", "firecloud-develop")
$git_branch = ENV.fetch("GIT_BRANCH", "dev")

def set_github_token()
  curl_cmd = [
      "curl",
      "-H", "X-Vault-Token: #{ENV.fetch("VAULT_TOKEN", "")}",
      "#{ENV.fetch("VAULT_ADDR")}/v1/secret/dsp/github/dsdejenkins2/githubtoken"
  ]
  Open3.popen3(*curl_cmd) { |stdin, stdout, stderr, wait_thread|
    response = JSON.load(stdout)
    $github_token = response["data"]["token"]
  }
end

def copy_file_from_github(path, output_file_name = nil, org = "broadinstitute", repo = $git_repo, branch = $git_branch)
  if output_file_name.nil?
    output_file_name = File.basename(path)
  end
  set_github_token
  curl_cmd = [
      "curl",
      "-H", "Authorization: token #{$github_token}",
      "https://api.github.com/repos/#{org}/#{repo}/contents/#{path}?ref=#{branch}"
  ]
  Open3.popen3(*curl_cmd) { |stdin, stdout, stderr, wait_thread|
    response = JSON.load(stdout)
    # This GitHub endpoint seems to always return the content as a base-64-encoded string, but
    # assert that just to be safe.
    unless response["encoding"] == "base64"
      STDERR.puts "Expected content to be base64 encoded:"
      STDERR.puts JSON.pretty_generate(response)
      exit 1
    end
    content = response["content"]
    File.write(output_file_name, Base64.decode64(content))
  }
end

if __FILE__ == $0
  copy_file_from_github "configure.rb"
end
