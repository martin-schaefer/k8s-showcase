package ch.martin.k8s.be;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;

@RestController
@RefreshScope
@Slf4j
public class HelloController {

	private final String appName;
	private final String message;

	public HelloController(@Value("${spring.application.name}") @NonNull String appName,
			@Value("${k8s-be.message}") @NonNull String message) {
		this.appName = appName;
		this.message = message;
	}

	@GetMapping("/greeting")
	public GreetingDto getGreeting(String name) {
		String returnedMessage = message + " to " + name + " from the K8S backend! (GET) Time: " + LocalDateTime.now();
		log.info("{} will return message: {}", appName, message);
		return new GreetingDto(returnedMessage);
	}

	@PostMapping("/greeting")
	public GreetingDto postGreeting(String name) {
		String returnedMessage = message + " to " + name + " from the K8S backend! (POST) Time: " + LocalDateTime.now();
		log.info("{} will return  message: {}", appName, message);
		return new GreetingDto(returnedMessage);
	}

}