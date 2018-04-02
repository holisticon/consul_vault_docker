package de.holisticon.security;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import javax.annotation.PostConstruct;


// tag::maven-spring-cloud-vault-include[]
@SpringBootApplication
@Slf4j
public class DemoApplication {

  @Value("${spring.profiles.active:#{null}}")
  private String profiles;

  @Value("${admin.user}")
  private String user;

  @Value("${admin.password}")
  private String password;
  // end::maven-spring-cloud-vault-include[]
  public static void main(String[] args) {
    SpringApplication.run(DemoApplication.class, args);
  }

  @PostConstruct
  private void postConstruct() {
    log.debug("##########################");
    log.debug("profile(s): " + profiles);
    log.debug("user: " + user);
    log.debug("password: " + password);
    log.debug("##########################");
  }

}
