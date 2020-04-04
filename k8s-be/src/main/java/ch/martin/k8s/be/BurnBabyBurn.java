package ch.martin.k8s.be;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class BurnBabyBurn {

	public static void main(String[] args) {
		SpringApplication.run(BurnBabyBurn.class, args);
	}

}
