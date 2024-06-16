document.addEventListener('DOMContentLoaded', () => {
    const container = document.querySelector('.container');
    const infoBtn = document.getElementById('infoBtn');
    const sendBtn = document.getElementById('sendBtn');
    const modal = document.getElementById('infoModal');
    const alertModal = document.getElementById('alertModal');
    const closeModalButtons = document.querySelectorAll('.close');

    sendBtn.disabled = true;

    infoBtn.onclick = () => {
        modal.style.display = "block";
    }

    closeModalButtons.forEach(button => {
        button.onclick = () => {
            button.closest('.modal').style.display = "none";
        }
    });

    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        } else if (event.target == alertModal) {
            alertModal.style.display = "none";
        }
    }

    function generatePuzzle(emptyRow, emptyCol, index) {
        const puzzleWrapper = document.createElement('div');
        puzzleWrapper.className = 'puzzle-wrapper';

        const puzzleContainer = document.createElement('div');
        puzzleContainer.className = 'puzzle-container';

        const radio = document.createElement('input');
        radio.type = 'radio';
        radio.name = 'puzzle';
        radio.className = 'puzzle-radio';
        radio.value = index;

        radio.addEventListener('change', () => {
            sendBtn.disabled = false;
        });

        const puzzle = [];
        let count = 1;

        for (let row = 0; row < 3; row++) {
            const puzzleRow = [];
            for (let col = 0; col < 3; col++) {
                if (row === emptyRow && col === emptyCol) {
                    puzzleRow.push(null);
                } else {
                    puzzleRow.push(count);
                    count++;
                }
            }
            puzzle.push(puzzleRow);
        }

        puzzleWrapper.dataset.puzzle = JSON.stringify(puzzle);

        for (let row = 0; row < puzzle.length; row++) {
            for (let col = 0; col < puzzle[row].length; col++) {
                const value = puzzle[row][col];
                const piece = document.createElement('div');
                piece.className = 'puzzle-piece';
                if (value === null) {
                    piece.classList.add('empty');
                    piece.textContent = 'Empty';
                } else {
                    piece.textContent = value;
                }
                puzzleContainer.appendChild(piece);
            }
        }

        puzzleWrapper.appendChild(puzzleContainer);
        puzzleWrapper.appendChild(radio);

        return puzzleWrapper;
    }


    const emptyPositions = [
        [0, 0], [0, 1], [0, 2],
        [1, 0], [1, 1], [1, 2],
        [2, 0]
    ];

    emptyPositions.forEach((position, index) => {
        const [emptyRow, emptyCol] = position;
        const puzzle = generatePuzzle(emptyRow, emptyCol, index);
        container.appendChild(puzzle);
    });

    document.querySelector('button:last-of-type').addEventListener('click', () => {
        const selectedRadio = document.querySelector('input[name="puzzle"]:checked');
        if (selectedRadio) {
            const selectedPuzzle = selectedRadio.parentElement.dataset.puzzle;
            console.log('Selected Puzzle:', selectedPuzzle);

            fetch('', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ puzzle: selectedPuzzle })
            }).then(response => response.json())
            .then(data => {
                console.log('Success:', data);
            }).catch((error) => {
                console.error('Error:', error);
            });
        } else {
            alert('Please select a puzzle first!');
        }

        location.href ='../html/movements.html';
    });
});
