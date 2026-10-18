package com.iunter.url_shortener.url_service.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;

@Entity
@Table(name = "urls")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Url {
	@Id
	private String shortUrl;
	private String longUrl;
	private Instant createdAt;
	private Instant expiredAt;

}
