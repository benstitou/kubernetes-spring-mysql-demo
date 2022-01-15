package com.example.kubernetes;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public List<User> getAllUsers() {
        // Add functional logic here: mapping, restrictions, authorisation, ...
        List<User> users = new ArrayList<>();
        userRepository.findAll().forEach(users::add);
        return users;
    }

    public User saveUser(User user) {
        // Add functional logic here: mapping, restrictions, authorisation, ...
        user.setId(null);
        return userRepository.save(user);
    }

}
