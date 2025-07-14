package com.example.demo.controller;

import com.example.demo.model.Word;
import com.example.demo.repository.WordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/api/dictionary")
public class DictionaryController {

    @Autowired
    private WordRepository wordRepository;

    // REST API: Add a word
    @PostMapping("/add")
    @ResponseBody
    public Word addWord(@RequestBody Word word) {
        return wordRepository.save(word);
    }

    // REST API: Get meaning by word
    @GetMapping("/{word}")
    @ResponseBody
    public Word getMeaning(@PathVariable String word) {
        return wordRepository.findByWord(word)
                .orElseThrow(() -> new RuntimeException("Word not found"));
    }

    // REST API: Get all words
    @GetMapping("/all")
    @ResponseBody
    public List<Word> getAllWords() {
        return wordRepository.findAll();
    }

    // UI: Show main dictionary page (index.jsp)
    @GetMapping("/ui")
    public String index() {
        return "index";  // resolves to /WEB-INF/views/index.jsp
    }

    // UI: Show wordDetails.jsp for specific word
    @GetMapping("/ui/word/{word}")
    public String showWordDetails(@PathVariable String word, Model model) {
        Optional<Word> wordOpt = wordRepository.findByWord(word);
        if (wordOpt.isPresent()) {
            model.addAttribute("wordDetail", wordOpt.get());
            model.addAttribute("errorMessage", null);
        } else {
            // Instead of sending null for wordDetail, better to just not add it
            model.addAttribute("errorMessage", "Word not found: " + word);
        }
        return "wordDetails";  // make sure your JSP handles both cases
    }
}
