package io.aspenmesh.spring.micrometer.prometheus;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SimpleController {

  @Autowired
  private SimpleService simpleService;
  
  @Autowired
  private IPService ipService;

  @GetMapping("/hello")
  public String hello(HttpServletRequest request) {
    return simpleService.hello(ipService.getClientIp(request));
  }

  @GetMapping("/bye")
  public String bye(HttpServletRequest request) {
    return simpleService.bye(ipService.getClientIp(request));
  }

  @GetMapping("/**")
  void getAnythingelse(HttpServletResponse response) throws IOException {
    response.sendRedirect("/hello");
  }
}
