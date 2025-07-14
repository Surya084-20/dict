package com.example.demo;

import com.example.demo.model.Word;
import com.example.demo.repository.WordRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
public class WordRepositoryTests {

    @Autowired
    private WordRepository wordRepository;

    @Test
    void testFindByWord() {
        // Assuming "boot" exists in DB with a meaning
        Word word = wordRepository.findByWord("boot").orElse(null);
        assertNotNull(word, "Word 'boot' should exist in DB");
        assertNotNull(word.getMeaning(), "Meaning should not be null");
        System.out.println("Word: " + word.getWord() + ", Meaning: " + word.getMeaning());
    }
}
