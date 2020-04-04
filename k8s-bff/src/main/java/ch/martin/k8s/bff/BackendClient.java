package ch.martin.k8s.bff;

import static org.springframework.web.bind.annotation.RequestMethod.GET;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;

@FeignClient(name = "k8s-be", url = "http://k8s-be")
public interface BackendClient {

	@RequestMapping(method = GET, value = "/greeting")
	GreetingDto getGreeting(String name);

}
