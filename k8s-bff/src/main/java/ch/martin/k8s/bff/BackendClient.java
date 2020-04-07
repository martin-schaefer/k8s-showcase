package ch.martin.k8s.bff;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * A REST client for the backend. The value of 'url' must match the name of the service object for k8s-be defined in Kubernetes.
 */
@FeignClient(name = "k8s-be", url = "http://k8s-be")
public interface BackendClient {

	@GetMapping("/")
	GreetingDto getGreeting(@RequestParam("name") String name);

}
