package ch.martin.k8s.bff;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
public class GreetingController {

	private final BackendClient backendClient;
	private final String appName;

	public GreetingController(@NonNull BackendClient backendClient,
			@Value("${spring.application.name}") @NonNull String appName) {
		this.backendClient = backendClient;
		this.appName = appName;
	}

	@GetMapping("/greeting")
	public GreetingDto getGreeting(@RequestParam("name") String name) {
		String message = "Received from backend: " + backendClient.getGreeting(name).getMessage();
		log.info("{} will return: {}", appName, message);
		return new GreetingDto(message);
	}

}