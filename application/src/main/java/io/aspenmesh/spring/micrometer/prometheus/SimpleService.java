package io.aspenmesh.spring.micrometer.prometheus;

import org.springframework.stereotype.Service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;

@Service
public class SimpleService {
  private static final Logger logger = LoggerFactory.getLogger(SimpleService.class);

  private final MeterRegistry meterRegistry;
  private Counter helloCounter;
  private Counter byeCounter;  

  public SimpleService(MeterRegistry meterRegistry) {
    this.meterRegistry = meterRegistry;
    initCounters();
  }

  private void initCounters() {
    helloCounter = Counter.builder("application.hello.requests")
                          .tag("type", "hello")
                          .description("The number of hello requests")
                          .register(meterRegistry);
    byeCounter = Counter.builder("application.bye.requests")
                        .tag("type", "bye")
                        .description("The number of bye requests")
                        .register(meterRegistry);
  }

  public String hello(String source) {
    helloCounter.increment(1.0);
    logger.info("Hello {}", source);
    return String.format("Hello %s", source);
  }

  public String bye(String source) {
    byeCounter.increment(1.0);
    logger.info("Bye {}", source);
    return String.format("Bye %s", source);
  }
}
