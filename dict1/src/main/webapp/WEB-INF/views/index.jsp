<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Professional Dictionary App</title>
    <style>
        /* Reset and base */
        * {
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            margin: 0;
            padding: 0;
            color: #34495e;
        }
        a {
            color: #3498db;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }

        /* Container */
        .container {
            max-width: 960px;
            margin: 2rem auto;
            padding: 1rem 2rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }

        /* Header */
        header {
            text-align: center;
            padding-bottom: 1rem;
            border-bottom: 2px solid #ecf0f1;
        }
        header h1 {
            margin: 0;
            font-weight: 700;
            font-size: 2.8rem;
            color: #2c3e50;
            letter-spacing: 1.2px;
        }
        header p {
            color: #7f8c8d;
            font-size: 1.1rem;
            margin-top: 0.2rem;
        }

        /* Sections */
        section {
            margin-top: 2.5rem;
        }
        section h2 {
            font-weight: 600;
            font-size: 1.8rem;
            border-left: 5px solid #3498db;
            padding-left: 0.6rem;
            color: #2c3e50;
            margin-bottom: 1rem;
        }

        /* Form styles */
        form {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            align-items: center;
        }
        form input[type="text"] {
            flex-grow: 1;
            padding: 0.6rem 0.9rem;
            font-size: 1rem;
            border: 2px solid #dfe6e9;
            border-radius: 5px;
            transition: border-color 0.3s ease;
        }
        form input[type="text"]:focus {
            border-color: #3498db;
            outline: none;
        }
        form button {
            padding: 0.65rem 1.6rem;
            font-size: 1rem;
            font-weight: 600;
            border: none;
            border-radius: 5px;
            background-color: #3498db;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        form button:hover {
            background-color: #2980b9;
        }

        /* Word list */
        ul#wordList {
            list-style-type: none;
            padding-left: 0;
            max-height: 320px;
            overflow-y: auto;
            border: 1px solid #dfe6e9;
            border-radius: 5px;
            background: #fafafa;
        }
        ul#wordList li {
            padding: 0.7rem 1rem;
            border-bottom: 1px solid #dfe6e9;
            font-size: 1.1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        ul#wordList li:last-child {
            border-bottom: none;
        }
        ul#wordList li a {
            font-weight: 600;
            flex-shrink: 0;
            margin-right: 0.8rem;
        }
        ul#wordList li span {
            color: #7f8c8d;
            font-style: italic;
            flex-grow: 1;
            padding-left: 1rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* Search result */
        #searchResult {
            margin-top: 1rem;
            padding: 1rem;
            background: #dff0d8;
            color: #3c763d;
            border-radius: 5px;
            font-size: 1.2rem;
            min-height: 45px;
            box-shadow: 0 2px 6px rgba(46, 204, 113, 0.25);
            transition: all 0.3s ease;
        }
        #searchResult.error {
            background: #f2dede;
            color: #a94442;
            box-shadow: 0 2px 6px rgba(231, 76, 60, 0.25);
        }

        /* Responsive */
        @media (max-width: 600px) {
            form {
                flex-direction: column;
                align-items: stretch;
            }
            form input[type="text"], form button {
                width: 100%;
            }
            ul#wordList {
                max-height: 200px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Professional Dictionary</h1>
            <p>Search, add, and explore words with meanings</p>
        </header>

        <section id="addSection">
            <h2>Add a New Word</h2>
            <form id="addWordForm" autocomplete="off">
                <input type="text" id="word" name="word" placeholder="Word" required />
                <input type="text" id="meaning" name="meaning" placeholder="Meaning" required />
                <button type="submit">Add Word</button>
            </form>
        </section>

        <section id="allWordsSection">
            <h2>All Words</h2>
            <ul id="wordList" aria-live="polite" aria-label="List of dictionary words">
                <!-- words loaded here -->
            </ul>
        </section>

        <section id="searchSection">
            <h2>Search Word</h2>
            <form id="searchForm" autocomplete="off">
                <input type="text" id="searchWord" name="searchWord" placeholder="Enter word to search" required />
                <button type="submit">Search</button>
            </form>
            <div id="searchResult" role="alert" aria-live="assertive"></div>
        </section>
    </div>

    <script>
        const contextPath = '<%=request.getContextPath()%>';

        // Load all words and render
        async function loadWords() {
            try {
                const response = await fetch(contextPath + '/api/dictionary/all');
                const words = await response.json();
                const wordList = document.getElementById('wordList');
                wordList.innerHTML = '';
                words.forEach(({ word, meaning }) => {
                    const li = document.createElement('li');
                    const encodedWord = encodeURIComponent(word);
                    li.innerHTML = `<a href="${contextPath}/api/dictionary/ui/word/${encodedWord}" title="View details for ${word}">${word}</a><span>${meaning}</span>`;
                    wordList.appendChild(li);
                });
            } catch (error) {
                console.error('Error loading words:', error);
            }
        }

        // Add word handler
        document.getElementById('addWordForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const word = e.target.word.value.trim();
            const meaning = e.target.meaning.value.trim();

            if (!word || !meaning) {
                alert('Please fill in both Word and Meaning.');
                return;
            }

            try {
                const response = await fetch(contextPath + '/api/dictionary/add', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({word, meaning}),
                });

                if (response.ok) {
                    alert(`Word "${word}" added successfully!`);
                    e.target.reset();
                    loadWords();
                } else {
                    const errorMsg = await response.text();
                    alert('Error adding word: ' + errorMsg);
                }
            } catch (error) {
                alert('Network error. Try again.');
            }
        });

        // Search word handler
        document.getElementById('searchForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const searchWord = e.target.searchWord.value.trim();
            const resultDiv = document.getElementById('searchResult');

            if (!searchWord) {
                resultDiv.textContent = 'Please enter a word to search.';
                resultDiv.classList.add('error');
                return;
            }

            try {
                const response = await fetch(contextPath + '/api/dictionary/' + encodeURIComponent(searchWord));
                if (!response.ok) throw new Error('Word not found');
                const data = await response.json();
                resultDiv.textContent = data.meaning;
                resultDiv.classList.remove('error');
            } catch (err) {
                resultDiv.textContent = err.message;
                resultDiv.classList.add('error');
            }
        });

        // Initial load
        loadWords();
    </script>
</body>
</html>
