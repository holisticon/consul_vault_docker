package de.holisticon.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import lombok.extern.slf4j.Slf4j;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;
import java.sql.SQLException;


@SpringBootApplication
@Slf4j
public class DemoApplication {

  @Value("${spring.profiles.active:#{null}}")
  private String profiles;

  @Value("${spring.datasource.username}")
  private String username;

  @Value("${spring.datasource.password}")
  private String password;

  @Value("${other.username}")
  private String other;

  @Autowired
  private DataSource dataSource;

  public static void main(String[] args) {
    SpringApplication.run(DemoApplication.class, args);
  }

  @PostConstruct
  private void postConstruct() throws SQLException {
    log.debug("##########################");
    log.debug("profile(s): " + profiles);
    log.debug("username: " + username);
    log.debug("password: " + password);
    log.debug("other: " + other);

    dataSource.getConnection();
    log.debug("Successfully connected to database");
    log.debug("##########################");
  }

}
