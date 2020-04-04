package ch.martin.k8s.bff;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableFeignClients
public class BurnBabyBurn {

	public static void main(String[] args) {
		SpringApplication.run(BurnBabyBurn.class, args);
	}

}
