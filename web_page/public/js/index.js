document.addEventListener("DOMContentLoaded", () => {
  const container = document.querySelector(".container");
  const infoBtn = document.getElementById("infoBtn");
  const sendHammi = document.getElementById("sendHammi");
  const sendManh = document.getElementById("sendManh");
  const modal = document.getElementById("infoModal");
  const alertModal = document.getElementById("alertModal");
  const closeModalButtons = document.querySelectorAll(".close");
  generatePuzzle();

  infoBtn.onclick = () => {
    modal.style.display = "block";
  };

  closeModalButtons.forEach((button) => {
    button.onclick = () => {
      button.closest(".modal").style.display = "none";
    };
  });

  window.onclick = function (event) {
    if (event.target == modal) {
      modal.style.display = "none";
    } else if (event.target == alertModal) {
      alertModal.style.display = "none";
    }
  };

  function generatePuzzle() {
    for (let boardIndex = 0; boardIndex < boards.length; boardIndex++) {
      oneBoard = boards[boardIndex];

      const puzzleContainer = document.createElement("div");
      puzzleContainer.className = "puzzle-container";
      puzzleContainer.id = `${boardIndex}`;

      const radio = document.createElement("input");
      radio.type = "radio";
      radio.name = "puzzle";
      radio.className = "puzzle-radio";
      radio.value = boardIndex;

      for (let row = 0; row < oneBoard.length; row++) {
        for (let col = 0; col < oneBoard[row].length; col++) {
          const value = oneBoard[row][col];
          const piece = document.createElement("div");
          piece.className = "puzzle-piece";
          if (value === "empty") {
            piece.classList.add("empty");
            piece.textContent = "Empty";
          } else {
            piece.textContent = value;
          }
          puzzleContainer.appendChild(piece);
        }
        puzzleContainer.appendChild(radio);
        container.appendChild(puzzleContainer);
      }
    }
  }

  sendManh.addEventListener("click", () => {
    const selectedRadio = document.querySelector(
      'input[name="puzzle"]:checked'
    );

    if (selectedRadio) {
      const selectedPuzzle = boards[selectedRadio.value];

      const filasFormateadas = selectedPuzzle.map((fila) => `[${fila.join(", ")}]`);

      // Unir todas las filas formateadas con comas y rodear con corchetes externos
      const matrizFormateada = `[${filasFormateadas.join(", ")}]`;

      fetch("http://localhost:8000/playManhattan", {
        method: "POST",
        headers: {
          "Content-Type": "application/json", 
        },
        body: JSON.stringify({ initial: matrizFormateada }),
      })
        .then((response) => response.json())
        .then((data) => {
          console.log("Success:", data);
        })
        .catch((error) => {
          console.error("Error:", error);
        });

      //location.href ='../html/goal.html';
    } else {
      alertModal.style.display = "block";
    }
  });

  sendHammi.addEventListener("click", () => {
    const selectedRadio = document.querySelector(
      'input[name="puzzle"]:checked'
    );

    if (selectedRadio) {
      const selectedPuzzle = boards[selectedRadio.value];

      const filasFormateadas = selectedPuzzle.map((fila) => `[${fila.join(", ")}]`);

      // Unir todas las filas formateadas con comas y rodear con corchetes externos
      const matrizFormateada = `[${filasFormateadas.join(", ")}]`;

      fetch("http://localhost:8000/playHamming", {
        method: "POST",
        headers: {
          "Content-Type": "application/json", 
        },
        body: JSON.stringify({ initial: matrizFormateada }),
      })
        .then((response) => response.json())
        .then((data) => {
          console.log("Success:", data);
        })
        .catch((error) => {
          console.error("Error:", error);
        });

      //location.href ='../html/goal.html';
    } else {
      alertModal.style.display = "block";
    }
  });
});
