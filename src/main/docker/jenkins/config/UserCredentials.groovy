// Create user credentials
def user_credential = { instance, username, password ->
  // Set up the local user
  def hudsonRealm = new hudson.security.HudsonPrivateSecurityRealm(false)
  hudsonRealm.createAccount(username,password)
  instance.setSecurityRealm(hudsonRealm)
  println "Creating ${username} user credentials"
}
