package com.sist.web.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.lettuce.core.RedisClient;
import io.lettuce.core.api.StatefulRedisConnection;
import io.lettuce.core.api.sync.RedisCommands;

@Configuration
public class RedisConfig {
    @Value("#{env['redis.host']}")
    private String host;

    @Value("#{env['redis.port']}")
    private String port;

    // RedisClient 빈 생성
    @Bean
    public RedisClient redisClient() {
        return RedisClient.create("redis://" + host + ":" + port);
    }

    // RedisConnection 빈 생성
    @Bean
    public StatefulRedisConnection<String, String> connection() {
        return redisClient().connect();
    }

    // RedisCommands 빈 생성 (동기 커맨드)
    @Bean
    public RedisCommands<String, String> syncCommands() {
        return connection().sync();
    }
}