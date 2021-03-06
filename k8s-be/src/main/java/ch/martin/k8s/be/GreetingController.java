package ch.martin.k8s.be;

import static net.logstash.logback.argument.StructuredArguments.keyValue;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;

@RestController
@RefreshScope
@Slf4j
public class GreetingController {

	private final String appName;
	private final String message;
	private int messageId = 1000;

	public GreetingController(@Value("${spring.application.name}") @NonNull String appName,
			@Value("${k8s-be.message}") @NonNull String message) {
		this.appName = appName;
		this.message = message;
	}

	@GetMapping("/")
	public GreetingDto getGreeting(@RequestParam("name") String name) {
		String returnedMessage = message + " to " + name + " from the K8S backend (version 1.1.0)! Time: "
				+ LocalDateTime.now();
		log.info("{} will return message: {}, messageId = {}", appName, message, keyValue("messageId", messageId++));
		log.error("Just another ugly error. But the stack trace will save your day.", new Exception("An Exception"));
		return new GreetingDto(returnedMessage);
	}

}