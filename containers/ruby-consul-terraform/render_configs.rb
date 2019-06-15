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

def render_ctmpl(file_name, output_file_name, tmp_dir=nil)
  if tmp_dir.nil?
    tmp_dir = (Dir.pwd.split("/") - $base_dir.split("/")) * "/"
  end
  cmd_env = {
    "ENVIRONMENT" => ENV.fetch("ENV", ""),
    "SERVICE_VERSION" => ENV.fetch("SERVICE_VERSION", ""),
    "VAULT_ADDR" => ENV.fetch("VAULT_ADDR", ""),
    "TARGET_DOCKER_VERSION" => ENV.fetch("TARGET_DOCKER_VERSION", ""),
    "INSTANCE_TYPE" => ENV.fetch("INSTANCE_TYPE", ""),
    "HOST_TAG" => ENV.fetch("HOST_TAG", ""),
    "RUN_CONTEXT" => ENV.fetch("RUN_CONTEXT", ""),
    "DIR" => ENV.fetch("DIR", ""),
    "IMAGE" => ENV.fetch("IMAGE", ""),
    "APP_NAME" => ENV.fetch("APP_NAME", ""),
    "GOOGLE_PROJ" => ENV.fetch("GOOGLE_PROJ", ""),
    "GOOGLE_APPS_DOMAIN" => ENV.fetch("GOOGLE_APPS_DOMAIN", ""),
    "GOOGLE_APPS_ORGANIZATION_ID" => ENV.fetch("GOOGLE_APPS_ORGANIZATION_ID", ""),
    "GOOGLE_APPS_SUBDOMAIN" => ENV.fetch("GOOGLE_APPS_SUBDOMAIN", ""),
    "GCS_NAME_PREFIX" => ENV.fetch("GCS_NAME_PREFIX", ""),
    "DNS_DOMAIN" => ENV.fetch("DNS_DOMAIN", ""),
    "LDAP_BASE_DOMAIN" => ENV.fetch("LDAP_BASE_DOMAIN", ""),
    "INSTANCE_NAME" => ENV.fetch("INSTANCE_NAME", ""),
    "BUCKET_TAG" => ENV.fetch("BUCKET_TAG", "")
  }
  Open3.popen3(cmd_env, "/workbench/echo_vars.sh") { | i, o, e|
    puts o.read()
    puts e.read()
  }
end

if __FILE__ == $0
  $base_dir = Dir.pwd
  copy_file_from_github "configure.rb"
  render_ctmpl("a", "b")
  require "/data/configure.rb"
end
