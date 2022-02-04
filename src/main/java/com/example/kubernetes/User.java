package com.example.kubernetes;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
@NoArgsConstructor
@ToString
@Setter
@Getter
public class User {

    @Id
    @GeneratedValue
    private Long id;

    private String name;
    private String email;
}
