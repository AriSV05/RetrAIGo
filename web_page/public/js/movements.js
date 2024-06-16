document.addEventListener('DOMContentLoaded', () => {
    const container = document.querySelector('.container');
    const messageContainer = document.getElementById('message');
    const reloadButton = document.getElementById('reloadButton');

    const exito = false;

    function generatePuzzle(matrix, index) {
        const puzzleWrapper = document.createElement('div');
        puzzleWrapper.className = 'puzzle-wrapper';

        const numberLabel = document.createElement('div');
        numberLabel.className = 'number-label';
        numberLabel.textContent = `Movimiento ${index + 1}`;

        const puzzleContainer = document.createElement('div');
        puzzleContainer.className = 'puzzle-container';

        for (let row = 0; row < matrix.length; row++) {
            for (let col = 0; col < matrix[row].length; col++) {
                const value = matrix[row][col];
                const piece = document.createElement('div');
                piece.className = 'puzzle-piece';
                if (value === null) {
                    piece.classList.add('empty');
                } else {
                    piece.textContent = value;
                }
                puzzleContainer.appendChild(piece);
            }
        }

        puzzleWrapper.appendChild(numberLabel);
        puzzleWrapper.appendChild(puzzleContainer);

        return puzzleWrapper;
    }

    const matrices = [
        [
            [null, 1, 2],
            [3, 4, 5],
            [6, 7, 8]
        ],
        [
            [1, null, 2],
            [3, 4, 5],
            [6, 7, 8]
        ],
        [
            [1, 2, null],
            [3, 4, 5],
            [6, 7, 8]
        ],
        [
            [1, 2, 3],
            [null, 4, 5],
            [6, 7, 8]
        ]
    ];
 
    matrices.forEach((matrix, index) => {
        const puzzle = generatePuzzle(matrix, index);
        container.appendChild(puzzle);
    });

    if (!exito) {
        const message = document.createElement('p');
        message.textContent = "No se pudo llegar a la meta :(";
        messageContainer.appendChild(message);
    }

    reloadButton.addEventListener('click', () => {
        window.location.href = '../index.html';
    });
});
